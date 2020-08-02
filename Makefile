all: clean build serve

modify:  build serve

new:
	./new.sh

clean:
	rm -rf _build

build:
	run-rstblog build

serve:
	run-rstblog serve

upload:
	rsync -a _build/ los-ladder-2:/www/html/blog.iwantadog.monster/
