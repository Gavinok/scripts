#!/usr/bin/env python3
"""Tailnet-local web UI for downloading URLs as tagged MP3s via yt-dlp.

Binds to this machine's Tailscale IP only, so the page is reachable from any
device on the tailnet (phone, laptop) and from nowhere else.

Usage:
    ./app.py                 # bind tailscale IP, port 8733
    ./app.py --port 9000
    ./app.py --host 127.0.0.1 --allow-any-host   # local testing
    ./app.py --check         # run preflight checks and exit
"""

from __future__ import annotations

import argparse
import html
import json
import os
import shutil
import subprocess
import sys
import threading
import time
import uuid
from collections import OrderedDict
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

DEFAULT_PORT = 8733
MUSIC_DIR = Path(os.environ.get("YTDL_WEB_MUSIC_DIR", Path.home() / "Music"))
MAX_JOBS_KEPT = 50
MAX_CONCURRENT = 2
JOB_TIMEOUT = 60 * 60  # seconds; a long album rip still fits

# yt-dlp writes here; %(artist)s falls back to uploader when tags are absent.
OUTPUT_TEMPLATE = "%(artist,uploader,channel|Unknown Artist)s/%(album,playlist_title|Singles)s/%(title)s.%(ext)s"


# --------------------------------------------------------------------------
# preflight
# --------------------------------------------------------------------------


class PreflightError(Exception):
    pass


def _run(cmd: list[str], timeout: int = 15) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)


def tailscale_ip() -> str | None:
    """Return this node's IPv4 tailnet address, or None if unavailable."""
    exe = shutil.which("tailscale")
    if not exe:
        return None
    try:
        proc = _run([exe, "ip", "-4"])
    except (OSError, subprocess.SubprocessError):
        return None
    if proc.returncode != 0:
        return None
    for line in proc.stdout.splitlines():
        addr = line.strip()
        if addr.startswith("100."):  # CGNAT range Tailscale hands out
            return addr
    return None


def tailscale_dns_name() -> str | None:
    """This node's MagicDNS name, or None when MagicDNS is off."""
    exe = shutil.which("tailscale")
    if not exe:
        return None
    try:
        proc = _run([exe, "status", "--json"])
        if proc.returncode != 0:
            return None
        data = json.loads(proc.stdout)
    except (OSError, subprocess.SubprocessError, json.JSONDecodeError):
        return None
    if not (data.get("CurrentTailnet") or {}).get("MagicDNSEnabled"):
        return None
    return (data.get("Self") or {}).get("DNSName", "").rstrip(".") or None


def tailscale_status() -> tuple[bool, str]:
    """(healthy, human-readable detail) for the local tailscaled."""
    exe = shutil.which("tailscale")
    if not exe:
        return False, "tailscale binary not found in PATH"
    try:
        proc = _run([exe, "status", "--json"])
    except (OSError, subprocess.SubprocessError) as exc:
        return False, f"tailscale status failed: {exc}"
    if proc.returncode != 0:
        return False, (proc.stderr.strip() or "tailscale status returned non-zero")
    try:
        data = json.loads(proc.stdout)
    except json.JSONDecodeError:
        return False, "could not parse tailscale status output"
    state = data.get("BackendState", "Unknown")
    if state != "Running":
        return False, f"tailscale backend state is {state!r} (try: tailscale up)"
    name = (data.get("Self") or {}).get("DNSName", "").rstrip(".")
    return True, f"running as {name or 'unknown host'}"


def preflight(require_tailscale: bool) -> dict[str, str]:
    """Verify every external dependency up front. Raises PreflightError."""
    report: dict[str, str] = {}
    problems: list[str] = []

    for tool, hint in (
        ("yt-dlp", "install with: pipx install yt-dlp   (or: pacman -S yt-dlp)"),
        ("ffmpeg", "required for mp3 transcoding; install with: pacman -S ffmpeg"),
    ):
        path = shutil.which(tool)
        if not path:
            problems.append(f"{tool} not found in PATH — {hint}")
            continue
        try:
            proc = _run([path, "--version"])
            version = proc.stdout.splitlines()[0] if proc.stdout else "unknown"
        except (OSError, subprocess.SubprocessError, IndexError):
            version = "unknown"
        report[tool] = f"{path} ({version})"

    ok, detail = tailscale_status()
    report["tailscale"] = detail
    if not ok and require_tailscale:
        problems.append(f"tailscale not usable — {detail}")

    try:
        MUSIC_DIR.mkdir(parents=True, exist_ok=True)
        probe = MUSIC_DIR / f".ytdl-web-write-test-{os.getpid()}"
        probe.write_text("ok")
        probe.unlink()
        report["music dir"] = f"{MUSIC_DIR} (writable)"
    except OSError as exc:
        problems.append(f"music dir {MUSIC_DIR} not writable — {exc}")

    if problems:
        raise PreflightError("\n".join(f"  - {p}" for p in problems))
    return report


# --------------------------------------------------------------------------
# job tracking
# --------------------------------------------------------------------------


class Job:
    def __init__(self, url: str):
        self.id = uuid.uuid4().hex[:12]
        self.url = url
        self.state = "queued"  # queued | running | done | error
        self.title = ""
        self.message = ""
        self.percent = 0.0
        self.files: list[str] = []
        self.created = time.time()

    def as_dict(self) -> dict:
        return {
            "id": self.id,
            "url": self.url,
            "state": self.state,
            "title": self.title,
            "message": self.message,
            "percent": round(self.percent, 1),
            "files": self.files,
            "created": self.created,
        }


class JobStore:
    def __init__(self) -> None:
        self._jobs: OrderedDict[str, Job] = OrderedDict()
        self._lock = threading.Lock()

    def add(self, job: Job) -> None:
        with self._lock:
            self._jobs[job.id] = job
            while len(self._jobs) > MAX_JOBS_KEPT:
                # drop the oldest finished job; never evict live work
                for jid, j in list(self._jobs.items()):
                    if j.state in ("done", "error"):
                        del self._jobs[jid]
                        break
                else:
                    break

    def snapshot(self) -> list[dict]:
        with self._lock:
            return [j.as_dict() for j in reversed(self._jobs.values())]


JOBS = JobStore()
SLOTS = threading.Semaphore(MAX_CONCURRENT)


def valid_url(raw: str) -> str | None:
    """Accept only http(s) URLs with a host. Returns normalized URL or None."""
    raw = raw.strip()
    if not raw or len(raw) > 2048:
        return None
    parsed = urlparse(raw)
    if parsed.scheme not in ("http", "https") or not parsed.netloc:
        return None
    return raw


def build_command(url: str) -> list[str]:
    return [
        shutil.which("yt-dlp") or "yt-dlp",
        "--newline",                     # one progress line at a time, parseable
        "--no-colors",
        "--ignore-config",               # ignore ~/.config/yt-dlp so behavior is predictable
        "--no-playlist",                 # a URL with &list= means the track, not the album
        "--extract-audio",
        "--audio-format", "mp3",
        "--audio-quality", "0",
        "--embed-metadata",
        "--embed-thumbnail",
        "--add-metadata",
        # Split "Artist - Title" video names into real tags when the site gives none.
        "--parse-metadata", "%(title)s:%(?P<artist>.+?) - (?P<track>.+)",
        "--parse-metadata", "%(release_year,upload_date>%Y)s:%(meta_date)s",
        "--replace-in-metadata", "artist,album,title", r"[/\\]", "_",
        "--restrict-filenames",          # ASCII-safe names; survives phone/SMB transfers
        "--windows-filenames",
        "--no-overwrites",
        "--retries", "5",
        "--fragment-retries", "5",
        "--socket-timeout", "30",
        "--paths", str(MUSIC_DIR),
        "--output", OUTPUT_TEMPLATE,
        "--print", "after_move:FINAL\t%(filepath)s",
        "--print", "before_dl:TITLE\t%(title)s",
        url,
    ]


def run_job(job: Job) -> None:
    with SLOTS:
        job.state = "running"
        job.message = "starting yt-dlp"
        cmd = build_command(job.url)
        tail: list[str] = []
        try:
            proc = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1,
            )
        except OSError as exc:
            job.state, job.message = "error", f"could not launch yt-dlp: {exc}"
            return

        watchdog = threading.Timer(JOB_TIMEOUT, proc.kill)
        watchdog.daemon = True
        watchdog.start()
        try:
            assert proc.stdout is not None
            for line in proc.stdout:
                line = line.rstrip("\n")
                if not line:
                    continue
                tail.append(line)
                del tail[:-15]
                if line.startswith("FINAL\t"):
                    path = line.split("\t", 1)[1]
                    job.files.append(path)
                    job.message = f"saved {Path(path).name}"
                elif line.startswith("TITLE\t"):
                    job.title = line.split("\t", 1)[1]
                elif "[download]" in line and "%" in line:
                    job.percent = _parse_percent(line, job.percent)
                    job.message = line.strip()
                elif line.startswith("WARNING:"):
                    # e.g. the music.youtube.com -> www.youtube.com redirect notice;
                    # yt-dlp recovers on its own, so don't show it as the status.
                    pass
                else:
                    job.message = line.strip()
            code = proc.wait()
        finally:
            watchdog.cancel()

        if code == 0 and job.files:
            job.state, job.percent = "done", 100.0
            job.message = f"saved {len(job.files)} file(s)"
        elif code == 0:
            job.state = "error"
            job.message = "yt-dlp exited cleanly but produced no file (already downloaded?)"
        else:
            job.state = "error"
            job.message = f"yt-dlp exited {code}: " + " | ".join(tail[-3:])


def _parse_percent(line: str, fallback: float) -> float:
    for token in line.split():
        if token.endswith("%"):
            try:
                return float(token[:-1])
            except ValueError:
                return fallback
    return fallback


# --------------------------------------------------------------------------
# http
# --------------------------------------------------------------------------

PAGE = """<!doctype html>
<html lang="en"><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="color-scheme" content="dark light">
<title>Music Grabber</title>
<style>
  :root {{ --bg:#14161a; --fg:#e8eaed; --dim:#9aa0a6; --card:#1e2126; --line:#2c3038; --ok:#7ee787; --err:#ff7b72; --accent:#58a6ff; }}
  * {{ box-sizing:border-box; }}
  body {{ margin:0; padding:1rem calc(1rem + env(safe-area-inset-left)) 3rem;
         font:16px/1.5 system-ui,-apple-system,sans-serif; background:var(--bg); color:var(--fg); }}
  h1 {{ font-size:1.15rem; margin:.2rem 0 1rem; font-weight:600; }}
  h1 small {{ color:var(--dim); font-weight:400; display:block; font-size:.75rem; margin-top:.2rem; }}
  form {{ display:flex; gap:.5rem; flex-wrap:wrap; }}
  input[type=url] {{ flex:1 1 14rem; min-width:0; padding:.85rem; font-size:1rem;
      border-radius:.6rem; border:1px solid var(--line); background:var(--card); color:var(--fg); }}
  input[type=url]:focus {{ outline:2px solid var(--accent); outline-offset:1px; }}
  button {{ padding:.85rem 1.3rem; font-size:1rem; font-weight:600; border:0; border-radius:.6rem;
      background:var(--accent); color:#06101f; }}
  button:disabled {{ opacity:.5; }}
  #flash {{ margin:.75rem 0 0; min-height:1.2rem; font-size:.9rem; color:var(--err); }}
  ul {{ list-style:none; padding:0; margin:1.25rem 0 0; }}
  li {{ background:var(--card); border:1px solid var(--line); border-radius:.6rem;
        padding:.7rem .85rem; margin-bottom:.6rem; }}
  .t {{ font-weight:600; word-break:break-word; }}
  .m {{ color:var(--dim); font-size:.8rem; word-break:break-word; margin-top:.15rem; }}
  .bar {{ height:5px; border-radius:3px; background:var(--line); margin-top:.5rem; overflow:hidden; }}
  .bar i {{ display:block; height:100%; background:var(--accent); transition:width .3s; }}
  .done .t::after {{ content:" OK"; color:var(--ok); font-size:.75rem; }}
  .error .t::after {{ content:" FAILED"; color:var(--err); font-size:.75rem; }}
  .error .bar i {{ background:var(--err); }}
</style></head><body>
<h1>Music Grabber<small>saving to {music_dir}</small></h1>
<form id="f"><input id="u" type="url" name="url" placeholder="Paste a link" required
   autocomplete="off" autocapitalize="off" spellcheck="false"><button id="b">Download</button></form>
<p id="flash"></p>
<ul id="jobs"></ul>
<script>
const f=document.getElementById('f'),u=document.getElementById('u'),
      b=document.getElementById('b'),flash=document.getElementById('flash'),
      list=document.getElementById('jobs');
f.addEventListener('submit',async e=>{{
  e.preventDefault(); flash.textContent=''; b.disabled=true;
  try {{
    const r=await fetch('/submit',{{method:'POST',
      headers:{{'Content-Type':'application/x-www-form-urlencoded'}},
      body:new URLSearchParams({{url:u.value}})}});
    const d=await r.json().catch(()=>({{error:'bad server response'}}));
    if(!r.ok){{flash.textContent=d.error||('error '+r.status);}} else {{u.value=''; render(d.jobs);}}
  }} catch(err) {{ flash.textContent='network error: '+err.message; }}
  finally {{ b.disabled=false; }}
}});
function render(jobs){{
  list.innerHTML='';
  for(const j of jobs){{
    const li=document.createElement('li'); li.className=j.state;
    const t=document.createElement('div'); t.className='t'; t.textContent=j.title||j.url;
    const m=document.createElement('div'); m.className='m'; m.textContent=j.message||j.state;
    const bar=document.createElement('div'); bar.className='bar';
    const i=document.createElement('i'); i.style.width=(j.percent||0)+'%';
    bar.appendChild(i); li.append(t,m,bar); list.appendChild(li);
  }}
}}
async function poll(){{
  try{{ const r=await fetch('/jobs'); if(r.ok) render((await r.json()).jobs); }}catch(e){{}}
  setTimeout(poll,1500);
}}
poll();
</script></body></html>
"""


class Handler(BaseHTTPRequestHandler):
    server_version = "ytdl-web/1.0"
    protocol_version = "HTTP/1.1"

    def _send(self, code: int, body: bytes, ctype: str) -> None:
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(body)

    def _json(self, code: int, payload: dict) -> None:
        self._send(code, json.dumps(payload).encode(), "application/json; charset=utf-8")

    def do_GET(self) -> None:  # noqa: N802
        path = urlparse(self.path).path
        if path == "/":
            page = PAGE.format(music_dir=html.escape(str(MUSIC_DIR)))
            self._send(HTTPStatus.OK, page.encode(), "text/html; charset=utf-8")
        elif path == "/jobs":
            self._json(HTTPStatus.OK, {"jobs": JOBS.snapshot()})
        elif path == "/healthz":
            self._json(HTTPStatus.OK, {"ok": True})
        else:
            self._json(HTTPStatus.NOT_FOUND, {"error": "not found"})

    def do_POST(self) -> None:  # noqa: N802
        if urlparse(self.path).path != "/submit":
            self._json(HTTPStatus.NOT_FOUND, {"error": "not found"})
            return
        try:
            length = int(self.headers.get("Content-Length") or 0)
        except ValueError:
            length = 0
        if not 0 < length <= 8192:
            self._json(HTTPStatus.BAD_REQUEST, {"error": "missing or oversized body"})
            return
        raw = self.rfile.read(length).decode("utf-8", "replace")
        url = valid_url((parse_qs(raw).get("url") or [""])[0])
        if not url:
            self._json(HTTPStatus.BAD_REQUEST, {"error": "give a valid http(s) URL"})
            return

        job = Job(url)
        JOBS.add(job)
        threading.Thread(target=run_job, args=(job,), daemon=True).start()
        self._json(HTTPStatus.ACCEPTED, {"jobs": JOBS.snapshot()})

    def log_message(self, fmt: str, *args) -> None:
        sys.stderr.write("%s %s\n" % (self.address_string(), fmt % args))


# --------------------------------------------------------------------------
# entry point
# --------------------------------------------------------------------------


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", help="bind address (default: this node's Tailscale IP)")
    ap.add_argument("--port", type=int, default=DEFAULT_PORT)
    ap.add_argument("--allow-any-host", action="store_true",
                    help="skip the Tailscale requirement (for local testing only)")
    ap.add_argument("--check", action="store_true", help="run preflight checks and exit")
    args = ap.parse_args()

    require_ts = not (args.host or args.allow_any_host)
    try:
        report = preflight(require_tailscale=require_ts)
    except PreflightError as exc:
        print("Preflight failed:\n" + str(exc), file=sys.stderr)
        return 1
    for key, value in report.items():
        print(f"  ok  {key}: {value}")
    if args.check:
        print("All checks passed.")
        return 0

    host = args.host
    if not host:
        host = tailscale_ip()
        if not host:
            print("Could not determine Tailscale IPv4 address. Is `tailscale up` done?\n"
                  "Override with --host <addr> --allow-any-host.", file=sys.stderr)
            return 1

    try:
        httpd = ThreadingHTTPServer((host, args.port), Handler)
    except OSError as exc:
        print(f"Cannot bind {host}:{args.port} — {exc}", file=sys.stderr)
        return 1
    httpd.daemon_threads = True

    dns = tailscale_dns_name()
    print("\nOpen on any tailnet device (plain http — this server has no TLS):")
    if dns:
        print(f"  http://{dns}:{args.port}/")
        short = dns.split(".", 1)[0]
        print(f"  http://{short}:{args.port}/           (short name, needs MagicDNS search domain)")
    print(f"  http://{host}:{args.port}/")
    print(f"\nDownloads land in:  {MUSIC_DIR}")
    # stdout is block-buffered under redirection (systemd journal, log files);
    # flush so the banner is visible before serve_forever blocks.
    print("Ctrl-C to stop.\n", flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down.")
    finally:
        httpd.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
