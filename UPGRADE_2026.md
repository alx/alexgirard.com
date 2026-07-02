# Website Professional Upgrade Requirements - 2026

## Summary
Transform alexgirard.com from a colorful, animation-heavy single-page site to a minimal, elegant professional portfolio inspired by Apple/Stripe design principles.

---

## Current State Analysis

### Strengths
- Clean Hugo architecture with custom layouts
- Mobile-responsive design
- Good SEO meta tags (OG, Twitter cards)
- Accessibility features (ARIA labels, reduced motion support)

### Issues Requiring Attention
1. **Visual**: Colorful aurora gradients feel playful rather than professional
2. **Typography**: Generic - needs more refined hierarchy
3. **Content**: Generic "About Me" copy, no work experience, no resume
4. **Color**: Over-saturated palette (blues, purples, pinks, greens)
5. **Animation**: Excessive movement detracts from professionalism

---

## Upgrade Requirements

### 1. Design System Overhaul

**Color Palette** (Minimal & Elegant)
- Primary: Neutral grays (#111, #333, #666, #999, #f5f5f5)
- Accent: Single subtle accent (e.g., muted blue #3b82f6 or warm gray)
- Backgrounds: White, off-white (#fafafa), light gray
- Remove: All rainbow/aurora gradients

**Typography**
- Keep Inter font but refine weights usage
- Larger, bolder headings with more letter-spacing
- Generous line-height for body text (1.7-1.8)
- Constrained max-width for readability (~65ch)

**Spacing**
- Increase vertical rhythm (py-24 to py-32 sections)
- More generous whitespace between elements
- Subtle section dividers instead of color blocks

### 2. Hero Section Redesign

**Current**: Full-screen aurora gradient with animated background

**New**:
- Clean white/light background
- Large, bold name typography
- Refined tagline: "DevOps Engineer & Open Source Contributor"
- Minimal CTA (single understated link or scroll indicator)
- No animated gradients - static, elegant

### 3. About Section Enhancement

**Current**: Generic two-column layout with bullet points

**New**:
- Single-column, prose-focused design
- Refined, specific copy (user to provide)
- Subtle divider from hero
- Remove colorful tech badges - use simple text list or minimal pills

### 4. Work Experience Section (NEW)

**Structure**:
```
Experience
-----------
[Company Name] - [Role]
[Date Range]
- Key accomplishment 1
- Key accomplishment 2

[Previous Company] - [Role]
[Date Range]
- Key accomplishment
```

**Design**:
- Clean timeline or simple list format
- Minimal icons (if any)
- Clear hierarchy: company > role > dates > achievements
- Gray text for dates, black for company/role

### 5. Projects Section Refinement

**Current**: 6 colorful gradient cards with star counts

**New**:
- Simple list or minimal card design
- Remove gradient backgrounds
- Keep project descriptions, add subtle tech tags
- Clean hover states (underline or slight opacity change)
- Consider featuring fewer projects (3-4 best ones)

### 6. Contact Section Simplification

**Current**: Aurora gradient with glassmorphic cards

**New**:
- Simple white/light background
- Clean typography: "Get in touch"
- Simple email link
- Minimal social icons (GitHub, LinkedIn)
- No gradient, no glass effects

### 7. Resume Download (NEW)

**Implementation**:
- Add `/static/resume.pdf` file
- Add download link in About or Contact section
- Simple button or text link: "Download Resume (PDF)"

### 8. Header & Footer Polish

**Header**:
- Simpler, thinner border or no border
- Reduce blur effect intensity
- Ensure logo/name is refined

**Footer**:
- Lighter approach - could be just a simple line with copyright and social links
- Remove three-column grid in favor of single centered line

### 9. Technical Improvements

- Replace CDN Tailwind with build-time compilation (optional but recommended)
- Add favicon if missing
- Consider adding JSON-LD structured data for better SEO
- Ensure print styles work well for resume-style printing

---

## Files to Modify

| File | Changes |
|------|---------|
| `layouts/_default/baseof.html` | Update Tailwind config colors, simplify font weights |
| `layouts/index.html` | Major redesign: hero, about, projects, contact sections |
| `layouts/partials/header.html` | Simplify styling |
| `layouts/partials/footer.html` | Simplify to minimal design |
| `static/css/style.css` | Remove aurora animations, add minimal styles |
| `static/js/main.js` | Remove unnecessary animations |
| `hugo.yaml` | Update params if needed |

## New Files to Create

| File | Purpose |
|------|---------|
| `static/resume.pdf` | User to provide PDF resume |

---

## Implementation Order

1. Update color palette and remove gradients (baseof.html, style.css)
2. Redesign hero section (index.html)
3. Refine about section (index.html)
4. Add work experience section (index.html)
5. Simplify projects section (index.html)
6. Simplify contact section (index.html)
7. Polish header and footer (partials)
8. Add resume download functionality
9. Clean up JS animations (main.js)
10. Final review and testing

---

## Content Needed from User

- [ ] Updated "About Me" text (specific to your experience)
- [ ] Work experience entries (company, role, dates, 2-3 bullet points each)
- [ ] Resume PDF file
- [ ] Preferred accent color (or default to muted blue)
