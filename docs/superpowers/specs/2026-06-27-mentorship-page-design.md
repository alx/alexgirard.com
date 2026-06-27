# Mentorship Page — Design Spec

**Date:** 2026-06-27
**Status:** Approved

## Goal

Add a standalone `/mentorship` page to alexgirard.com using English copy from `MENTORSHIP.md`. The page should match the existing site aesthetic and convert visitors via a primary CTA to book a session.

## Approach

Approach A — hardcoded layout, matching the existing `layouts/index.html` pattern. Content lives in the layout template, not in Hugo params or shortcodes.

## Files Changed

| File | Action |
|------|--------|
| `content/mentorship.md` | Create — minimal frontmatter only |
| `layouts/mentorship/single.html` | Create — full page layout with all copy |
| `layouts/partials/header.html` | Update — add "Mentorship" nav link (desktop + mobile) |

## Page Sections

Six sections, alternating `bg-white` / `bg-gray-50`, matching homepage rhythm (`py-32`, `border-t border-gray-200`, `max-w-3xl mx-auto`).

### 1. Hero (`bg-white`, `min-h-screen`, centered)
- H1: "I help developers and engineering teams design agentic AI workflows that survive contact with production."
- Subline: "20+ years shipping software for Airbus, Cartier, SNCF and Tate Britain — now focused on the gap between an agent that demos well and one that does real work, reliably, at a cost you can defend."
- Primary CTA button → `https://cal.com/alx-girard` ("Book a working session")

### 2. Who I work with (`bg-gray-50`)
Three personas as a vertical list with bold labels:
- **Developers** — can code but improvising with LLMs/agents, want a structured mental model
- **Teams** — promising AI prototype that breaks, drifts, or burns budget in production
- **Technical founders** — deciding build vs. buy and keeping data under their own control

### 3. What we work on (`bg-white`)
Seven topics in a two-column grid, bold title + one-line description each:
- Agentic architecture
- Tool design & function calling
- Model strategy
- Reliability & evaluation
- Retrieval
- Production integration
- Sovereignty

### 4. Why me (`bg-gray-50`)
Two prose paragraphs from MENTORSHIP.md "Why me" section verbatim.

### 5. Formats (`bg-white`)
Three formats as a vertical list with bold labels:
- **Single working session** — one concrete problem, solved or unblocked. (90 min)
- **Recurring mentorship** — ongoing relationship, your roadmap, async support between calls
- **Team session** — architecture review or hands-on agent design with your engineers

### 6. How it works (`bg-gray-50`)
One prose paragraph + final CTA button → `https://cal.com/alx-girard` ("Book a session")

## Navigation

Add "Mentorship" link to both desktop and mobile nav in `layouts/partials/header.html`. Existing anchor links (`#about`, `#experience`, etc.) remain unchanged — they work from the homepage and are harmless no-ops from the mentorship page.

## Copy Source

All English copy taken verbatim from `MENTORSHIP.md`. No rewrites. French section deferred.

## Out of Scope

- French version (deferred)
- Testimonials (placeholder slots exist in MENTORSHIP.md but no real testimonials yet)
- Booking widget embed (external cal.com link is sufficient)
- Updating homepage nav anchor links to absolute paths
