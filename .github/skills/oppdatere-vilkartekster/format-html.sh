#!/usr/bin/env bash
# Formaterer internt_vedtak.html i tilleggsstonader-sak via IntelliJs MCP-server (reformat_file).
# Bruk: format-html.sh <absolutt sti til tilleggsstonader-sak>
# Krever at IntelliJ kjører med prosjektet åpent og at MCP-serveren er slått på.
set -euo pipefail

PROSJEKT="${1:?Oppgi absolutt sti til tilleggsstonader-sak}"
URL="${IJ_MCP_URL:-http://127.0.0.1:64342/stream}"
DIR="src/test/resources/interntVedtak"
MAKS_LINJER_DIFF=50
HEADERE=(-H 'Content-Type: application/json' -H 'Accept: application/json, text/event-stream')

filer_json() {
  (cd "$PROSJEKT" && ls "$DIR"/*/internt_vedtak.html | python3 -c 'import sys,json;print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')
}

formater() {
  local filer="$1" sesjon
  sesjon=$(curl -s -m 10 -D - -o /dev/null -X POST "$URL" "${HEADERE[@]}" \
    -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"copilot-cli","version":"1"}}}' \
    | grep -i '^mcp-session-id' | cut -d' ' -f2 | tr -d '\r')
  [ -n "$sesjon" ] || { echo "Fikk ikke MCP-sesjon fra $URL" >&2; return 1; }
  curl -s -m 10 -X POST "$URL" "${HEADERE[@]}" -H "mcp-session-id: $sesjon" \
    -d '{"jsonrpc":"2.0","method":"notifications/initialized"}' -o /dev/null
  curl -s -m 120 -X POST "$URL" "${HEADERE[@]}" -H "mcp-session-id: $sesjon" \
    -d "{\"jsonrpc\":\"2.0\",\"id\":2,\"method\":\"tools/call\",\"params\":{\"name\":\"reformat_file\",\"arguments\":{\"projectPath\":\"$PROSJEKT\",\"files\":$filer}}}" \
    | grep -q '"isError":false'
}

# Filer med mer enn MAKS_LINJER_DIFF endrede linjer regnes som uformaterte.
uformaterte() {
  git -C "$PROSJEKT" -c core.quotepath=false diff --numstat -- "$DIR/*/internt_vedtak.html" \
    | awk -v maks="$MAKS_LINJER_DIFF" '$1 + $2 > maks { print $3 }'
}

# IntelliJ kan ha utdatert versjon av filer som nettopp ble skrevet utenfra.
sleep 5
formater "$(filer_json)"

for forsok in 1 2 3; do
  sleep 3 # reformat_file svarer før IntelliJ har skrevet filene til disk
  ufor=$(uformaterte)
  [ -z "$ufor" ] && { echo "Alle html-filer er formatert"; exit 0; }
  echo "Forsøk $forsok: fortsatt uformaterte filer:" >&2
  echo "$ufor" >&2
  sleep 5
  formater "$(echo "$ufor" | python3 -c 'import sys,json;print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))')"
done

echo "Klarte ikke å formatere alle filer. Be brukeren kjøre Reformat Code i IntelliJ." >&2
exit 1
