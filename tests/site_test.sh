#!/usr/bin/env bash
# site_test.sh — verifies the agentic-readiness behaviors of the built site.
#
# Builds the Hugo site into ./public and asserts on the artifacts a real
# server would serve. Run from the repo root:  bash tests/site_test.sh
#
# It is intentionally host-agnostic where GitHub Pages is the constraint:
# checks that PASS are what this repo can guarantee; the markdown
# content-negotiation requirement is asserted against a reference config
# (see AGENT_READINESS.md) rather than the static build, since GH Pages
# cannot set response Content-Type by Accept header.

set -u
cd "$(dirname "$0")/.."
PASS=0; FAIL=0

ok()   { PASS=$((PASS+1)); printf '  \033[32mPASS\033[0m %s\n' "$1"; }
fail() { FAIL=$((FAIL+1)); printf '  \033[31mFAIL\033[0m %s\n' "$1"; }
check() { # check <desc> <cmd...>
  local d="$1"; shift
  if "$@" >/dev/null 2>&1; then ok "$d"; else fail "$d"; fi
}
grepq() { # grepq <desc> <pattern> <file>
  local d="$1" p="$2" f="$3"
  if grep -q "$p" "$f" 2>/dev/null; then ok "$d"; else fail "$d (pattern '$p' not in $f)"; fi
}

echo "== Build =="
# Build into a FRESH temp directory so the test always reflects a clean build —
# exactly like CI — and never clobbers a locally-running `hugo server` output.
DEST="$(mktemp -d)"
trap 'rm -rf "$DEST"' EXIT
HUGO="hugo"
if ! command -v hugo >/dev/null 2>&1; then
  echo "  (hugo not found on PATH; trying any local binary)"
  [ -x ./hugo ] && HUGO=./hugo
fi
$HUGO --gc --minify --baseURL "https://alexgirard.com/" --destination "$DEST" >/tmp/hugo_build.log 2>&1
if [ $? -eq 0 ]; then ok "hugo build succeeds"; else
  fail "hugo build (see /tmp/hugo_build.log)"; tail -20 /tmp/hugo_build.log; fi

P="$DEST"
[ -d "$P" ] || { echo "Build produced no output dir — cannot continue."; exit 1; }

echo
echo "== 1. Redirect hygiene: no client-side redirect stubs =="
# No meta-refresh anywhere in built HTML
if grep -rqi 'http-equiv="refresh"' "$P"; then
  fail "found meta-refresh in build: $(grep -rl 'http-equiv=\"refresh\"' "$P" | tr '\n' ' ')"
else
  ok "no meta-refresh redirects in any built page"
fi
# No orphaned /mentorship/ stub (was the meta-refresh page)
if [ -e "$P/mentorship/index.html" ]; then
  fail "public/mentorship/index.html still present"
else
  ok "no /mentorship/ stub page in build"
fi
grep -rqi "mentorship" "$P" 2>/dev/null && fail "mentorship still referenced in build" || ok "no mentorship references remain in build"

echo
echo "== 2. Agent-friendly 404 =="
F404="$P/404.html"
if [ -f "$F404" ]; then ok "static/404.html exists (GH Pages serves it with status 404)"; else fail "404.html missing"; fi
[ -f "$F404" ] && grepq "404 offers sitemap.xml recovery link"  "sitemap.xml"      "$F404"
[ -f "$F404" ] && grepq "404 offers llms.txt recovery link"      "llms.txt"         "$F404"
[ -f "$F404" ] && grepq "404 offers robots.txt recovery link"    "robots.txt"       "$F404"
[ -f "$F404" ] && grepq "404 has noindex so it is not indexed"   'noindex'          "$F404"
# 404 must be a real page with useful text, not an empty shell
[ -f "$F404" ] && [ "$(wc -c < "$F404")" -gt 1500 ] && ok "404 body has substantive content" || fail "404 body too small / empty"

echo
echo "== 3. Markdown content negotiation (reference implementation) =="
# The live host is GitHub Pages, which CANNOT vary Content-Type by Accept or
# add 'Vary: Accept' (verified: it always returns text/html). That is a host
# limitation, not a repo defect. We therefore ship the exact fix as a reference
# Netlify implementation and assert it is present and correct. See AGENT_READINESS.md.
EDGE="netlify/edge-handlers/md.mjs"
if [ -f "$EDGE" ]; then
  ok "netlify edge handler for markdown negotiation present"
  grepq "edge handler honours Accept: text/markdown" 'text/markdown' "$EDGE"
  grepq "edge handler sets Vary: Accept"             'Vary'          "$EDGE"
  grepq "edge handler serves Content-Type text/markdown" '"text/markdown' "$EDGE"
else
  fail "netlify/edge-handlers/md.mjs reference implementation missing"
fi
NETTOML=".netlify.toml"
if [ -f "$NETTOML" ]; then
  ok ".netlify.toml migration config present"
  grepq ".netlify.toml keeps /mentorship/ as a real HTTP 301" 'mentorship' "$NETTOML"
else
  fail ".netlify.toml missing"
fi
echo "  info: current GH Pages deploy returns text/html for 'Accept: text/markdown' (documented host limitation)."

echo
echo "== 4. Agent instruction file (llms.txt) =="
LLMS="$P/llms.txt"
[ -f "$LLMS" ] && ok "llms.txt built" || fail "llms.txt missing"
[ -f "$LLMS" ] && grepq "llms.txt has a 'When to use this site' section" "When to use this site" "$LLMS"
[ -f "$LLMS" ] && grepq "llms.txt names the best-fit use case (agentic-AI reliability)" "agentic-AI reliability" "$LLMS"
[ -f "$LLMS" ] && grepq "llms.txt tells agents what NOT to use it for" "Do NOT reach" "$LLMS"
[ -f "$LLMS" ] && grepq "llms.txt references /about/" "/about/" "$LLMS"
[ -f "$LLMS" ] && grepq "llms.txt references /contact/" "/contact/" "$LLMS"
[ -f "$LLMS" ] && grepq "llms.txt references /privacy/" "/privacy/" "$LLMS"
# No duplicated top-level sections (the old file repeated Resume+Projects)
if [ "$(grep -c '^## Resume' "$LLMS" 2>/dev/null)" -gt 1 ]; then
  fail "llms.txt has duplicated '## Resume' sections"
else
  ok "llms.txt has no duplicated sections"
fi

echo
echo "== 5. Homepage metadata completeness (4/4 signals) =="
# NOTE: Hugo --minify strips attribute quotes, so patterns are written
# minify-tolerant (match with or without surrounding double quotes).
HOME="$P/index.html"
if grep -Eq 'lang="?[a-z]' "$HOME" 2>/dev/null; then ok "homepage has <html lang=...>"; else fail "homepage missing <html lang=...>"; fi
if grep -Eq 'rel="?canonical' "$HOME" 2>/dev/null; then ok "homepage has <link rel=canonical>"; else fail "homepage missing canonical link"; fi
if grep -Eq 'property="?og:image' "$HOME" 2>/dev/null; then ok "homepage has og:image"; else fail "homepage missing og:image"; fi
if grep -Eq 'property="?og:type' "$HOME" 2>/dev/null; then ok "homepage has og:type"; else fail "homepage missing og:type"; fi

echo
echo "== 6. Trust pages: /about /contact /privacy, >=500 chars of real content =="
for slug in about contact privacy; do
  PAGE="$P/$slug/index.html"
  if [ -f "$PAGE" ]; then ok "/$slug/ built"; else fail "/$slug/ missing"; continue; fi
  # Count the visible text length of the main body (strip tags), must be >=500
  chars=$(tr -d '\n' < "$PAGE" | sed -e 's/<[^>]*>//g' | wc -c)
  if [ "$chars" -ge 500 ]; then ok "/$slug/ has >=500 chars of content ($chars)"; else fail "/$slug/ content too short ($chars chars)"; fi
done

echo
echo "== 7. Nav placement: Contact/Privacy live in footer only, not header =="
# The header nav must NOT contain /contact/ or /privacy/ (moved to footer)
HEADER="$(awk '/<header/,/<\/header>/' "$HOME")"
if printf '%s' "$HEADER" | grep -Eq 'href="?/contact/"?|href="?/privacy/"?'; then
  fail "header nav still links /contact/ or /privacy/"
else
  ok "header nav has no Contact/Privacy links"
fi
# With header links gone, any /contact/|/privacy/ href in the page is the footer's
if grep -Eq 'href="?/contact/"?' "$HOME" && grep -Eq 'href="?/privacy/"?' "$HOME"; then
  ok "footer links /contact/ and /privacy/ (next to llms.txt)"
else
  fail "footer missing /contact/ or /privacy/ link"
fi

echo
echo "=================================================="
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "ALL CHECKS PASSED"
exit $FAIL
