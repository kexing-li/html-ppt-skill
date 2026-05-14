# Bundle Script + README Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `scripts/bundle.sh` to inline all assets into a self-contained HTML file, and update both README files to reflect the html-studio dual-mode refactor.

**Architecture:** A shell script that reads an HTML file, finds all `<link>` and `<script>` tags, replaces them with inlined content (local files read from disk, CDN URLs fetched via curl), then writes a single self-contained HTML. README updates are targeted string replacements across both `README.md` and `README.zh-CN.md`.

**Tech Stack:** Bash with perl for inline replacement (curl, grep, sed, perl — all pre-installed on macOS).

---

## File Map

| File | Action | Responsibility |
|------|--------|---------------|
| `scripts/bundle.sh` | Create | Self-contained HTML bundler |
| `README.zh-CN.md` | Modify | Update Chinese README for html-studio |
| `README.md` | Modify | Update English README for html-studio |

---

### Task 1: Create `scripts/bundle.sh`

**Files:**
- Create: `scripts/bundle.sh`

The script follows the same style as `scripts/render.sh` (set -euo pipefail, usage function, error checks). Uses perl (pre-installed on macOS) for reliable multi-line tag replacement.

- [ ] **Step 1: Create the script**

Create `scripts/bundle.sh`:

```bash
#!/usr/bin/env bash
# html-studio :: bundle.sh — pack a Deck or Page HTML into a single self-contained file
#
# Usage:
#   bundle.sh <input.html>                # → dist/<basename>.html
#   bundle.sh <input.html> <out-dir>      # → <out-dir>/<basename>.html
#
# Inlines all <link rel="stylesheet" href="..."> and <script src="...">
# references. Local paths are resolved relative to the input file's directory.
# CDN URLs are fetched via curl. Output is a single self-contained HTML file.

set -euo pipefail

FILE="${1:-}"
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  echo "usage: bundle.sh <input.html> [out-dir]" >&2
  exit 1
fi

OUT_DIR="${2:-dist}"
INPUT_DIR="$(cd "$(dirname "$FILE")" && pwd)"
BASE=$(basename "$FILE")

mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/$BASE"

# Copy input to output — we'll modify the output file in place.
cp "$FILE" "$OUT"

CSS_COUNT=0
JS_COUNT=0

# Resolve href/src to an absolute path or leave as-is for URLs.
resolve() {
  local p="$1"
  if [[ "$p" == http://* || "$p" == https://* ]]; then
    echo "$p"
  else
    echo "$INPUT_DIR/$p"
  fi
}

# ---- inline <link rel="stylesheet" href="..."> ----
# Collect all link tags first, then process each one against the output file.
links=$(grep -o '<link[^>]*rel="stylesheet"[^>]*href="[^"]*"[^>]*>' "$OUT" || true)
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  href=$(echo "$tag" | sed -n 's/.*href="\([^"]*\)".*/\1/p')
  [[ -z "$href" ]] && continue

  src=$(resolve "$href")
  if [[ "$src" == http://* || "$src" == https://* ]]; then
    content=$(curl -sSL --max-time 15 "$src" 2>/dev/null) || { echo "  ⚠ CDN fetch failed: $src" >&2; continue; }
  elif [[ -f "$src" ]]; then
    content=$(cat "$src")
  else
    echo "  ⚠ file not found: $src" >&2
    continue
  fi

  # Use perl to replace the exact tag with <style>content</style>.
  # \Q...\E quotes the tag literal; the content is interpolated directly.
  perl -i -0 -pe "s{\Q$tag\E}{<style>\n$content\n</style>}" "$OUT"
  CSS_COUNT=$((CSS_COUNT + 1))
done <<< "$links"

# ---- inline <script src="..."> ----
scripts=$(grep -o '<script[^>]*src="[^"]*"[^>]*></script>' "$OUT" || true)
while IFS= read -r tag; do
  [[ -z "$tag" ]] && continue
  src_url=$(echo "$tag" | sed -n 's/.*src="\([^"]*\)".*/\1/p')
  [[ -z "$src_url" ]] && continue

  src=$(resolve "$src_url")
  if [[ "$src" == http://* || "$src" == https://* ]]; then
    content=$(curl -sSL --max-time 15 "$src" 2>/dev/null) || { echo "  ⚠ CDN fetch failed: $src" >&2; continue; }
  elif [[ -f "$src" ]]; then
    content=$(cat "$src")
  else
    echo "  ⚠ file not found: $src" >&2
    continue
  fi

  perl -i -0 -pe "s{\Q$tag\E}{<script>\n$content\n</script>}" "$OUT"
  JS_COUNT=$((JS_COUNT + 1))
done <<< "$scripts"

echo "→ $OUT ($CSS_COUNT CSS + $JS_COUNT JS inlined)"
```

- [ ] **Step 2: Make script executable**

```bash
chmod +x /Users/likexing/cc/dev/public/html-ppt-skill/scripts/bundle.sh
```

- [ ] **Step 3: Test with demo deck**

```bash
cd /Users/likexing/cc/dev/public/html-ppt-skill
./scripts/bundle.sh examples/demo-deck/index.html
```

Expected output: `→ dist/index.html (N CSS + M JS inlined)`

Open and verify it renders with keyboard navigation working:

```bash
open dist/index.html
```

- [ ] **Step 4: Commit**

```bash
cd /Users/likexing/cc/dev/public/html-ppt-skill
git add scripts/bundle.sh
git commit -m "feat: add bundle.sh — pack HTML into single self-contained file"
```

---

### Task 2: Update README.zh-CN.md

**Files:**
- Modify: `README.zh-CN.md`

- [ ] **Step 1: Update title and tagline**

Replace line 1-6 (title + tagline block):

Old:
```
# html-ppt · HTML PPT 工作室

> 一款专业级的 AgentSkill，让 AI 做出真正能打的 HTML 演示文稿。
> **36 套主题**、**15 套完整 deck 模板**、**31 种页面布局**、**47 个动效**
> (27 个 CSS + 20 个 Canvas FX)，加上全新的 **演讲者模式** —— 像素级
> 完美预览 + 逐字稿提词器 + 计时器。纯静态 HTML/CSS/JS，无需构建。
```

New:
```
# html-studio · HTML 工作室

> 一款专业级的 AgentSkill，让 AI 做出真正能打的 HTML 演示文稿和网站原型。
> 双模式：**Deck 模式**（幻灯片演示）+ **Page 模式**（网站原型页面）。
> **36 套主题**、**15 套完整 deck 模板**、**31 种页面布局**、**47 个动效**
> (27 个 CSS + 20 个 Canvas FX)，加上全新的 **演讲者模式** —— 像素级
> 完美预览 + 逐字稿提词器 + 计时器。纯静态 HTML/CSS/JS，无需构建。
```

- [ ] **Step 2: Update install section prompts**

After line 55 (the "做一份带演讲者模式..." line), insert these two lines:

```
> "做一个 landing page，用 tokyo-night 主题"
> "做一个产品介绍页，有导航栏和特性卡片"
```

- [ ] **Step 3: Update "Skill 内容一览" table**

Add a row after the "验证截图" row (line 68):

```
| 🌐 **Page 布局系统** | **新增** | `assets/page.css` |
```

- [ ] **Step 4: Update "快速开始" section**

After the PNG export lines (line 168-169), add:

```
# 打包成单文件（所有 CSS/JS inline，完全离线可用）
./scripts/bundle.sh examples/my-talk/index.html
```

- [ ] **Step 5: Update "项目结构" section**

Add `bundle.sh` to scripts section, and `page.css` to assets section. Replace lines 188-222 (the project structure block):

```
```
html-ppt-skill/
├── SKILL.md                      agent 入口
├── README.md                     英文 README
├── README.zh-CN.md               本文件
├── references/                   详细文档
│   ├── themes.md                 36 主题 + 使用场景
│   ├── layouts.md                31 布局
│   ├── animations.md             27 CSS + 20 FX 目录
│   ├── full-decks.md             15 完整 deck 模板
│   ├── presenter-mode.md         🎤 演讲者模式 + 逐字稿指南
│   ├── authoring-guide.md        完整工作流
│   └── page-components.md        🌐 Page 模式组件目录
├── assets/
│   ├── base.css                  共享 tokens + 基础组件
│   ├── page.css                  Page 模式布局（容器/section/navbar/footer/prose）
│   ├── fonts.css                 web 字体引入
│   ├── runtime.js                键盘导航 + 演讲者模式 + 总览
│   ├── themes/*.css              36 主题 token 文件
│   └── animations/
│       ├── animations.css        27 个命名 CSS 动画
│       ├── fx-runtime.js         进入 slide 自动初始化 [data-fx]
│       └── fx/*.js               20 个 Canvas FX 模块
├── templates/
│   ├── deck.html                 最小起步模板
│   ├── theme-showcase.html       iframe 隔离的主题 tour
│   ├── layout-showcase.html      全部 31 布局
│   ├── animation-showcase.html   47 动画 slide
│   ├── full-decks-index.html     15 deck gallery
│   ├── full-decks/<name>/        15 个 scoped 多页 deck 模板
│   └── single-page/*.html        31 个布局文件（带示例数据）
├── scripts/
│   ├── new-deck.sh               脚手架
│   ├── render.sh                 headless Chrome → PNG
│   ├── bundle.sh                 打包成单文件（全部 CSS/JS inline）
│   └── verify-output/            56 张自测截图
└── examples/demo-deck/           完整可运行的示例 deck
```
```

- [ ] **Step 6: Commit**

```bash
git add README.zh-CN.md
git commit -m "docs: update zh-CN README for html-studio dual-mode refactor"
```

---

### Task 3: Update README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update title and tagline**

Replace lines 1-7:

Old:
```
# html-ppt — HTML PPT Studio

> A world-class AgentSkill for producing professional HTML presentations in
> **36 themes**, **15 full-deck templates**, **31 page layouts**,
> **47 animations** (27 CSS + 20 canvas FX), and a **true presenter mode**
> with pixel-perfect previews + speaker script + timer — all pure static
> HTML/CSS/JS, no build step.
```

New:
```
# html-studio — HTML Studio

> A world-class AgentSkill for producing professional HTML presentations
> AND website prototypes. Two modes: **Deck mode** (slide presentations)
> and **Page mode** (website prototype pages). **36 themes**,
> **15 full-deck templates**, **31 page layouts**,
> **47 animations** (27 CSS + 20 canvas FX), and a **true presenter mode**
> with pixel-perfect previews + speaker script + timer — all pure static
> HTML/CSS/JS, no build step.
```

- [ ] **Step 2: Add Page mode example prompts**

After line 58 (the last prompt line), add:

```
> "make a landing page with tokyo-night theme"
> "make a product page with a navbar and feature cards"
```

- [ ] **Step 3: Update "What's in the box" table**

Add after the "Verification screenshots" row:

```
| 🌐 **Page layout system** | **NEW** | `assets/page.css` |
```

- [ ] **Step 4: Update "Quick start" section**

After the PNG export line (line 166), add:

```
# Bundle into a single self-contained file (all CSS/JS inlined, fully offline)
./scripts/bundle.sh examples/my-talk/index.html
```

- [ ] **Step 5: Update "Project structure" section**

Replace lines 185-217 with:

```
```
html-ppt-skill/
├── SKILL.md                      agent-facing dispatcher
├── README.md                     this file
├── references/                   detailed catalogs
│   ├── themes.md                 36 themes with when-to-use
│   ├── layouts.md                31 layout types
│   ├── animations.md             27 CSS + 20 FX catalog
│   ├── full-decks.md             14 full-deck templates
│   ├── presenter-mode.md         🎤 presenter mode + speaker script guide
│   ├── authoring-guide.md        full workflow
│   └── page-components.md        🌐 Page mode component catalog
├── assets/
│   ├── base.css                  shared tokens + primitives
│   ├── page.css                  Page mode layout (containers/sections/navbar/footer/prose)
│   ├── fonts.css                 webfont imports
│   ├── runtime.js                keyboard + presenter + overview
│   ├── themes/*.css              36 theme token files
│   └── animations/
│       ├── animations.css        27 named CSS animations
│       ├── fx-runtime.js         auto-init [data-fx] on slide enter
│       └── fx/*.js               20 canvas FX modules
├── templates/
│   ├── deck.html                 minimal starter
│   ├── theme-showcase.html       iframe-isolated theme tour
│   ├── layout-showcase.html      all 31 layouts
│   ├── animation-showcase.html   47 animation slides
│   ├── full-decks-index.html     14-deck gallery
│   ├── full-decks/<name>/        14 scoped multi-slide decks
│   └── single-page/*.html        31 layout files with demo data
├── scripts/
│   ├── new-deck.sh               scaffold
│   ├── render.sh                 headless Chrome → PNG
│   ├── bundle.sh                 pack into single self-contained file
│   └── verify-output/            56 self-test screenshots
└── examples/demo-deck/           complete working deck
```
```

- [ ] **Step 6: Commit**

```bash
git add README.md
git commit -m "docs: update English README for html-studio dual-mode refactor"
```
