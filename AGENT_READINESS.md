# Agentic Readiness — Status & Migration Notes

This document explains the state of the six "Is Agentic" readiness checks,
what this repo does about each, and the one infrastructure decision that
affects the final score.

**Current host:** GitHub Pages (static, via `.github/workflows/hugo.yml`).

## Check-by-check

### 1. Redirect hygiene — DONE
`https://alexgirard.com/mentorship/` used a `meta-refresh` redirect that
non-JS agents never execute. The mentorship section was removed from the
site (commit `d92b5b4`), so the correct end state is:

- No `/mentorship/` stub in the build (content, layouts, partials, CSS all
  deleted).
- `/mentorship/` now returns a **real HTTP 404** from the host, with the
  agent-recovery body from `static/404.html` (sitemap, llms.txt, robots.txt
  links). Verified: `curl -s -o /dev/null -w "%{http_code}"` → `404`.

No client-side redirect stubs remain anywhere in the build.

### 2. Agent-friendly 404s — DONE
`static/404.html` is a full on-brand page served with status 404 that, in
addition to a human-readable "page not found", contains an explicit
**"If you're an agent or crawler, here is how to recover"** block linking:

- `/sitemap.xml` — authoritative list of live URLs
- `/llms.txt` — plain-text site description
- `/robots.txt` — crawl policy

GitHub Pages serves `404.html` for any missing path with a real 404 status.

### 3. Markdown content negotiation — BLOCKED BY CURRENT HOST (reference fix shipped)
**This is the one item the repo cannot finish on its own.** Accept header
negotiation requires inspecting the request, which a static CDN cannot do.
Verified live:

```
$ curl -sI -H "Accept: text/markdown" https://alexgirard.com/about/
HTTP/2 404                       # (or 200 on an existing page)
content-type: text/html; charset=utf-8
vary: Accept-Encoding            # no "Vary: Accept", no markdown
```

GitHub Pages has no hooks to change this. The **exact, working fix is
shipped in this repo, ready to deploy on a host with request-level logic**:

| File | Purpose |
|---|---|
| `.netlify.toml` | Reference Netlify deploy config (build command, edge handler wiring) |
| `netlify/edge-handlers/md.mjs` | Edge handler: serves `text/markdown` for `Accept: text/markdown`, sets `Vary: Accept` on both variants |
| `netlify/homepage.md` | Curated markdown source for the homepage |
| `scripts/sync-md.sh` | Post-build step copying markdown sources (trust pages + homepage) into the deploy target |

**To complete this check:** deploy to Netlify (or any host with edge
functions: Cloudflare Workers, Vercel rewrites+functions, a thin
`nginx`/Caddy layer, or a small Cloudflare Worker). Then:

```
curl -sI -H "Accept: text/markdown" https://alexgirard.com/about/
# expect: content-type: text/markdown; charset=utf-8
# expect: vary: Accept
```

Alternatives if staying on GitHub Pages: a Cloudflare Worker in front of
the Pages domain (custom domain → worker → Pages) can implement the same
negotiation without re-hosting. The edge handler is the single source of
truth for the behavior; the `.netlify.toml` is just one wiring example.

### 4. Agent instruction file — DONE
`static/llms.txt` now has a **"When to use this site"** section that names
the best-fit jobs (agentic-AI production reliability, production
ML/computer-vision architecture review, fast expert read, identity
verification), states what the site is **not** for, and includes a
"How to navigate (for agents)" map of the machine-readable endpoints. The
previously duplicated Resume/Projects sections were de-duplicated, and the
file now links the trust pages.

### 5. Metadata completeness — DONE
`layouts/_default/baseof.html` emits all four signals on every page:

- `<link rel="canonical" href="{{ .Permalink }}">` ← **added**
- `<html lang="{{ .Site.LanguageCode }}">` (pre-existing)
- `<meta property="og:image">` (pre-existing)
- `<meta property="og:type">` (pre-existing)

### 6. Trust anchor pages — DONE
Three new real pages, each with well over 500 characters of substantive
content, styled to match the site (`layouts/trust/single.html` + `.page*`
rules in `static/css/style.css`), linked in the header nav and footer:

- `/about/` — who, what shipped, how he works
- `/contact/` — hotline vs. email, what to include, socials
- `/privacy/` — what data is collected (GA4, Cal.com, form), what isn't,
  cookies, machine-readable access, contact for privacy matters

## Tests

`bash tests/site_test.sh` builds the site and asserts all repo-controllable
behaviors (no meta-refresh, 404 body content, llms.txt guidance sections,
homepage metadata, trust-page content length, reference md-negotiation
files). Wired into CI in `.github/workflows/hugo.yml` (`tests` job).

## Remaining decision (needs you)

**Move the origin (or add a front) so `Accept: text/markdown` can be
honoured.** Options, cheapest first:

1. **Cloudflare Worker in front of the Pages custom domain** — keeps GH
   Pages as the origin, ~20 lines, reuses `netlify/edge-handlers/md.mjs`
   logic. Free tier sufficient.
2. **Deploy to Netlify** using the shipped `.netlify.toml` +
   `scripts/sync-md.sh` — full swap, also enables custom 404 status codes
   for deeper paths.
3. **Do nothing** — everything else already passes; the audit item stays
   "failed" until a request-capable front exists.
