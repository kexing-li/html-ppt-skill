# Bundle Script + README Update Design Spec

## Summary

Add `scripts/bundle.sh` — a shell script that packs any Deck or Page HTML into a single
self-contained file with all assets inlined. Update both README files to reflect the
`html-studio` dual-mode refactor.

---

## Deliverable 1: `scripts/bundle.sh`

### Interface

```bash
./scripts/bundle.sh <input.html> [output-dir]
```

- `<input.html>` — path to the HTML file to bundle (required)
- `[output-dir]` — output directory (optional, defaults to `dist/`)
- Output file: `<output-dir>/<basename>.html`

### What it does

1. Parse the HTML file for all `<link rel="stylesheet" href="...">` and `<script src="...">` tags
2. For each found reference, replace the tag with inline content:
   - **Local files** (relative paths like `../../../assets/base.css`): read file content, wrap in `<style>` or `<script>` as appropriate
   - **CDN URLs** (`https://cdn.jsdelivr.net/...`, `https://cdnjs.cloudflare.com/...`, `https://unpkg.com/...`): `curl` the content, wrap in `<style>` or `<script>`
   - **Google Fonts** (`@import url('https://fonts.googleapis.com/...')`): `curl` the CSS file (fonts themselves stay as Google CDN URLs — the CSS `src: url(...)` references are preserved; downloading actual font files is out of scope)
3. Write the result to `<output-dir>/<basename>.html`
4. Print summary: input file, output file, what was inlined (file count)

### Edge cases

- If `<output-dir>` doesn't exist, create it (`mkdir -p`)
- If a local file reference can't be resolved, print a warning and leave the tag as-is
- If a CDN URL fails to fetch, print a warning and leave the tag as-is
- Handle both `href="../assets/themes/minimal-white.css"` (relative) and paths starting from project root
- Script runs from repo root; relative paths are resolved relative to the input file's directory

### Example session

```
$ ./scripts/bundle.sh examples/demo-deck/index.html
→ dist/index.html (7 assets inlined: 5 CSS + 2 JS)

$ ./scripts/bundle.sh examples/demo-deck/index.html out
→ out/index.html (7 assets inlined: 5 CSS + 2 JS)
```

---

## Deliverable 2: README updates

### README.zh-CN.md changes

1. **Title/header**: `html-ppt · HTML PPT 工作室` → `html-studio · HTML 工作室`
2. **Tagline**: add "双模式：**Deck 模式**（HTML 演示文稿）+ **Page 模式**（网站原型页面）"
3. **Install section**: after "一行命令安装", update the example prompts to include Page mode:
   - "做一个 landing page，用 tokyo-night 主题"
   - "做一个产品介绍页，有导航栏和特性卡片"
4. **Skill 内容一览 table**: add page.css row
5. **Quick start**: add bundle.sh usage
6. **File structure**: add `page.css` in assets, `bundle.sh` in scripts
7. **Footer/naming**: update any remaining `html-ppt` references

### README.md changes

Same updates in English:
1. Title: `html-ppt — HTML PPT Studio` → `html-studio — HTML Studio`
2. Tagline: mention dual-mode
3. Add Page mode example prompts
4. Add page.css to feature table
5. Add bundle.sh usage
6. Update file structure

---

## Non-Goals

- Downloading actual font files (woff2 etc.) — Google Fonts CSS stays as @import
- Bundle for full-deck templates that use Chart.js/highlight.js CDN — these are curl'd inline
- No mode autodetection, no filtering — everything gets inlined
