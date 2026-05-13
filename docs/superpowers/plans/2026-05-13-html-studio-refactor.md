# html-studio Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extend the html-ppt skill into html-studio — a dual-mode skill that generates both HTML presentations and website prototype pages, reusing the same 36-theme token-based design system.

**Architecture:** Three new/modified files, zero changes to existing assets. `page.css` provides document-flow layout primitives that sit alongside `base.css` (slide-only). SKILL.md is rewritten as a dual-mode dispatcher. `references/page-components.md` catalogs every page.css class.

**Tech Stack:** Pure static CSS. No build tools, no JavaScript, no frameworks.

---

### Task 1: Create `assets/page.css`

**Files:**
- Create: `assets/page.css`

- [ ] **Step 1: Create page.css with page containers**

Create `assets/page.css` with the following content. This is the complete file — all subsequent steps in this task add to it.

```css
/* html-studio :: page.css — document-flow layout primitives for web pages */
/* Use alongside base.css + a theme. Does NOT affect slide/deck rendering. */

/* ================= PAGE CONTAINERS ================= */
.page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--page-gutter, 2rem);
}
.page-wide {
  max-width: 1440px;
  margin: 0 auto;
  padding: 0 var(--page-gutter, 2rem);
}
.page-narrow {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 var(--page-gutter, 2rem);
}
.page-full {
  max-width: none;
  padding: 0 var(--page-gutter, 2rem);
}
```

- [ ] **Step 2: Add section primitives**

Append to `assets/page.css`:

```css
/* ================= SECTIONS ================= */
.section {
  padding-block: var(--section-pad, 4rem);
}
.section-hero {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.section-alt {
  background: var(--bg-soft);
}
```

- [ ] **Step 3: Add responsive grid overrides**

Append to `assets/page.css`. These add breakpoints to the `.grid`, `.g2`, `.g3`, `.g4`, and `.row` classes already defined in `base.css`:

```css
/* ================= RESPONSIVE OVERRIDES ================= */
/* Adds breakpoints to .grid/.row from base.css for document-flow pages. */
@media (max-width: 1024px) {
  .grid.g4 { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 768px) {
  .grid.g2,
  .grid.g3,
  .grid.g4 { grid-template-columns: 1fr; }
  .row { flex-direction: column; }
}
```

- [ ] **Step 4: Add navbar and footer**

Append to `assets/page.css`:

```css
/* ================= NAVBAR ================= */
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem var(--page-gutter, 2rem);
  background: var(--bg);
  border-bottom: 1px solid var(--border);
  font-size: 14px;
  z-index: 100;
}
.navbar-sticky {
  position: sticky;
  top: 0;
}
.navbar a { color: var(--text-2); font-weight: 500; }
.navbar a:hover { color: var(--text-1); text-decoration: none; }

/* ================= FOOTER ================= */
.page-footer {
  border-top: 1px solid var(--border);
  padding: 2rem var(--page-gutter, 2rem);
  font-size: 14px;
  color: var(--text-3);
}
```

Note: the footer class is `.page-footer` (not `.footer`) to avoid any collision with `.deck-footer` in base.css.

- [ ] **Step 5: Add prose typography**

Append to `assets/page.css`:

```css
/* ================= PROSE ================= */
.prose { line-height: 1.75; color: var(--text-1); }
.prose p { margin: 0 0 1.25em; }
.prose h1, .prose h2, .prose h3, .prose h4 {
  font-family: var(--font-display);
  color: var(--text-1);
  margin: 2em 0 0.6em;
  line-height: 1.2;
}
.prose h1 { font-size: 2.25rem; font-weight: 800; letter-spacing: var(--letter-tight); }
.prose h2 { font-size: 1.75rem; font-weight: 700; letter-spacing: var(--letter-tight); }
.prose h3 { font-size: 1.25rem; font-weight: 600; }
.prose h4 { font-size: 1rem; font-weight: 600; }
.prose a { color: var(--accent); text-decoration: underline; text-underline-offset: 2px; }
.prose a:hover { text-decoration-thickness: 2px; }
.prose ul, .prose ol { padding-left: 1.5em; margin: 0 0 1.25em; }
.prose li { margin-bottom: 0.35em; }
.prose blockquote {
  border-left: 3px solid var(--accent);
  padding: 0.5em 1em;
  margin: 1.5em 0;
  color: var(--text-2);
  background: var(--bg-soft);
  border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
}
.prose pre {
  background: var(--surface-2);
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 1em 1.25em;
  overflow-x: auto;
  margin: 1.5em 0;
  font-size: 0.875rem;
  line-height: 1.6;
}
.prose code {
  background: var(--surface-2);
  padding: 0.15em 0.4em;
  border-radius: 4px;
  font-size: 0.875em;
}
.prose pre code { background: none; padding: 0; border-radius: 0; font-size: inherit; }
.prose img { border-radius: var(--radius-sm); margin: 1.5em 0; }
.prose hr {
  border: none;
  height: 1px;
  background: var(--border);
  margin: 2em 0;
}
```

- [ ] **Step 6: Add reduced-motion guard**

Append to `assets/page.css`:

```css
/* ================= REDUCED MOTION ================= */
@media (prefers-reduced-motion: reduce) {
  .navbar, .page-footer { transition: none; }
}
```

- [ ] **Step 7: Verify page.css doesn't affect slide rendering**

Open an existing deck in a browser to confirm it renders correctly when page.css is NOT linked (which it won't be — decks don't reference page.css):

Run:
```bash
open /Users/likexing/cc/dev/public/html-ppt-skill/examples/demo-deck/index.html
```

Expected: Demo deck renders identically to before. page.css has no effect because it's not linked.

- [ ] **Step 8: Commit**

```bash
git add assets/page.css
git commit -m "feat: add page.css — document-flow layout primitives for web pages"
```

---

### Task 2: Create `references/page-components.md`

**Files:**
- Create: `references/page-components.md`

- [ ] **Step 1: Write page-components.md**

Create `references/page-components.md` with the following content:

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add references/page-components.md
git commit -m "docs: add page-components.md — catalog for page.css classes"
```

---

### Task 3: Rewrite SKILL.md

**Files:**
- Modify: `SKILL.md`

This is the largest task. The full rewritten SKILL.md follows. It preserves all existing Deck-mode content verbatim and adds Page-mode sections.

- [ ] **Step 1: Rewrite SKILL.md**

Replace the entire content of `SKILL.md` with:

````markdown
---
name: html-studio
description: HTML Studio — author professional static HTML presentations AND website prototype pages, all driven by a shared token-based design system with 36 themes. Use when the user asks for a presentation, PPT, slides, keynote, deck, slideshow, "幻灯片", "演讲稿", "做一份 PPT", "做一份 slides", a reveal-style HTML deck, a 小红书 图文, or any kind of multi-slide pitch/report/sharing document. Also use when the user asks for a website prototype, landing page, HTML page, web page, "网页", "网站", "原型", "做一个网页", "网站原型", "landing page", "website", "prototype", "HTML 页面", or any kind of static web page that should look polished. Two modes: **Deck** (keyboard-navigated slide presentations) and **Page** (document-flow web pages with responsive layout).
---

# html-studio — HTML Studio

Author professional HTML output as static files. Two modes:

- **Deck mode** — keyboard-navigated slide presentations (PPT)
- **Page mode** — document-flow website prototype pages

Both modes share the same design system: 36 themes, CSS tokens, typography,
cards, layout primitives, and animations. One theme file = one look across
both modes.

## Install

```bash
npx skills add https://github.com/lewislulu/html-ppt-skill
```

One command, no build. Pure static HTML/CSS/JS with only CDN webfonts.

## What the skill gives you

- **36 themes** (`assets/themes/*.css`) — minimal-white, editorial-serif, soft-pastel, sharp-mono, arctic-cool, sunset-warm, catppuccin-latte/mocha, dracula, tokyo-night, nord, solarized-light, gruvbox-dark, rose-pine, neo-brutalism, glassmorphism, bauhaus, swiss-grid, terminal-green, xiaohongshu-white, rainbow-gradient, aurora, blueprint, memphis-pop, cyberpunk-neon, y2k-chrome, retro-tv, japanese-minimal, vaporwave, midcentury, corporate-clean, academic-paper, news-broadcast, pitch-deck-vc, magazine-bold, engineering-whiteprint
- **15 full-deck templates** (`templates/full-decks/<name>/`) — complete multi-slide decks with scoped `.tpl-<name>` CSS. 8 extracted from real-world decks (xhs-white-editorial, graphify-dark-graph, knowledge-arch-blueprint, hermes-cyber-terminal, obsidian-claude-gradient, testing-safety-alert, xhs-pastel-card, dir-key-nav-minimal), 7 scenario scaffolds (pitch-deck, product-launch, tech-sharing, weekly-report, xhs-post 3:4, course-module, **presenter-mode-reveal** — 演讲者模式专用)
- **31 layouts** (`templates/single-page/*.html`) with realistic demo data
- **27 CSS animations** (`assets/animations/animations.css`) via `data-anim`
- **20 canvas FX animations** (`assets/animations/fx/*.js`) via `data-fx` — particle-burst, confetti-cannon, firework, starfield, matrix-rain, knowledge-graph (force-directed), neural-net (pulses), constellation, orbit-ring, galaxy-swirl, word-cascade, letter-explode, chain-react, magnetic-field, data-stream, gradient-blob, sparkle-trail, shockwave, typewriter-multi, counter-explosion
- **Page layout system** (`assets/page.css`) — document-flow containers, sections, responsive grid, navbar, footer, prose typography
- **Keyboard runtime** (`assets/runtime.js`) — arrows, T (theme), A (anim), F/O, **S (presenter mode: magnetic-card popup with CURRENT / NEXT / SCRIPT / TIMER cards)**, N (notes drawer), R (reset timer in presenter)
- **FX runtime** (`assets/animations/fx-runtime.js`) — auto-inits `[data-fx]` on slide enter, cleans up on leave
- **Showcase decks** for themes / layouts / animations / full-decks gallery
- **Headless Chrome render script** for PNG export

## When to use

**Deck mode:** when the user asks for any kind of slide-based output or wants to
turn text/notes into a presentable deck.

**Page mode:** when the user asks for a website prototype, landing page, product
page, dashboard, portfolio, or any document-flow HTML page.

### 🎤 Presenter Mode (演讲者模式 + 逐字稿) — Deck mode only

If the user mentions any of: **演讲 / 分享 / 讲稿 / 逐字稿 / speaker notes / presenter view / 演讲者视图 / 提词器**, or says things like "我要去给团队讲 xxx", "要做一场技术分享", "怕讲不流畅", "想要一份带逐字稿的 PPT" — **use the `presenter-mode-reveal` full-deck template** and write 150–300 words of 逐字稿 in each slide's `<aside class="notes">`.

See [references/presenter-mode.md](references/presenter-mode.md) for the full authoring guide including the 3 rules of speaker script writing:
1. **不是讲稿，是提示信号** — 加粗核心词 + 过渡句独立成段
2. **每页 150–300 字** — 2–3 分钟/页的节奏
3. **用口语，不用书面语** — "因此"→"所以"，"该方案"→"这个方案"

All full-deck templates support the S key presenter mode (it's built into `runtime.js`). **S opens a new popup window with 4 magnetic cards**:
- 🔵 **CURRENT** — pixel-perfect iframe preview of the current slide
- 🟣 **NEXT** — pixel-perfect iframe preview of the next slide
- 🟠 **SPEAKER SCRIPT** — large-font 逐字稿 (scrollable)
- 🟢 **TIMER** — elapsed time + slide counter + prev/next/reset buttons

Each card is **draggable by its header** and **resizable by the bottom-right corner handle**. Card positions/sizes persist to `localStorage` per deck. A "Reset layout" button restores the default arrangement.

**Why the previews are pixel-perfect**: each preview is an `<iframe>` that loads the actual deck HTML with a `?preview=N` query param; `runtime.js` detects this and renders only slide N with no chrome. So the preview uses the **same CSS, theme, fonts, and viewport as the audience view** — colors and layout are guaranteed identical.

**Smooth navigation**: on slide change, the presenter window sends `postMessage({type:'preview-goto', idx:N})` to each iframe. The iframe just toggles `.is-active` between slides — **no reload, no flicker**. The two windows also stay in sync via `BroadcastChannel`.

Only `presenter-mode-reveal` is designed from the ground up around the feature with proper example 逐字稿 on every slide.

Keyboard in presenter window: `← →` navigate (syncs audience) · `R` reset timer · `Esc` close popup.
Keyboard in audience window: `S` open presenter · `T` cycle theme · `← →` navigate (syncs presenter) · `F` fullscreen · `O` overview.

## Before you author anything — ALWAYS ask or recommend

**Do not start writing anything until you understand these things.** Either ask
the user directly, or — if they already handed you rich content — propose a
tasteful default and confirm.

**Step 0: Deck or Page?**
Determine whether the user wants a slide presentation (Deck mode) or a website
prototype page (Page mode). If the intent is ambiguous, ask:

> 你想要的是一份 **演示 PPT**（幻灯片翻页），还是一个 **网页原型**（正常滚动的网页）？

**Then follow the mode-specific flow below.**

### Deck mode — what to ask

1. **Content & audience.** What's the deck about, how many slides, who's
   watching (engineers / execs / 小红书读者 / 学生 / VC)?
2. **Style / theme.** Which of the 36 themes fits? If unsure, recommend 2-3
   candidates based on tone:
   - Business / investor pitch → `pitch-deck-vc`, `corporate-clean`, `swiss-grid`
   - Tech sharing / engineering → `tokyo-night`, `dracula`, `catppuccin-mocha`,
     `terminal-green`, `blueprint`
   - 小红书图文 → `xiaohongshu-white`, `soft-pastel`, `rainbow-gradient`,
     `magazine-bold`
   - Academic / report → `academic-paper`, `editorial-serif`, `minimal-white`
   - Edgy / cyber / launch → `cyberpunk-neon`, `vaporwave`, `y2k-chrome`,
     `neo-brutalism`
3. **Starting point.** One of the 14 full-deck templates, or scratch? Point
   to the closest `templates/full-decks/<name>/` and ask if it fits. If the
   user's content suggests something obvious (e.g. "我要做产品发布会" →
   `product-launch`), propose it confidently instead of asking blindly.

### Page mode — what to ask

1. **Content & purpose.** What's the page for (landing page, dashboard,
   portfolio, product page…)? Who's the audience?
2. **Style / theme.** Recommend 2-3 themes based on page type:
   - Product / landing page → `minimal-white`, `soft-pastel`, `corporate-clean`
   - Developer docs / dashboard → `tokyo-night`, `dracula`, `catppuccin-mocha`
   - Portfolio / creative → `editorial-serif`, `magazine-bold`, `neo-brutalism`
   - Marketing / startup → `pitch-deck-vc`, `aurora`, `rainbow-gradient`
3. **Output format.** Self-contained single HTML file, or multi-file referencing
   shared assets?

A good opening message for Page mode:

> 我可以给你做这个网页原型！先确认几件事：
> 1. 页面用途和目标用户？
> 2. 风格偏好？我建议：`minimal-white`（简洁大方）、`tokyo-night`（技术感）、`aurora`（现代渐变）。
> 3. 输出要单个自包含 HTML 文件，还是引用共享的样式资源？

Only after those are clear, start writing.

## Deck mode — Quick start

1. **Scaffold a new deck.** From the repo root:
   ```bash
   ./scripts/new-deck.sh my-talk
   open examples/my-talk/index.html
   ```
2. **Pick a theme.** Open the deck and press `T` to cycle. Or hard-code it:
   ```html
   <link rel="stylesheet" id="theme-link" href="../assets/themes/aurora.css">
   ```
   Catalog in [references/themes.md](references/themes.md).
3. **Pick layouts.** Copy `<section class="slide">...</section>` blocks out of
   files in `templates/single-page/` into your deck. Replace the demo data.
   Catalog in [references/layouts.md](references/layouts.md).
4. **Add animations.** Put `data-anim="fade-up"` (or `class="anim-fade-up"`) on
   any element. On `<ul>`/grids, use `anim-stagger-list` for sequenced reveals.
   For canvas FX, use `<div data-fx="knowledge-graph">...</div>` and include
   `<script src="../assets/animations/fx-runtime.js"></script>`.
   Catalog in [references/animations.md](references/animations.md).
5. **Use a full-deck template.** Copy `templates/full-decks/<name>/` into
   `examples/my-talk/` as a starting point. Each folder is self-contained with
   scoped CSS. Catalog in [references/full-decks.md](references/full-decks.md)
   and gallery at `templates/full-decks-index.html`.
6. **Render to PNG.**
   ```bash
   ./scripts/render.sh templates/theme-showcase.html       # one shot
   ./scripts/render.sh examples/my-talk/index.html 12      # 12 slides
   ```

## Page mode — Quick start

1. **Create a new HTML file** (e.g. `examples/my-page/index.html`).
2. **Link the asset chain:**
   ```html
   <link rel="stylesheet" href="../../assets/fonts.css">
   <link rel="stylesheet" href="../../assets/base.css">
   <link rel="stylesheet" href="../../assets/page.css">
   <link rel="stylesheet" href="../../assets/themes/minimal-white.css">
   ```
3. **Build with sections and base.css components:**
   ```html
   <body>
     <nav class="navbar navbar-sticky">
       <strong>Brand</strong>
       <div class="row" style="gap:1.5rem">
         <a href="#">Features</a>
         <a href="#">Pricing</a>
       </div>
     </nav>
     <main class="page">
       <section class="section section-hero">
         <div class="center" style="flex-direction:column">
           <h1 class="h1 gradient-text">Hero Title</h1>
           <p class="lede">Subtitle text goes here</p>
         </div>
       </section>
       <section class="section">
         <div class="grid g3">
           <div class="card card-hover">Feature 1</div>
           <div class="card card-hover">Feature 2</div>
           <div class="card card-hover">Feature 3</div>
         </div>
       </section>
     </main>
     <footer class="page-footer page">© 2026 Brand</footer>
   </body>
   ```
4. **Do NOT include `runtime.js`** — it's for slide decks only.
5. **Optionally add CSS animations** — link `animations.css` and use
   `class="anim-fade-up"` on elements.

Full component catalog: [references/page-components.md](references/page-components.md).

## Page mode — self-contained single file

For a single HTML file with no external dependencies (except CDN fonts),
inline all CSS into `<style>` tags:

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page Title</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Noto+Sans+SC:wght@300;400;500;700&display=swap');
    /* === base.css tokens (copy :root block) === */
    /* === base.css reset + typography + layout + cards (skip slide system / chrome / presenter) === */
    /* === page.css (full file) === */
    /* === theme overrides (chosen theme's :root block) === */
    /* === animations.css (optional) === */
  </style>
</head>
<body>
  <nav class="navbar navbar-sticky">...</nav>
  <main class="page">...</main>
  <footer class="page-footer page">...</footer>
</body>
</html>
```

When inlining base.css, **skip** the slide system (`.deck`, `.slide`, `.is-active`,
`.is-prev`), chrome (`.deck-header`, `.deck-footer`, `.slide-number`, `.progress-bar`),
presenter/overview (`.notes`, `.notes-overlay`, `.overview`), and print styles.
Only include: `:root` tokens, reset, typography, layout primitives, cards, pills,
dividers, and utilities.

## Authoring rules — Deck mode

- **Always start from a template.** Don't author slides from scratch — copy the
  closest layout from `templates/single-page/` first, then replace content.
- **Use tokens, not literal colors.** Every color, radius, shadow should come
  from CSS variables defined in `assets/base.css` and overridden by a theme.
  Good: `color: var(--text-1)`. Bad: `color: #111`.
- **Don't invent new layout files.** Prefer composing existing ones. Only add
  a new `templates/single-page/*.html` if none of the 30 fit.
- **Respect chrome slots.** `.deck-header`, `.deck-footer`, `.slide-number`
  and the progress bar are provided by `assets/base.css` + `runtime.js`.
- **Keyboard-first.** Always include `<script src="../assets/runtime.js"></script>`
  so the deck supports ← → / T / A / F / S / O / hash deep-links.
- **One `.slide` per logical page.** `runtime.js` makes `.slide.is-active`
  visible; all others are hidden.
- **Supply notes.** Wrap speaker notes in `<div class="notes">…</div>` inside
  each slide. Press S to open the overlay.
- **NEVER put presenter-only text on the slide itself.** Descriptive text like
  "这一页展示了……" or "Speaker: 这里可以补充……" or small explanatory captions
  aimed at the presenter MUST go inside `<div class="notes">`, NOT as visible
  `<p>` / `<span>` elements on the slide. The `.notes` class is `display:none`
  by default — it only appears in the S overlay. Slides should contain ONLY
  audience-facing content (titles, bullet points, data, charts, images).

## Authoring rules — Page mode

- **Use `.page` containers, not `.deck`.** Structure is `<main class="page">` with
  `<section class="section">` children.
- **Use tokens, not literal colors.** Same rule as Deck mode — `var(--text-1)`,
  `var(--accent)`, `var(--bg-soft)`, etc. Never hard-code hex values.
- **Use base.css components freely.** `.card`, `.grid`, `.row`, `.stack`, `.pill`,
  `.h1`–`.h4`, `.lede`, `.gradient-text` — all work in page mode.
- **Add `page.css` for layout.** Link `assets/page.css` after `base.css`.
- **Do NOT include `runtime.js`.** It's for slide keyboard navigation and has
  no purpose in page mode.
- **Do NOT use `.slide`, `.deck`, or deck chrome classes.** They are for
  presentations only.
- **Responsive grids are automatic.** `page.css` adds breakpoints to `.grid`/`.row`
  so they collapse on mobile. No extra classes needed.
- **Use `.prose` for long text.** Wrap articles, documentation, or any long-form
  content in `<article class="prose">` for automatic typography.
- **Canvas FX are deck-only.** `data-fx` and `fx-runtime.js` depend on slide
  lifecycle. CSS animations (`data-anim` / `class="anim-*"`) work in both modes.

## Writing guide

See [references/authoring-guide.md](references/authoring-guide.md) for a
step-by-step walkthrough: file structure, naming, how to transform an outline
into a deck, how to choose layouts and themes per audience, how to do a
Chinese + English deck, and how to export.

## Catalogs (load when needed)

- [references/themes.md](references/themes.md) — all 36 themes with when-to-use.
- [references/layouts.md](references/layouts.md) — all 31 layout types (Deck mode).
- [references/animations.md](references/animations.md) — 27 CSS + 20 canvas FX animations.
- [references/full-decks.md](references/full-decks.md) — all 15 full-deck templates.
- [references/presenter-mode.md](references/presenter-mode.md) — **演讲者模式 + 逐字稿编写指南（技术分享/演讲必看）**.
- [references/authoring-guide.md](references/authoring-guide.md) — full workflow (Deck mode).
- [references/page-components.md](references/page-components.md) — **page.css 组件目录（Page mode）**.

## File structure

```
html-studio/
├── SKILL.md                 (this file)
├── references/              (detailed catalogs, load as needed)
├── assets/
│   ├── base.css             (tokens + primitives — shared by both modes)
│   ├── page.css             (page-mode layout: containers, sections, responsive, navbar, footer, prose)
│   ├── fonts.css            (webfont imports)
│   ├── runtime.js           (keyboard + presenter + overview + theme cycle — Deck mode only)
│   ├── themes/*.css         (36 token overrides, one per theme — shared by both modes)
│   └── animations/
│       ├── animations.css   (27 named CSS entry animations — shared by both modes)
│       ├── fx-runtime.js    (auto-init [data-fx] on slide enter — Deck mode only)
│       └── fx/*.js          (20 canvas FX modules — Deck mode only)
├── templates/
│   ├── deck.html                  (minimal 6-slide starter — Deck mode)
│   ├── theme-showcase.html        (36 slides, iframe-isolated per theme)
│   ├── layout-showcase.html       (iframe tour of all 31 layouts)
│   ├── animation-showcase.html    (20 FX + 27 CSS animation slides)
│   ├── full-decks-index.html      (gallery of all 14 full-deck templates)
│   ├── full-decks/<name>/         (14 scoped multi-slide deck templates)
│   └── single-page/*.html         (31 layout files with demo data)
├── scripts/
│   ├── new-deck.sh                (scaffold a deck from deck.html)
│   └── render.sh                  (headless Chrome → PNG)
└── examples/demo-deck/            (complete working deck)
```

## Rendering to PNG (Deck mode)

`scripts/render.sh` wraps headless Chrome at
`/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`. For multi-slide
capture, runtime.js exposes `#/N` deep-links, and render.sh iterates 1..N.

```bash
./scripts/render.sh templates/single-page/kpi-grid.html        # single page
./scripts/render.sh examples/demo-deck/index.html 8 out-dir    # 8 slides, custom dir
```

## Keyboard cheat sheet (Deck mode)

```
←  →  Space  PgUp  PgDn  Home  End    navigate
F                                       fullscreen
S                                       open presenter window (magnetic cards: current/next/script/timer)
N                                       quick notes drawer (bottom overlay)
R                                       reset timer (in presenter window)
?preview=N                              URL param — force preview-only mode (single slide, no chrome)
O                                       slide overview grid
T                                       cycle themes (reads data-themes attr)
A                                       cycle demo animation on current slide
#/N in URL                              deep-link to slide N
Esc                                     close all overlays
```

## License & author

MIT. Copyright (c) 2026 lewis &lt;sudolewis@gmail.com&gt;.
````

- [ ] **Step 2: Verify SKILL.md front matter parses correctly**

Run:
```bash
head -4 SKILL.md
```

Expected output:
```
---
name: html-studio
description: HTML Studio — author professional static HTML presentations AND website prototype pages...
---
```

- [ ] **Step 3: Commit**

```bash
git add SKILL.md
git commit -m "feat: rewrite SKILL.md as html-studio — dual-mode PPT + web page skill"
```

---

### Task 4: Verify no regressions

**Files:**
- None modified — read-only verification

- [ ] **Step 1: Confirm existing demo deck renders**

Open the existing demo deck to verify Deck mode is unaffected:

```bash
open /Users/likexing/cc/dev/public/html-ppt-skill/examples/demo-deck/index.html
```

Expected: Deck renders with all slides, keyboard nav works (← →), T cycles themes, S opens presenter.

- [ ] **Step 2: Confirm page.css exists and is well-formed**

```bash
cat assets/page.css | head -5
```

Expected: File starts with the comment `/* html-studio :: page.css`.

- [ ] **Step 3: Confirm no changes to protected files**

```bash
git diff HEAD~3 -- assets/base.css assets/runtime.js assets/fonts.css
```

Expected: Empty output (no changes to these files).

- [ ] **Step 4: Verify page-components reference doc**

```bash
wc -l references/page-components.md
```

Expected: File exists, non-zero line count.

- [ ] **Step 5: Final commit check**

```bash
git log --oneline -5
```

Expected: Three new commits visible:
1. `feat: add page.css — document-flow layout primitives for web pages`
2. `docs: add page-components.md — catalog for page.css classes`
3. `feat: rewrite SKILL.md as html-studio — dual-mode PPT + web page skill`
