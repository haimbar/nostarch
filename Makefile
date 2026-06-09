# Build a self-contained copy in tmpoverleaf/, compile it, then rsync to Overleaf.
# Usage: make overleaf              (compile only)
#        make overleaf DEST=~/Documents/GitHub/<project-id>/  (compile + rsync)
overleaf:
	python3 make_overleaf.py $(DEST)

clean:
	rm -f sidsmain.aux generated/*.txt  sidsmain.ind

deepclean:
	rm -fr sidsmain.aux sidsmain.mw sidsmain.ind generated/* images/chapter_*

# stop the talk2stat server, but don't compile the book:
stopserver: deepclean
	python3 -c 'from talk2stat.talk2stat import client; client("./","R","QUIT")'
	rm -f serverPIDR.txt Rdebug.txt talk2stat.log nohup.out
 
# build the book and use the server, not the cache option:
build: clean
	rm -f ForceCache nohup.out
	mkdir -p tmp
	@for i in $$(seq 1 8); do \
	    mkdir -p images/chapter_$$i; \
	done
	# Stop any existing server so the fresh one picks up the current R.config
	-python3 -c 'from talk2stat.talk2stat import client; client("./","R","QUIT")'
	-rm -f serverPIDR.txt
	# Pre-start R server so it is ready before xelatex sends any \runR commands
	python3 -c 'from talk2stat.talk2stat import server,client; server("./","R") if not client("./","R","``` ```") else print("server already running")'
	python3 wait_for_rserver.py
#	latexmk -pdflatex='xelatex -shell-escape %O %S' -pdf sidsmain.tex
	xelatex -shell-escape --no-pdf sidsmain.tex
	# Sync barrier: block until R has finished all queued work before caching results
	python3 -c 'from talk2stat.talk2stat import client; client("./","R","``` invisible(NULL) ```")'
	touch ForceCache
	bibtex sidsmain
	makeindex sidsmain
	xelatex -shell-escape sidsmain.tex
	xelatex -shell-escape sidsmain.tex

