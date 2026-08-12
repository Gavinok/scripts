# ytdl-web

Tailnet-only web page for turning a pasted URL into a tagged MP3 in `~/Music`.
Single file, standard library only — no `pip install` required.

## Run

```bash
~/.scripts/ytdl-web/app.py            # binds this machine's Tailscale IP, port 8733
~/.scripts/ytdl-web/app.py --check    # run preflight checks and exit
```

Then on your phone (same tailnet): `http://100.105.108.111:8733/`
or by MagicDNS name: `http://love:8733/`

## Flags

| Flag | Meaning |
|---|---|
| `--host ADDR` | Bind a specific address instead of the Tailscale IP |
| `--port N` | Port (default 8733) |
| `--allow-any-host` | Skip the Tailscale requirement (local testing) |
| `--check` | Preflight only |

`YTDL_WEB_MUSIC_DIR` overrides the destination directory.

## What it checks before serving

- `yt-dlp` and `ffmpeg` are on `PATH` and runnable (version captured)
- `tailscaled` backend state is `Running` (else it tells you to `tailscale up`)
- The music directory exists and is actually writable (write probe, not just `os.access`)
- The bind address resolves to a `100.x` tailnet IP; refuses to guess otherwise

## Behavior

- Files land in `~/Music/<artist>/<album|Singles>/<title>.mp3`, best audio quality,
  with metadata and cover art embedded. `Artist - Title` video names are split into
  real tags when the site provides none.
- Downloads run in background threads, max 2 at once, one-hour watchdog per job.
- The page polls `/jobs` every 1.5 s for live progress; errors show the last lines
  of yt-dlp output instead of a generic failure.
- Only `http`/`https` URLs are accepted; request bodies are capped at 8 KB.
- `--ignore-config` means your personal `yt-dlp.conf` cannot change behavior here.

## Security note

There is no authentication. Anything that can reach the bind address can queue a
download on this machine. That is fine on a private tailnet — do not expose the
port to the LAN or the internet, and do not enable `tailscale funnel` for it.

## Run at login (optional)

```bash
mkdir -p ~/.config/systemd/user
cp ~/.scripts/ytdl-web/ytdl-web.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now ytdl-web
journalctl --user -u ytdl-web -f
```
