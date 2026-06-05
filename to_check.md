## Per chapter tasks

### Content and Structure
- Good introduction and summary (does opener state what the reader will learn?)
- Good flow, section organization
- Chapter learning objectives — clear statement of what reader will learn in opener
- Add problems (range from straightforward to challenging; all solvable with chapter content); use consistent exercise environment, placed within sections

### Language and Style
- Grammar, typos
- Latin abbreviations — replace e.g./i.e./etc. with "for example" / "that is" / "and so on"
- NSP word list compliance: "data is" (singular), "dataset" (one word), "internet" (lowercase),
  "command line" (noun) vs "command-line" (adjective), "indexes" (book/database) vs "indices" (math/computing)
- Consistent terminology — "data frame", "variable", "function", "vector" spelled and styled the same throughout

### NoStarch Compliance
- Check NoStarch compliance (see nsp_style_guide.md memory file for full reference)
- Figure/listing numbering — NSP scheme: Figure N-N, Listing N-N (chapter-dash-number, consecutive within chapter)
- Every figure/table/listing referenced in text *before* it appears
- Figure captions — period only if full sentence; no period for noun phrases
- Code line length — standard 78 chars; wide listings 95 chars max
- LaTeX source lines — wrap at 80 chars
- Inline code: use `\inlnR{}` consistently; avoid line breaks inside function or variable names

### Code and Plots
- R snippets — clean, consistent style: space before/after `=` and after commas; full-line comments use `##`, inline use `#`
- Chunk labels — use descriptive names, not line numbers; always use `\showChunk{R}{file}{chunk-name}` rather than `\showCode{R}{file}[start][end]`; add `#label===name` / `#===end` markers in the R file to define the chunk
- Plots — resolution, aesthetics, work in B&W as well as in color; span full text width; golden ratio for `asp` unless symmetry required (e.g., Q-Q plots); label and point sizes legible after rescaling; minimize white space margins
- Code line length (see NoStarch Compliance above)

### Math and References
- Math notation consistency — hat notation for estimates, Greek letters, subscripts consistent across chapters
  - **Adopted convention**: sample mean is $\bar{x}$ (not $\overline{x}$) throughout
  - **Adopted convention**: variance operator is $\operatorname{Var}$ (not $Var$); similarly use $\operatorname{SD}$, $\operatorname{Cov}$, $\operatorname{E}$ for other operators
- Cross-references — each \ref{} resolves; no dangling labels; use consistent label prefixes:
  - **Adopted convention**: figures use `fig:chN:name` (e.g., `fig:ch2:scatter`, `fig:ch3:bayes-rule`)
  - Chapters: `ch:name` — Sections: `sec:name` — Equations: `eq:name` — Tables: `tab:name` — Listings: `lst:name`
  - Ch1 already follows `fig:ch1:name`; Ch2–Ch4 updated to match
- Index terms — key terms introduced in the chapter are indexed; capitalization consistent (avoid duplicates from mixed case)
- Bibliography — each \cite{} has a matching entry in book.bib; no orphan references

### Open Issues (resolve before submission)
- Resolve all inline comments: \jy{}, \why{}, \hb{}, \hyw{}, \hyb{} markers
  (14 open as of 2026-05-30: 5 in llnclt, 4 in Rintro, 1 in regcorr, 1 in datacollect, 3 commented-out in Rintro)

### Compilation Errors
- Check/fix for any Latex Compilation errors, and warnings
- Check for any errors resulting from failure to execute R code via runcode

## Overall Assessment of the Book (run on request only)
- Check for consistency in language, style, level of detail, and clarity, and see if the flow between chapters is good.
- Check chapter and section titles to make sure that they are clear, informative, and in a logical order.
- Prerequisite flow — no concept used before it is introduced; chapters build on each other without gaps.
- Pedagogical balance — comparable depth, length, and example count across chapters; no chapter feels rushed or padded.
- Problems difficulty gradient — Problems sections collectively span easy to challenging; later chapters may build on earlier material.
- Notation and terminology consistency — same symbols (hat notation, Greek letters, variable names) and terms used the same way in every chapter.
- Figure and code style uniformity — consistent R coding conventions (assignment operator, style), plot aesthetics, and figure caption format book-wide.
- Index completeness — key terms introduced in each chapter are indexed; no orphan index entries pointing to removed text.
- Forward/backward reference coherence — cross-chapter \ref{} pointers form a sensible reading path; no circular or misleading references.
