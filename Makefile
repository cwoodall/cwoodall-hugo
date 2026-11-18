# Keep in sync with hugo-version in .github/workflows/deploy.yml.
HUGO_VERSION := 0.101.0

.PHONY: all build serve check lint new clean submodules hugo-version

all: build

submodules:
	git submodule update --init --recursive

hugo-version:
	@hugo version | grep -q "v$(HUGO_VERSION)" || \
		echo "warning: expected hugo v$(HUGO_VERSION) extended, got: $$(hugo version)"

build: submodules hugo-version check
	hugo --minify

# Live preview with drafts at http://localhost:1313/ (Ctrl-C to stop).
serve: submodules hugo-version
	(sleep 2 && open "http://localhost:1313/") &
	hugo server -D --disableFastRender --navigateToChanged

# Fail on references to images/videos/pdfs that don't exist.
check:
	python3 scripts/check-assets.py

# All pre-commit hooks (spelling, prose, assets, build) on every file.
lint:
	pre-commit run --all-files

# make new SECTION=posts TITLE="My Trip Report"
new:
	@test -n "$(TITLE)" || (echo 'usage: make new SECTION=posts TITLE="My Title"'; exit 1)
	scripts/new.sh $(or $(SECTION),posts) "$(TITLE)"

clean:
	rm -rf public
