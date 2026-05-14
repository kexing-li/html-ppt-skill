#!/usr/bin/env bash
# html-studio :: bundle.sh — pack a Deck or Page HTML into a single self-contained file
#
# Usage:
#   bundle.sh <input.html>                # → dist/<basename>.html
#   bundle.sh <input.html> <out-dir>      # → <out-dir>/<basename>.html
#
# Inlines all <link rel="stylesheet" href="..."> and <script src="...">
# references. Local paths are resolved relative to the input file's directory.
# CDN URLs are fetched via curl. Output is a single self-contained HTML file.

set -euo pipefail

FILE="${1:-}"
if [[ -z "$FILE" ]]; then
  echo "usage: bundle.sh <input.html> [out-dir]" >&2
  exit 1
fi
if [[ ! -f "$FILE" ]]; then
  echo "error: $FILE not found" >&2
  exit 1
fi

OUT_DIR="${2:-dist}"
INPUT_DIR="$(cd "$(dirname "$FILE")" && pwd)"
BASE=$(basename "$FILE")

mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/$BASE"

# Copy input to output — we'll modify the output file in place.
cp "$FILE" "$OUT"

CSS_COUNT=0
JS_COUNT=0

# Resolve href/src to an absolute path or leave as-is for URLs.
resolve() {
  local p="$1"
  if [[ "$p" == http://* || "$p" == https://* ]]; then
    echo "$p"
  else
    echo "$INPUT_DIR/$p"
  fi
}

# ---- inline <link rel="stylesheet" href="..."> ----
# Collect all link tags first, then process each one against the output file.
links=$(grep -o '<link[^>]*rel="stylesheet"[^>]*href="[^"]*"[^>]*>' "$OUT" || true)
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  href=$(echo "$tag" | sed -n 's/.*href="\([^"]*\)".*/\1/p')
  [[ -z "$href" ]] && continue

  src=$(resolve "$href")
  if [[ "$src" == http://* || "$src" == https://* ]]; then
    content=$(curl -sSL --max-time 15 "$src" 2>/dev/null) || { echo "  ⚠ CDN fetch failed: $src" >&2; continue; }
  elif [[ -f "$src" ]]; then
    content=$(cat "$src")
  else
    echo "  ⚠ file not found: $src" >&2
    continue
  fi

  # Use perl to replace the exact tag with <style>content</style>.
  # \Q...\E quotes the tag literal. Content passed via env to avoid shell escaping issues.
  PERL_TAG="$tag" PERL_CONTENT="$content" perl -i -0777 -pe \
    's{\Q$ENV{PERL_TAG}\E}{<style>\n$ENV{PERL_CONTENT}\n</style>}' "$OUT"
  CSS_COUNT=$((CSS_COUNT + 1))
done <<< "$links"

# ---- inline <script src="..."> ----
scripts=$(grep -o '<script[^>]*src="[^"]*"[^>]*></script>' "$OUT" || true)
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  src_url=$(echo "$tag" | sed -n 's/.*src="\([^"]*\)".*/\1/p')
  [[ -z "$src_url" ]] && continue

  src=$(resolve "$src_url")
  if [[ "$src" == http://* || "$src" == https://* ]]; then
    content=$(curl -sSL --max-time 15 "$src" 2>/dev/null) || { echo "  ⚠ CDN fetch failed: $src" >&2; continue; }
  elif [[ -f "$src" ]]; then
    content=$(cat "$src")
  else
    echo "  ⚠ file not found: $src" >&2
    continue
  fi

  PERL_TAG="$tag" PERL_CONTENT="$content" perl -i -0777 -pe \
    's{\Q$ENV{PERL_TAG}\E}{<script>\n$ENV{PERL_CONTENT}\n</script>}' "$OUT"
  JS_COUNT=$((JS_COUNT + 1))
done <<< "$scripts"

echo "→ $OUT ($CSS_COUNT CSS + $JS_COUNT JS inlined)"
