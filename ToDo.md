### Environment

+ Example: needs an QED to indicate the end.

### Estimation
+ MSE/Bias definition need to be explained in words
+ Use histogram to show the efficiency comparison of estimators
+ Use interval plots to show there coverages
+ Extra space in \inlR? Should be solved by runlatex
+ Coverage probability needs to be explained in words
+ Add a summary


## Conventions

- Code width - change font type so that we can show 80 characters per line
- Use consistent code style
  + space before and after each = sign, and after commas
  + Comments in R – if the whole line, use ##. Inline use #
  + other things?
- Label prefix conventions. For example: ch: eqn: tab: fig:
- Homework exercises - within sections.
  Choose a format for exercise environment.
- Latex source - use 80 characters per line
- Create figures with width that can span the text width, so that there
   is not that much white space -  use the golden ratio for the asp, unless symmetry 
  is required (like Q-Q plots).
  Use label sizes and point sizes that don't look too small after rescaling.
- Use labels to identify chunks, instead of line numbers
- Named \inlnR
- Add index terms
- Compile based on change time of files.
- Ask Jill if we can avoid breaking a function or variable at the
  end of the line.

### Chapter 9 (NYC crashes) — review checklist (2026-07-22)

- [x] Compilation: `Makefile`'s `build` target only `mkdir -p`'d
  `images/chapter_1` through `images/chapter_8` — never `chapter_9` — so a
  clean `make deepclean && make build` would fail to create `images/chapter_9`
  and every R `pdf()` call in `Code/nyc_crashes.R` would error. Fixed: loop
  now runs `seq 1 9`.
- [x] tmpoverleaf duplication: `make_overleaf.py` now copies
  `tmpoverleaf/sidsmain.pdf` to `sidsmain-overleaf.pdf` in the repo root after
  a successful compile (gitignored).
- [x] Corrupted `generated/nyc-*.tex` caches (13 files held literal R error
  text like `Error: object 'chisq_business_severe' not found`, one — `nyc-sev
  -count.tex` — silently held a wrong `[1] 0` instead of erroring) traced to
  the same missing-`images/chapter_9` bug: `source("Code/nyc_crashes.R")`
  died partway through, so every `\inlnR` after that point cached an error
  string, which `make_overleaf.py` inlined verbatim, producing "Missing $
  inserted" / "\item invalid in math mode" cascades from bare underscores in
  the error text. Fixed by rerunning `make build` end-to-end; all caches now
  hold real values.
- [x] NOTE: `sidsmain.tex` had chapters 1-8 commented out for faster
  chapter-9-only iteration — restored for the full-book build.
- [x] Figure labels use `fig:nyc:*` instead of the adopted `fig:ch9:*` convention
  (nyccrashes.tex:204,253,282,342,371,388,543,571). Fixed: renamed all 8
  labels and their matching `\ref{}` calls to `fig:ch9:*`.
- [x] Numbers: "1 point... 5 points" (nyccrashes.tex:397-398) should be spelled
  out. Fixed: "one point... five points".
- [x] Numbers: "top 10 rows" vs. "the ten rows" inconsistency
  (nyccrashes.tex:403 vs 407). Fixed: both now say "10 rows".
- [x] R comment style: 27 full-line comments in Code/nyc_crashes.R used `#`
  instead of `##` (lines 2-3, 88, 97-98, 126, 242, 253, 270, 373, 474, 481,
  488, 495, 499, 505-506, 515, 530, 539-540, 669, 719, 737-740). Fixed: all
  converted to `##`; `#label===`/`#===end` chunk markers and inline comments
  left untouched; no line exceeds 78 chars.
- [x] `severity_map` plot (Code/nyc_crashes.R:406-419, fig:ch9:locations) had
  no `asp` correction for lat/long, so the NYC map was geographically
  distorted. Fixed: added `asp = 1/cos(mean(df$latitude)*pi/180)`; verified
  visually — NYC's shape (Staten Island separated, correct proportions) now
  renders correctly.
- [ ] Borough color palette (darkorange/steelblue/seagreen/orchid/gray50) may
  not be distinguishable in grayscale print — check B&W rendering.
- [ ] Exercise set (nyccrashes.tex:663-714) skews easy-medium; add a harder
  capstone-style problem.
- [ ] Four "Check-in:" prompts (nyccrashes.tex:86-87,172-174,285-287,412-413)
  are unstyled plain-text paragraphs; decide whether to box them (nostarch.cls
  has a `note` environment) or drop them, matching how estimation.tex left
  similar prompts commented out.
- [ ] `#label===nyc-severity-inference` chunk (Code/nyc_crashes.R:538-554)
  redundantly recomputes objects already computed earlier in the script and
  is never shown via `\showChunk` — looks like dead code.

### Specific chapter comments

- Chapter 2 - add crash data description.
- Chapter 5 - use verbal description and plots to explain notions related
  to estimation. For a biased estimator, can use min/max for the range of
  a uniform distribution. For MSE, show as histograms.
- Chapter 6 - find more survivor bias from the book Dark Data, by David Hand.
  The same book also has examples of several other types of biases which
  we can quote and cite.
  Add a conclusion, what biases to look out for, and how to avoid them.
- Chapter 7 - Jun will write the draft.
- Chapter 8 - maybe use examples from How Not to be Wrong, by Jordan
  Ellenberg (or other sources with nice examples about correlation and
  regression). Maybe this one? https://tylervigen.com/spurious-correlations

