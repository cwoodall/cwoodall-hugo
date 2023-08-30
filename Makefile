.PHONY: all
all:
	git submodule init && git submodule update
	hugo

.PHONY: clean
clean:
	rm -rf public

.PHONY: serve
serve:
	git submodule init && git submodule update
	hugo server -D