all: build upload

modify:  build serve

new:
	./new.sh

clean:
	rm -rf _build

build:
	run-rstblog build

serve:
	run-rstblog serve
