# html-studio Refactor Design Spec

## Summary

Refactor the `html-ppt` skill into `html-studio` — a broader skill that generates
both HTML presentations (PPT) and website prototype pages, reusing the same design
system (36 themes, CSS tokens, typography, cards, layout primitives, animations).

## Goals

1. AI can generate **website prototype pages** (landing pages, dashboards, portfolios,
   any web page) using the existing theme/token/animation system.
2. PPT functionality is **100% unchanged** — no modifications to base.css, runtime.js,
   themes, templates, or existing behavior.
3. The two modes (Deck / Page) share assets but have independent layout systems.
4. Output supports both self-contained single-file HTML and multi-file with shared assets.

## Non-Goals

- No new UI components beyond page-level layout primitives.
- No pre-made page templates — AI assembles pages from components at runtime.
- No build tools or JavaScript frameworks.
- No changes to the git repository name.

---

## Deliverables

### 1. `assets/page.css` (new file)

Page-level layout primitives for document-flow web pages. Sits alongside `base.css`
(which remains slide-only). All values use `var(--token)` for theme compatibility.

**Containers:**

| Class | Behavior |
|-------|----------|
| `.page` | `max-width: 1200px; margin: 0 auto; padding: 0 var(--page-gutter, 2rem);` |
| `.page-wide` | `max-width: 1440px` |
| `.page-narrow` | `max-width: 800px` |
| `.page-full` | Full width, no max-width |

**Sections:**

| Class | Behavior |
|-------|----------|
| `.section` | Vertical section with `padding-block: var(--section-pad, 4rem);` |
| `.section-hero` | `min-height: 100vh; display: flex; align-items: center;` |
| `.section-alt` | Alternating background: `background: var(--bg-soft);` |

**Responsive Grid Overrides:**

Reuses `.grid`, `.g2`, `.g3`, `.g4` from base.css but adds responsive breakpoints:

```css
@media (max-width: 1024px) {
  .grid.g4 { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 768px) {
  .grid.g2, .grid.g3, .grid.g4 { grid-template-columns: 1fr; }
  .row { flex-direction: column; }
}
```

**Navigation & Footer:**

| Class | Behavior |
|-------|----------|
| `.navbar` | Fixed top nav bar, `background: var(--bg); border-bottom: 1px solid var(--border);` with flex layout for logo + links |
| `.navbar-sticky` | `position: sticky; top: 0;` variant |
| `.footer` | Page footer area with `border-top: 1px solid var(--border); padding-block: 2rem;` |

**Typography:**

| Class | Behavior |
|-------|----------|
| `.prose` | Long-form text container: tuned line-height (~1.7), paragraph spacing, link underlines, list styling, blockquote styling |

**Design rules:**
- All colors, radii, shadows, fonts reference CSS variables from base.css / theme files.
- No class name collisions with base.css (base uses `.slide`/`.deck`, page uses `.page`/`.section`).
- `page.css` has no effect on slide-mode rendering — it's only linked in page-mode output.
- Respects `prefers-reduced-motion` for any transitions.

### 2. SKILL.md rewrite

Restructure from single-mode PPT skill to dual-mode `html-studio`.

**Front matter changes:**
- `name: html-studio` (was `html-ppt`)
- Description expanded to cover both PPT and web page triggers
- New trigger words: `"网页"`, `"网站"`, `"原型"`, `"landing page"`, `"website"`,
  `"prototype"`, `"web page"`, `"HTML 页面"`, `"做一个网页"`, `"网站原型"`

**Structure:**

```
# html-studio — HTML Studio

(intro: dual-mode — Deck for presentations, Page for website prototypes)

## What the skill gives you
(existing assets list + page.css addition)

## When to use
(expanded: presentations + website prototypes)

## Before you author anything — ALWAYS ask or recommend
(expanded to 4 questions: 0. Deck or Page? 1-3 same as before)

### Deck mode flow
(existing PPT authoring workflow, unchanged)

### Page mode flow
(new: page.css components, HTML structure, self-contained vs shared assets)

## Authoring rules — Deck mode
(existing rules, unchanged)

## Authoring rules — Page mode
(new rules:
- Use .page container, not .deck
- Use .section for vertical blocks
- Don't include runtime.js (no keyboard nav needed)
- Link: fonts.css + base.css + page.css + theme.css
- Same token rules as Deck mode)

## Page mode — HTML structure
(new: show the expected HTML skeleton for a page)

## Self-contained output
(new: how to inline CSS for single-file delivery)

## Catalogs
(existing + new reference to page-components.md)

## Presenter Mode
(existing, unchanged — Deck mode only)

## Quick start / Keyboard / Rendering
(existing, unchanged)
```

### 3. `references/page-components.md` (new file)

Catalog of all page.css components with usage examples:
- Each component class with description, HTML example, and theming notes
- Responsive behavior documentation
- How to combine with existing base.css utilities (`.card`, `.row`, `.stack`, `.grid`, etc.)
- Self-contained single-file pattern (inline all CSS)

### 4. No other file changes

| Category | Files | Change |
|----------|-------|--------|
| base.css | `assets/base.css` | No change |
| Themes | `assets/themes/*.css` | No change |
| Runtime | `assets/runtime.js` | No change |
| Animations | `assets/animations/*` | No change |
| Templates | `templates/**` | No change |
| Scripts | `scripts/*` | No change |
| Examples | `examples/*` | No change |
| README | `README.md`, `README.zh-CN.md` | No change (or optional mention of page mode) |

---

## Page Mode HTML Skeleton

**Multi-file (shared assets):**

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page Title</title>
  <link rel="stylesheet" href="path/to/assets/fonts.css">
  <link rel="stylesheet" href="path/to/assets/base.css">
  <link rel="stylesheet" href="path/to/assets/page.css">
  <link rel="stylesheet" href="path/to/assets/themes/minimal-white.css">
  <link rel="stylesheet" href="path/to/assets/animations/animations.css">
</head>
<body>
  <nav class="navbar">...</nav>
  <main class="page">
    <section class="section section-hero">...</section>
    <section class="section">...</section>
    <section class="section section-alt">...</section>
  </main>
  <footer class="footer page">...</footer>
</body>
</html>
```

**Self-contained (single file):**

Same structure, but all CSS is inlined in `<style>` tags. The AI copies
relevant token definitions from base.css, the chosen theme, page.css,
and optionally animations.css into the HTML file.

---

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| page.css classes conflict with base.css | Namespace separation: `.page`/`.section` vs `.deck`/`.slide` — no overlaps |
| Responsive overrides break slide mode | page.css overrides are scoped — only apply when page.css is linked |
| AI confuses Deck vs Page mode | SKILL.md has explicit "ask first" gate + separate authoring rules sections |
| Theme incompatibility with page layout | All page.css uses same `var(--token)` system — themes are mode-agnostic |

---

## Success Criteria

1. Existing PPT generation works identically (no regressions).
2. AI can generate a website prototype page using `page.css` + any of the 36 themes.
3. Generated pages are responsive (readable on mobile via responsive grid breakpoints).
4. Self-contained single-file output works (open HTML directly, no external deps except CDN fonts).
5. SKILL.md triggers correctly on both PPT and web page keywords.
