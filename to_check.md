## Per chapter tasks

### Content and Structure
- Good introduction and summary (does opener state what the reader will learn?)
- Good flow, section organization
- Chapter learning objectives — clear statement of what reader will learn in opener
- Add problems (range from straightforward to challenging; all solvable with chapter content)

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

### Code and Plots
- R snippets — clean, consistent style
- Plots — resolution, aesthetics, work in B&W as well as in color
- Code line length (see NoStarch Compliance above)

### Math and References
- Math notation consistency — hat notation for estimates, Greek letters, subscripts consistent across chapters
- Cross-references — each \ref{} resolves; no dangling labels
- Bibliography — each \cite{} has a matching entry in book.bib; no orphan references

### Open Issues (resolve before submission)
- Resolve all inline comments: \jy{}, \why{}, \hb{}, \hyw{}, \hyb{} markers
  (14 open as of 2026-05-30: 5 in llnclt, 4 in Rintro, 1 in regcorr, 1 in datacollect, 3 commented-out in Rintro)

### Compilation Errors
- Check/fix for any Latex Compilation errors, and warnings
- Check for any errors resulting from failure to execute R code via runcode

## Overall Assessment of the Book (run on request only)
-  Check for consistency in language, style, level of detail, and clarity, and see if the flow between chapters is good.
- Check chapter and section titles to make sure that they are clear, informative, and in a logical order.
