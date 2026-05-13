# Page components catalog

`assets/page.css` provides document-flow layout primitives for building
website prototypes. Link it alongside `base.css` and a theme file. All
classes use design tokens from `base.css` / theme files — switching themes
reskins the entire page.

## How to link

```html
<link rel="stylesheet" href="path/to/assets/fonts.css">
<link rel="stylesheet" href="path/to/assets/base.css">
<link rel="stylesheet" href="path/to/assets/page.css">
<link rel="stylesheet" href="path/to/assets/themes/minimal-white.css">
<!-- optional: animations -->
<link rel="stylesheet" href="path/to/assets/animations/animations.css">
```

Do NOT include `runtime.js` — it's for slide decks only.

## Containers

| class | max-width | use case |
|---|---|---|
| `.page` | 1200px | Default content width — articles, product pages |
| `.page-wide` | 1440px | Dashboards, data-heavy layouts |
| `.page-narrow` | 800px | Blog posts, documentation, focused reading |
| `.page-full` | none | Full-bleed hero sections, edge-to-edge layouts |

All containers center with `margin: 0 auto` and use `var(--page-gutter)` for horizontal padding (default 2rem).

```html
<main class="page">
  <!-- content here -->
</main>
```

## Sections

| class | behavior |
|---|---|
| `.section` | Vertical block with `padding-block: var(--section-pad, 4rem)` |
| `.section-hero` | Full-viewport height, flex-centered content |
| `.section-alt` | Alternating background using `var(--bg-soft)` |

Compose sections vertically inside a container:

```html
<main class="page">
  <section class="section section-hero">
    <div class="center" style="flex-direction:column">
      <h1 class="h1">Hero Title</h1>
      <p class="lede">Subtitle text</p>
    </div>
  </section>
  <section class="section">
    <div class="grid g3">
      <div class="card">Feature 1</div>
      <div class="card">Feature 2</div>
      <div class="card">Feature 3</div>
    </div>
  </section>
  <section class="section section-alt">
    <h2 class="h2">Another section</h2>
  </section>
</main>
```

## Navbar

| class | behavior |
|---|---|
| `.navbar` | Flex row with logo left + links right. Uses `var(--bg)` background, bottom border. |
| `.navbar-sticky` | Add alongside `.navbar` for `position: sticky; top: 0` |

```html
<nav class="navbar navbar-sticky">
  <strong>Brand</strong>
  <div class="row" style="gap:1.5rem">
    <a href="#">Features</a>
    <a href="#">Pricing</a>
    <a href="#">Docs</a>
  </div>
</nav>
```

Links inside `.navbar` use `var(--text-2)` and darken on hover.

## Footer

| class | behavior |
|---|---|
| `.page-footer` | Top border, padded, muted text color |

```html
<footer class="page-footer page">
  <div class="row" style="justify-content:space-between">
    <span>© 2026 Brand</span>
    <div class="row" style="gap:1rem">
      <a href="#">Terms</a>
      <a href="#">Privacy</a>
    </div>
  </div>
</footer>
```

## Prose

| class | behavior |
|---|---|
| `.prose` | Long-form text styling: `line-height: 1.75`, paragraph spacing, link underlines, styled blockquotes, code blocks, lists, images, horizontal rules |

Wrap any long-form content in `.prose` for automatic typography:

```html
<article class="prose">
  <h1>Article Title</h1>
  <p>Body text with <a href="#">links</a> and <code>inline code</code>.</p>
  <blockquote>Pull quote with accent border.</blockquote>
  <pre><code>Code block with theme-aware background.</code></pre>
</article>
```

## Responsive behavior

page.css adds responsive breakpoints to base.css grid/row classes:

| breakpoint | effect |
|---|---|
| ≤ 1024px | `.grid.g4` → 2 columns |
| ≤ 768px | `.grid.g2`, `.g3`, `.g4` → 1 column; `.row` → vertical stack |

No additional classes needed — grids automatically collapse.

## Reusing base.css utilities

All base.css classes work in page mode. Common combinations:

| base.css class | page-mode usage |
|---|---|
| `.card`, `.card-soft`, `.card-outline`, `.card-accent` | Feature cards, pricing tiers, testimonial cards |
| `.card-hover` | Add hover lift effect to interactive cards |
| `.grid .g2/.g3/.g4` | Multi-column layouts (auto-responsive via page.css) |
| `.row` | Inline flex layouts (auto-stacks on mobile via page.css) |
| `.stack` | Vertical spacing between children |
| `.h1`–`.h4`, `.lede`, `.eyebrow`, `.kicker` | Typography hierarchy |
| `.gradient-text` | Gradient-filled headings |
| `.pill`, `.pill-accent` | Tags, badges |
| `.divider`, `.divider-accent` | Visual separators |
| `.center` | Centered flex container |
| `.dim`, `.dim2` | Muted text |

## Animations in page mode

CSS animations from `assets/animations/animations.css` work in page mode. Add `data-anim="fade-up"` or `class="anim-fade-up"` to any element. Note: `runtime.js` auto-triggers animations on slide enter — in page mode without `runtime.js`, animations play immediately on page load. To trigger on scroll, add custom `IntersectionObserver` JS.

Canvas FX (`data-fx`) require `fx-runtime.js` which depends on slide lifecycle — they are **deck-mode only**.

## Self-contained single-file output

For a self-contained HTML file (no external CSS dependencies except CDN fonts), inline all CSS into `<style>` tags:

1. Copy the `:root` token block from `base.css` (lines 3–33)
2. Copy the global reset rules from `base.css` (lines 35–43)
3. Copy the full layout/typography/card sections from `base.css` (lines 77–106)
4. Copy the full `page.css` content
5. Copy the chosen theme's `:root` override
6. Optionally copy animation keyframes from `animations.css`

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page Title</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Noto+Sans+SC:wght@300;400;500;700&display=swap');
    /* paste base.css tokens + reset + layout/typography/cards here */
    /* paste page.css here */
    /* paste theme overrides here */
  </style>
</head>
<body>
  <nav class="navbar navbar-sticky">...</nav>
  <main class="page">
    <section class="section section-hero">...</section>
    <section class="section">...</section>
  </main>
  <footer class="page-footer page">...</footer>
</body>
</html>
```

## Theming

All 36 themes work in page mode. Switch theme by changing the `<link>` href:

```html
<link rel="stylesheet" href="path/to/assets/themes/tokyo-night.css">
```

Theme recommendations for page mode:

| audience | themes |
|---|---|
| Product / landing page | `minimal-white`, `soft-pastel`, `corporate-clean` |
| Developer docs / dashboard | `tokyo-night`, `dracula`, `catppuccin-mocha`, `terminal-green` |
| Portfolio / creative | `editorial-serif`, `magazine-bold`, `neo-brutalism` |
| Marketing / startup | `pitch-deck-vc`, `aurora`, `rainbow-gradient` |
