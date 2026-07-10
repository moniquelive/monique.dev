# Repository Guidelines

## Project structure

- `content/` contains Markdown pages. Put articles in `content/posts/`; the home page is
  `content/_index.md`. Keep unfinished articles marked `draft: true`.
- `layouts/` contains site-level Hugo overrides. Put reusable overrides in `layouts/partials/` and
  prefer an override here for site-specific behavior.
- `themes/lirio/` is tracked local theme source, not a submodule or Hugo Module. Edit it when a
  change belongs to the theme itself; keep site-only customizations in `layouts/`.
- `assets/css/` contains CSS processed by Hugo Pipes. `static/` contains files copied verbatim to
  the published site, so optimize those assets before committing.
- Main navigation is currently hardcoded in `themes/lirio/layouts/partials/header.html`; update that
  partial when changing the links.
- `wrangler.toml` configures Cloudflare Workers hosting, and `build.sh` is its remote build entry
  point.
- `public/`, `resources/`, and `.hugo_build.lock` are generated. Do not hand-edit or commit
  them.

## Tooling and commands

Install the pinned toolchain with `mise install` and the locked Node dependencies with `npm ci`,
then use the repository tasks:

- `mise run dev` starts Hugo with drafts and full template reloads.
- `mise run test` performs the baseline build with path warnings enabled.
- `mise run build` creates the minified production site in `public/`. It must use
  `--cleanDestinationDir`; `--gc` cleans Hugo caches, not stale files in the destination.
- `mise run ci` runs validation and the production build.
- `mise run clean` removes generated Hugo output and transient files.
- `hugo list drafts` audits unpublished content.

## Content and code conventions

- Keep front matter in YAML with lower-case keys. Posts use `title`, `date`, `description`, `tags`,
  optional `images` (a YAML list), and optional `draft`; do not introduce aliases such as
  `summary` or `cover_image`.
- Wrap long descriptions near 100 characters. Use sentence-case Markdown headings and fenced code
  blocks with language identifiers.
- Name Go templates and partials in kebab-case and indent template bodies with two spaces.
- CSS in `assets/css/` and `themes/lirio/assets/css/` uses BEM-inspired class names and two-space
  indentation. Run `npm run format:check` after CSS changes.

## Validation

- A warning-free `mise run ci` is the minimum check. Investigate output from
  `hugo --printPathWarnings --printUnusedTemplates` when changing templates or configuration.
- For navigation or long-form content changes, build into a clean destination and run the
  locked link checker with `npm run links`.
- For visual changes, compare desktop and mobile screenshots from `mise run dev`; check overflow,
  image loading, headings, focus states, and the 404 page.
- When changing `build.sh`, run `bash -n build.sh` and keep its Hugo version aligned with
  `mise.toml`.

## Commits and pull requests

- Follow Conventional Commits (`feat(scope): message`, `fix(scope): message`). Use an imperative
  summary under 70 characters and squash local work-in-progress commits before opening a PR.
- PRs should describe user-visible changes, list the commands run, link relevant issues, and attach
  updated desktop/mobile screenshots for UI changes.
