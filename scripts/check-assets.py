#!/usr/bin/env python3
"""Fail if any content file references a local image/media/pdf that doesn't exist.

Checks markdown images/links, HTML src/href attributes, shortcode src= params,
and `image:` front matter. Absolute paths ("/img/...") resolve against static/;
relative paths ("falls.jpg") resolve against the page bundle directory.
"""
import re
import sys
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent.parent
CONTENT = ROOT / "content"
STATIC = ROOT / "static"

MEDIA_EXT = r"(?:jpe?g|png|gif|webp|svg|mp4|mov|webm|mp3|wav|pdf)"
PATTERNS = [
    re.compile(r"!?\[[^\]]*\]\(\s*<([^>]+)>"),      # [x](<path with spaces.jpg>)
    re.compile(r"!?\[[^\]]*\]\(\s*([^)<\s]+)"),     # [x](path.jpg "title")
    re.compile(r"""\b(?:src|href)\s*=\s*["']([^"']+)["']"""),
    re.compile(r"""\{\{<\s*video\s+(?:src=)?["']([^"']+)["']"""),
    re.compile(r"""^image:\s*["']?([^"'\n]+?)["']?\s*$""", re.M),
]


def candidates(text):
    for pat in PATTERNS:
        for m in pat.finditer(text):
            ref = m.group(1).strip().split("#")[0].split("?")[0]
            if re.match(r"^[a-z]+:", ref) or ref.startswith("//"):
                continue  # remote URL / mailto
            if re.search(r"\." + MEDIA_EXT + r"$", ref, re.I):
                yield ref


def main():
    missing = []
    for md in sorted(CONTENT.rglob("*.md")):
        text = md.read_text(encoding="utf-8")
        for ref in set(candidates(text)):
            path = unquote(ref)
            target = STATIC / path.lstrip("/") if path.startswith("/") else md.parent / path
            if not target.exists():
                missing.append(f"{md.relative_to(ROOT)}: {ref}")
    if missing:
        print("Missing assets:")
        print("\n".join(f"  {m}" for m in missing))
        return 1
    print("All local asset references resolve.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
