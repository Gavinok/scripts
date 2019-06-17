#!/usr/bin/env dash
#
# surf_linkselect.sh:
#  Usage:
#    curl somesite.com | surf_linkselect [SURFWINDOWID] [PROMPT]
#
#  Description:
#    Given an HTML body as STDIN, extracts links via xmllint & provides list
#    to dmenu with each link paired with its associated content. Selected
#    link is then normalized based on the passed surf window's URI and the
#    result is printed to STDOUT.
#
#  Dependencies:
#    xmllint, awk, dmenu, dash

dump_links_with_titles() {
  awk '{
    input = $0;

    $0 = input;
    gsub("<[^>]*>", "");
    gsub(/[ ]+/, " ");
    $1 = $1;
    title = ($0 == "" ? "None" : $0);

    $0 = input;
    match($0, /\<[ ]*[aA][^>]* [hH][rR][eE][fF]=["]([^"]+)["]/, linkextract);
    $0 = linkextract[1];
    gsub("[ ]", "%20");
    link = $0;

    print title ": " link;
  }'
}

link_normalize() {
  URI=$1
  # URI=$( echo "$1" | sed 's/^\/\//https:\/\//')
  # notify-send $URI; 
  awk -v uri="$URI" '{
    if ($0 ~ /^https?:\/\//  || $0 ~ /^\/\/.+$/) {
      print $0;
    } else if ($0 ~/^#/) {
      gsub(/[#?][^#?]+/, "", uri);
      print uri $0;
    } else if ($0 ~/^\//) {
      split(uri, uri_parts, "/");
      print uri_parts[3] $0;
    } else {
      gsub(/[#][^#]+/, "", uri);
      uri_parts_size = split(uri, uri_parts, "/");
      delete uri_parts[uri_parts_size];
      for (v in uri_parts) {
        uri_pagestripped = uri_pagestripped uri_parts[v] "/"
      }
      print uri_pagestripped $0;
    }
  }'
}

link_select() {
  SURF_WINDOW=$1
  DMENU_PROMPT=$2
  tr -d '\n\r' |
    xmllint --html --xpath "//a" - |
    dump_links_with_titles |
    sort |
    uniq |
    dmenu -p "$DMENU_PROMPT" -l 10 -i -w "$SURF_WINDOW" |
    awk -F' ' '{print $NF}' | 
    # sed 's/^\/\//https:\/\//' |
    link_normalize "$(xprop -id "$SURF_WINDOW" _SURF_URI | cut -d '"' -f 2)"
}

link_select "$1" "$2"
