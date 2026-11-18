# cwoodall.com

Hugo site (pinned to Hugo **0.101.0 extended**; see `Makefile` / `.github/workflows/deploy.yml`).
Pushes to `main` build and deploy to `cwoodall/cwoodall.github.io`; pull requests only build.

```sh
make serve                                   # live preview incl. drafts
make new SECTION=posts TITLE="My Trip"       # new dated page bundle
make check                                   # find broken image/video/pdf references
make build                                   # production build into public/
```

## Setup and checks

```sh
mise install          # hugo 0.101.0, pre-commit, vale (see mise.toml)
pre-commit install    # run the checks on every commit
make lint             # run them on every file
```

On commit, pre-commit runs:

- **cspell** (spelling). Config is `cspell.json`, shared with the VS Code Code Spell
  Checker. Add names and jargon to `.cspell/project-words.txt`.
- **Vale** (grammar/style, `.vale.ini`). Real mistakes such as doubled words block
  the commit; style suggestions (e.g. "very") print as warnings only.
- **check-assets**, which flags missing image, video or PDF references, plus a full
  **hugo build**.
- Whitespace/YAML/TOML checks, and a 4 MB limit on newly added files (run
  `scripts/prep-media.sh` on photos first).

Grammarly has no command-line tool, so it can't run in pre-commit. The VS Code
Grammarly extension is set to check all of `content/` while you edit.
Skip the checks with `git commit --no-verify`, or skip one with `SKIP=vale git commit`.

## Writing a post with images

1. `make new SECTION=posts TITLE="Bike Overnight"` creates
   `content/posts/YYYY-MM-DD-bike-overnight/index.md`.
2. Copy photos/videos into that folder, then shrink them before committing:
   `scripts/prep-media.sh content/posts/YYYY-MM-DD-bike-overnight/*`
   (caps photos at 2400px, strips GPS/metadata, converts `.mov`/HEVC to H.264 `.mp4`).
3. Reference files by name:

   ```markdown
   ![Alt text](falls.jpg "Optional caption")

   {{< gallery >}}
   ![](a.jpg)
   ![](b.jpg "Caption")
   {{< /gallery >}}

   {{< video "tunnel.mp4" >}}
   ```

   Name one image `cover.jpg` to make it the hero/list image (no front matter needed).
4. Set `draft: false` when ready.

Hugo resizes bundle images to responsive webp at build time
(`layouts/_default/_markup/render-image.html`); full-size originals are never published.
A missing file fails the build. The first build after adding many photos is slow
(processed images are cached in `resources/_gen/`).

Older posts reference `/img/...` files in `static/`; those still work unchanged.

## Styles

All CSS lives in `assets/sass/` (it overrides the theme's copy, so never edit
`themes/researcher`):

| File | What |
|---|---|
| `_variables.scss` | colors, widths, fonts, spacing |
| `_base.scss` | fonts, navbar, footer, links |
| `_content.scss` | headings, lists, tables, code, article header, post lists |
| `_figures.scss` | images, captions, galleries, video |
| `_syntax.scss` | code highlighting colors |

Shared page templates are `layouts/partials/article.html` (single pages),
`post-list.html` (section lists) and `cover.html` (hero image). Avoid inline
`style=` in posts; add a class in `_figures.scss` or `_content.scss` instead.
