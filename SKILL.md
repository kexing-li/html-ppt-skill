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
3. **Starting point.** Default is `knowledge-arch-blueprint` (暗底 + 蓝图风，
   适合技术分享和产品介绍). If the user's content points to a specific
   scenario (e.g. "产品发布会" → `product-launch`, "投资人 pitch" →
   `pitch-deck`), use that instead. Otherwise stick with the default.

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
