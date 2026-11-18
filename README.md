# cwoodall.com

Hugo site. Tool versions (Hugo 0.170.1, Dart Sass, pre-commit, Vale) are pinned in
`mise.toml`, and CI installs the same versions.
Pushes to `main` build and deploy to `cwoodall/cwoodall.github.io`; pull requests only build.

```sh
mise run serve                       # live preview incl. drafts
mise run new "My Trip"               # new dated page bundle (--section climbing, …)
mise run check                       # find broken image/video/pdf references
mise run build                       # production build into public/
mise tasks                           # list all tasks (defined in mise.toml)
```

## Setup and checks

```sh
mise install          # hugo, dart-sass, pre-commit, vale (see mise.toml)
pre-commit install    # run the checks on every commit
mise run lint         # run them on every file
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

1. `mise run new "Bike Overnight"` creates
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

   {{< img src="screenshot.png" width="200" alt="Fixed-width image" >}}

   [Download the audio](resources/clip.wav)
   ```

   Links to files in the bundle (audio, PDFs, …) work like images: use the
   relative name, and a missing file fails the build.

   Name one image `cover.jpg` to make it the hero/list image (no front matter needed).
4. Set `draft: false` when ready.

Hugo resizes bundle images to responsive webp at build time
(`layouts/_default/_markup/render-image.html`); full-size originals are never published.
A missing file fails the build. The first build after adding many photos is slow
(processed images are cached in `resources/_gen/`).

Every post now uses a page bundle; `static/` only holds site-wide files (resume, PDFs, avatar).

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
