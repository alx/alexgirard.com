#!/usr/bin/env bash
# sync-md.sh — emit per-page Markdown sources into the build output so the
# Netlify edge handler (netlify/edge-handlers/md.mjs) can serve a
# text/markdown variant for Accept: text/markdown.
#
# Run AFTER `hugo` has written public/ (i.e. at the end of the deploy build):
#   hugo --gc --minify --baseURL https://alexgirard.com/ && bash scripts/sync-md.sh
#
# The trust pages are authored in Markdown already; we strip the Hugo YAML
# front matter and copy the body to <page>/index.md. The homepage markdown
# is a curated source file (netlify/homepage.md).
#
# NOTE: GitHub Pages does not consume these files (it cannot negotiate by
# Accept). This step is only meaningful on the Netlify reference deploy. It is
# safe and cheap to run regardless.

set -eu
cd "$(dirname "$0")/.."
P=public
[ -d "$P" ] || { echo "public/ missing — run hugo first."; exit 1; }

# Strip leading YAML front matter (between the first two '---' lines).
strip_fm() {
  awk 'BEGIN{fm=0; seen=0} /^---[[:space:]]*$/{ seen++; if(seen==2){fm=1; next} } fm{print}' "$1"
}

for slug in about contact privacy; do
  src="content/$slug.md"
  [ -f "$src" ] || { echo "skip $slug (no $src)"; continue; }
  mkdir -p "$P/$slug"
  strip_fm "$src" > "$P/$slug/index.md"
  echo "wrote $P/$slug/index.md"
done

# Homepage.
[ -f netlify/homepage.md ] && cp -f netlify/homepage.md "$P/index.md" && echo "wrote $P/index.md"

echo "markdown sync complete"
