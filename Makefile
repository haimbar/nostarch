# Build a self-contained copy in tmpoverleaf/, compile it, then rsync to Overleaf.
# Usage: make overleaf              (compile only)
#        make overleaf DEST=~/Documents/GitHub/<project-id>/  (compile + rsync)
CHAPTER_GOALS := 1 2 3 4 5 6 7 8 9 10
CHAPTER_ARG := $(or $(CHAPTER),$(filter $(CHAPTER_GOALS),$(MAKECMDGOALS)))

.PHONY: overleaf chapter $(CHAPTER_GOALS) clean check-generated deepclean stopserver build rebuild

overleaf:
	python3 make_overleaf.py $(DEST)

chapter:
	@test -n "$(CHAPTER_ARG)" || (printf '%s\n' 'Usage: make chapter 9' >&2; exit 1)
	rm -f tmp/chapter_$(CHAPTER_ARG).restore
	rm -f ForceCache nohup.out
	python3 make_chapter.py --prepare $(CHAPTER_ARG) $(if $(FORCE),--force,)
	mkdir -p images/chapter_$(CHAPTER_ARG) generated/chapter_$(CHAPTER_ARG)
	rm -rf tmp/generated
	ln -s ../generated tmp/generated
	-python3 -c 'from talk2stat.talk2stat import client; client("./","R","QUIT")'
	-rm -f serverPIDR.txt
	python3 -c 'from talk2stat.talk2stat import server,client; server("./","R") if not client("./","R","``` ```") else print("server already running")'
	python3 wait_for_rserver.py
	@if [ -f tmp/chapter_$(CHAPTER_ARG).restore ]; then \
	    python3 -c 'from talk2stat.talk2stat import client; client("./","R","``` load(\"generated/chapter_$(CHAPTER_ARG)/session.RData\") ```")'; \
	fi
	xelatex -interaction=nonstopmode -shell-escape -output-directory=tmp tmp/chapter_$(CHAPTER_ARG).tex
	python3 -c 'from talk2stat.talk2stat import client; client("./","R","``` invisible(NULL) ```")'
	python3 -c 'from talk2stat.talk2stat import client; client("./","R","``` save.image(\"generated/chapter_$(CHAPTER_ARG)/session.RData\") ```")'
	python3 make_chapter.py --record $(CHAPTER_ARG)
	touch ForceCache
	xelatex -interaction=nonstopmode -shell-escape -output-directory=tmp tmp/chapter_$(CHAPTER_ARG).tex
	$(MAKE) check-generated

# Make treats a bare number on the command line as another target. This empty
# rule lets `make chapter 9` pass that number through to the chapter target.
$(CHAPTER_GOALS):

clean:
	rm -f sidsmain.aux sidsmain.log sidsmain.ind

# Generated outputs must not have been marked stale or contain an execution
# error during the first LaTeX pass. The stale markers are created by
# runcode.sty when a source checksum no longer matches its cached output.
check-generated:
	@stale="$$(find generated -type f -name '*.stale' -print)"; \
	if [ -n "$$stale" ]; then \
	    printf '%s\n' "Stale generated outputs:" >&2; \
	    printf '%s\n' "$$stale" >&2; \
	    exit 1; \
	fi
	@if grep -R -l --include='*.tex' '**ZERO BYTES IN OUTPUT**' generated >/dev/null 2>&1; then \
	    printf '%s\n' "Generated outputs contain the zero-byte diagnostic." >&2; \
	    grep -R -l --include='*.tex' '**ZERO BYTES IN OUTPUT**' generated >&2; \
	    exit 1; \
	fi
	@if grep -R -l --include='*.tex' -E '(^|:)Error:|Output file .* not found' generated >/dev/null 2>&1; then \
	    printf '%s\n' "Generated outputs contain an execution error:" >&2; \
	    grep -R -l --include='*.tex' -E '(^|:)Error:|Output file .* not found' generated >&2; \
	    exit 1; \
	fi

deepclean:
	rm -fr sidsmain.aux sidsmain.mw sidsmain.ind generated/* images/chapter_*

# stop the talk2stat server, but don't compile the book:
stopserver: deepclean
	python3 -c 'from talk2stat.talk2stat import client; client("./","R","QUIT")'
	rm -f serverPIDR.txt Rdebug.txt talk2stat.log nohup.out
 
# Build stale chapters first, then assemble the full book from chapter caches.
build: clean
	rm -f ForceCache nohup.out
	@set -e; for n in $(CHAPTER_GOALS); do \
	    if python3 make_chapter.py --cache-valid $$n; then \
	        printf '%s\n' "Using cached chapter $$n"; \
	    else \
	        $(MAKE) chapter $$n; \
	    fi; \
	done
#	latexmk -pdflatex='xelatex -shell-escape %O %S' -pdf sidsmain.tex
	touch ForceCache
	xelatex -interaction=nonstopmode -shell-escape --no-pdf sidsmain.tex
	-bibtex sidsmain
	-makeindex sidsmain
	xelatex -shell-escape sidsmain.tex
	xelatex -shell-escape sidsmain.tex
	$(MAKE) check-generated

# Use this when the R session or generated cache may be inconsistent.
rebuild: deepclean build
