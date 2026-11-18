#!/usr/bin/env bash
# Create a new dated page bundle:  scripts/new.sh posts "My Trip Report"
#   -> content/posts/2025-06-01-my-trip-report/index.md
# Put images/videos in that folder next to index.md.
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "usage: $0 <section> <title>   (section: posts, climbing, projects, reading, …)"; exit 1
fi

slugify () {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9]+/-/g; s/^-+|-+$//g' | tr A-Z a-z
}

dir="$1/$(date +%Y-%m-%d)-$(slugify "$2")"
hugo new --kind bundle "$dir"
# Use the title exactly as typed (escaping quotes for YAML).
TITLE="${2//\"/\\\"}" perl -pi -e 's/^title: .*/title: "$ENV{TITLE}"/' "content/$dir/index.md"
echo "Created content/$dir/index.md"
