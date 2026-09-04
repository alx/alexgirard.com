// Netlify Edge Handler — Markdown content negotiation (acceptmarkdown.com)
//
// Serves a text/markdown representation of a page when the client sends
// `Accept: text/markdown` and a markdown source exists for that path;
// otherwise falls through to the default (HTML) handler. Sets
// `Vary: Accept` on both branches so caches (including the CDN in front of
// Netlify) key the response by the Accept header — without it, a cache
// could serve the HTML variant to a markdown-seeking agent or vice versa.
//
// The markdown source is generated at build time by Hugo (content/**/*.md)
// and copied to public/ by a post-build step (see scripts/sync-md.sh, run
// from CI after `hugo`). The mapping is:
//
//   /about/           -> /about/index.md
//   /contact/         -> /contact/index.md
//   /privacy/         -> /privacy/index.md
//   /                 -> /index.md        (homepage)
//
// Non-existent paths still return the 404 handler (static/404.html), so
// agent 404 recovery keeps working identically in both content types.

const ACCEPT_MD = "text/markdown";

export default async (req, ctx) => {
  const url = new URL(req.url);
  const accept = req.headers.get("accept") || "";
  const wantsMd = accept.split(",").some((part) => {
    const media = part.split(";")[0].trim().toLowerCase();
    return media === ACCEPT_MD || media === "text/*" || media === "*/*";
  }) && accept.toLowerCase().includes(ACCEPT_MD);

  // Candidate markdown file for this path.
  const path = url.pathname.replace(/\/+$/, "");
  const mdPath = path === "" ? "/index.md" : `${path}/index.md`;

  if (wantsMd) {
    const md = await ctx.next({ path: mdPath, cache: "must-revalidate" });
    if (md.status === 200) {
      return new Response(md.body, {
        status: 200,
        headers: {
          "Content-Type": "text/markdown; charset=utf-8",
          "Vary": "Accept",
          "Cache-Control": "max-age=600",
        },
      });
    }
    // Fall through to default handler (HTML or 404) and mark the variant.
    const res = await ctx.next();
    res.headers.set("Vary", "Accept");
    return res;
  }

  // HTML path: still advertise that an Accept-based variant exists.
  const html = await ctx.next();
  html.headers.set("Vary", "Accept");
  return html;
};
