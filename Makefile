# Use the cache, compile from generated files, remove temporary code files
overleaf:
	touch ForceCache
	xelatex -shell-escape sidsmain.tex

clean:
	rm -f sidsmain.aux generated/*.txt

deepclean:
	rm -f sidsmain.aux generated/*

# stop the talk2stat server, but don't compile the book:
stopserver: clean
	python3 -c 'from talk2stat.talk2stat import client; client("./","R","QUIT")'
	rm -f serverPIDR.txt Rdebug.txt talk2stat.log nohup.out
 
# build the book and use the server, not the cache option:
build: clean
	rm -f ForceCache nohup.out
	mkdir -p tmp
	@for i in $$(seq 1 8); do \
	    mkdir -p images/chapter_$$i; \
	done
#	latexmk -pdflatex='xelatex -shell-escape %O %S' -pdf sidsmain.tex
	xelatex -shell-escape sidsmain.tex
	bibtex sidsmain
	xelatex -shell-escape sidsmain.tex
	xelatex -shell-escape sidsmain.tex

