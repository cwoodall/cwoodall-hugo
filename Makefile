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
	hugo server -D &
	open "http://localhost:1313/"

.PHONY: end_serve
end_serve:
	killall hugo