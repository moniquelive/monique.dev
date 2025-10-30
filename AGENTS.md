# Repository Guidelines

## Project Structure & Module Organization
- `content/` stores all Markdown pages; organize posts under `content/posts/` and keep `draft: true` until ready to publish. The home page lives at `content/_index.md`.
- `layouts/` overrides theme partials; keep overrides minimal and colocate shared blocks in `layouts/partials/` if you add them.
- `static/` holds published assets (`css/`, `images/`, `CNAME`). Assets here deploy verbatim, so optimize files before committing.
- `themes/lirio/` is the primary theme module; treat it as upstream code and prefer extending it via `layouts/` rather than editing theme files directly.
- `data/menu.toml` defines navigation metadata. `resources/_gen/` and `public/` are Hugo build outputs—do not hand-edit them.

## Build, Test, and Development Commands
- `hugo server -D --disableFastRender` runs the live preview with drafts and forces full reloads when templates change.
- `hugo` builds the production bundle into `public/`; use `hugo --gc --minify` before deploying to purge stale assets and minify output.
- `hugo list drafts` quickly audits unpublished content.

## Coding Style & Naming Conventions
- Front matter should stay in YAML, using lower-case keys (`title`, `summary`, `tags`, `draft`); wrap long summaries at ~100 characters.
- Markdown headings use sentence case; prefer fenced code blocks with language hints.
- Go template files and partial names use kebab-case (e.g., `hero-banner.html`) with two-space indentation inside `{{ ... }}` blocks.
- CSS under `static/css/` follows BEM-inspired class names and uses two-space indentation; run `npx prettier static/css/*.css` if you adjust formatting.

## Testing Guidelines
- Treat a clean `hugo` build as the baseline test. Investigate any warnings surfaced by `hugo --printPathWarnings`.
- Validate external links with `hugo --renderToDisk && npx linkinator public/` when updating navigation or long-form posts.
- For visual regressions, compare before/after screenshots from `hugo server` across desktop and mobile widths.

## Commit & Pull Request Guidelines
- Follow the conventional commits pattern observed in history (`feat(scope): message`, `fix(scope): message`); keep summaries imperative and under 70 characters.
- Squash work-in-progress commits locally before opening a PR.
- PRs must describe user-visible changes, list the Hugo command(s) run, and attach updated screenshots for UI tweaks. Link tracking issues or cards where applicable.
