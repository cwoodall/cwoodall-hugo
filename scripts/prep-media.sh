#!/usr/bin/env bash
# Prepare photos/videos before committing them to a post bundle.
#
#   scripts/prep-media.sh content/posts/2025-06-01-my-trip/*.{jpg,jpeg,heic,mov}
#
# Photos (jpg/jpeg/png/heic): auto-rotated, long edge capped at 2400px, metadata
#   (incl. GPS) stripped, written as .jpg. Hugo makes the smaller web sizes at
#   build time; this just keeps multi-MB phone originals out of git.
# Videos (mov/mp4/m4v): re-encoded to H.264/AAC .mp4 (plays in every browser;
#   iPhone HEVC .mov does not), max 1280px wide, faststart for streaming.
#
# Originals are replaced (a .mov/.heic is deleted after its .mp4/.jpg is made).
# Requires ImageMagick (magick) and ffmpeg.
set -euo pipefail

MAX_PX=2400
VIDEO_W=1280

if [ $# -eq 0 ]; then
    sed -n '2,13p' "$0"; exit 1
fi

for f in "$@"; do
    [ -f "$f" ] || { echo "skip (not a file): $f"; continue; }
    ext=$(echo "${f##*.}" | tr 'A-Z' 'a-z')
    base="${f%.*}"
    case "$ext" in
        jpg|jpeg|png|heic)
            out="$base.jpg"
            [ "$ext" = png ] && out="$f"   # keep PNGs (screenshots/diagrams) as PNG
            before=$(du -h "$f" | cut -f1)
            magick "$f" -auto-orient -resize "${MAX_PX}x${MAX_PX}>" -strip -quality 85 "$out.tmp"
            mv "$out.tmp" "$out"
            [ "$out" != "$f" ] && rm "$f"
            echo "photo  $f ($before) -> $out ($(du -h "$out" | cut -f1))"
            ;;
        mov|mp4|m4v)
            out="$base.mp4"
            before=$(du -h "$f" | cut -f1)
            ffmpeg -hide_banner -loglevel error -y -i "$f" \
                -c:v libx264 -preset slow -crf 26 -pix_fmt yuv420p \
                -vf "scale='min(${VIDEO_W},iw)':-2" \
                -c:a aac -b:a 96k -movflags +faststart -map_metadata -1 \
                "$base.tmp.mp4"
            mv "$base.tmp.mp4" "$out"
            [ "$out" != "$f" ] && rm "$f"
            echo "video  $f ($before) -> $out ($(du -h "$out" | cut -f1))"
            ;;
        *)
            echo "skip (unknown type): $f"
            ;;
    esac
done
