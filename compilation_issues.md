# Compilation Issues Log
Generated: 2026-05-30 after `xelatex -shell-escape -interaction=nonstopmode sidsmain.tex`
Book compiled successfully (165 pages, no fatal errors).

---

## FIXED (applied this session)

| File | Issue |
|------|-------|
| `chapters/datacollect.tex:50` | Duplicate label `eq:weightheight` — renamed second equation label to `eq:weightheight-stochastic` |
| `chapters/datacollect.tex:134` | Duplicate label `representative` — renamed subsection label to `representative-size` |

---

## R RUNTIME ERRORS — Requires full rebuild with R server

The following generated output files contain R error text because the cached results are
stale or the R code failed during a previous build. These errors appear inline in the PDF.
Run `make build` (with the R server) to regenerate.

| Generated file | R error | Source R file | Chapter |
|---------------|---------|--------------|---------|
| `generated/estci1.tex` | `Error: object 'ci' not found` | `Code/est-ci-clt.R` | estimation |
| `generated/estci2.tex` | `Error: object 'ci' not found` | `Code/est-ci-clt.R` | estimation |
| `generated/estmeansim50.tex` | `Error: object 'sim50' not found` | `Code/est-ci-clt.R` | estimation |
| `generated/estmeansim50ci.tex` | `Error: object 'sim50' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/estsim20.tex` | `Error: object 'sim20' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/estsim50.tex` | `Error: object 'sim50' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/esttarget.tex` | `Error: object 'target' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/esttarget2.tex` | `Error: object 'target' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/estmedboot.tex` | `Error: object 'medBoot' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/estmedci1.tex` | `Error: object 'medCI' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/estmedci2.tex` | `Error: object 'medCI' not found` | `Code/est-ci-boot.R` | estimation |
| `generated/phat.tex` | `Error: object 'phat' not found` | (estimation chapter) | estimation |

Root cause: `\runR{Code/est-ci-clt.R}{ci-clt}[cache]` and `\runR{Code/est-ci-boot.R}{ci-boot}[cache]`
in `chapters/estimation.tex` (lines ~358, ~435) ran with `[cache]` flag but objects were
not available in the R session. Run `make build` to regenerate.

---

## MULTIPLY-DEFINED LABELS (now fixed — listed for reference)

Both were in `chapters/datacollect.tex`. See FIXED section above.

---

## OVERFULL HBOXES — Very wide (>50pt)

These are almost certainly from `\showChunk` code-listing boxes being wider than the text
column. They are likely cosmetic (code blocks render correctly in their own verbatim frame)
but should be verified in the PDF. No easy LaTeX fix without reconfiguring the runcode
package listing width.

| File | Lines | Width |
|------|-------|-------|
| `chapters/Rintro.tex` | 225–231 | 462pt |
| `chapters/Rintro.tex` | 374–378 | 438pt |
| `chapters/Rintro.tex` | 385–388 | 433pt |
| `chapters/Rintro.tex` | 242–248 | 411pt |
| `chapters/Rintro.tex` | 261–266 | 405pt |
| `chapters/Rintro.tex` | 206–210 | 352pt |
| `chapters/Rintro.tex` | 347–351 | 326pt |
| `chapters/Rintro.tex` | 248–257 | 287pt |
| `chapters/Rintro.tex` | 336–340 | 254pt |
| `chapters/Rintro.tex` | 819–821 | 238pt |
| `chapters/Rintro.tex` | 829–835 | 237pt |
| `chapters/Rintro.tex` | 165–172 | 212pt |
| `chapters/Rintro.tex` | 191–201 | 208pt |
| `chapters/datacollect.tex` | 75–92 | 206pt |
| `chapters/Rintro.tex` | 609–620 | 170pt |
| `chapters/hypothesis.tex` | 325–332 | 126pt |
| `chapters/hypothesis.tex` | 349–352 | 118pt |
| `chapters/hypothesis.tex` | 275–277 | 116pt |
| `chapters/Rintro.tex` | 514–523 | 115pt |
| `chapters/hypothesis.tex` | 334–337 | 114pt |
| `chapters/datacollect.tex` | 650–652 | 108pt |

---

## OVERFULL HBOXES — Narrow (<50pt, text reflow candidates)

Minor overflows that may be fixed by rephrasing or hyphenation hints. Values under ~5pt
are usually invisible in print; values above ~20pt are worth examining in the PDF.

| File | Lines | Width | Priority |
|------|-------|-------|----------|
| `chapters/front_matter.tex` | 106 | 34pt | Medium |
| `chapters/regcorr.tex` | 212–216 | 40pt | Medium |
| `chapters/Rintro.tex` | 27–39 | 27pt | Medium |
| `chapters/regcorr.tex` | 134–141 | 11pt | Low |
| `chapters/regcorr.tex` | 10–11 | 13pt | Low |
| `chapters/probability.tex` | 1013–1018 | 11pt | Low |
| `chapters/Rintro.tex` | 586–593 | 18pt | Low |
| `chapters/EDA.tex` | 521–530 | 10pt | Low |
| `chapters/Rintro.tex` | 106–110 | 9pt | Low |
| `chapters/datacollect.tex` | 29–35 | 9pt | Low |
| `chapters/datacollect.tex` | 206–211 | 7pt | Low |
| `chapters/datacollect.tex` | 253–261 | 7pt | Low |
| `chapters/datacollect.tex` | 380–385 | 7pt | Low |
| `chapters/estimation.tex` | 4–16 | 7pt | Low |
| `chapters/estimation.tex` | 280–283 | 6pt | Low |
| `chapters/EDA.tex` | 479–489 | 5pt | Low |
| `chapters/Rintro.tex` | 507–512 | 3pt | Low |
| *(and ~20 more under 5pt — negligible)* | | | Negligible |

---

## OTHER WARNINGS

| Warning | Details |
|---------|---------|
| `Package soulutf8 Warning: This package is obsolete` | Minor — loaded by some dependency; harmless |
| `LaTeX Font Warning: Some font shapes were not available, defaults substituted` | Font fallback — check if special characters render correctly in PDF |
| `Package hyperref Warning: Token not allowed in a PDF string` | In `chapters/nyccrashes.tex` line 1 — the chapter title contains `\kernel@ifnextchar` (likely from a macro). Affects PDF bookmark string only, not body text. |
