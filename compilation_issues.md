# Compilation Issues Log
Last updated: 2026-05-30 after `make build` (full rebuild with R server).
Book compiled successfully (165 pages, no fatal errors).

---

## FIXED

| File | Issue |
|------|-------|
| `chapters/datacollect.tex:50` | Duplicate label `eq:weightheight` — renamed to `eq:weightheight-stochastic` |
| `chapters/datacollect.tex:134` | Duplicate label `representative` — renamed to `representative-size` |

---

## OPEN: Estimation chapter — empty generated output files

After `make build`, 12 generated files in the estimation chapter are **zero bytes** (blank
output in PDF). Two distinct root causes:

### Cause 1 — Missing R file: `Code/est-mle-binom.R` does not exist

`chapters/estimation.tex:271` calls `\runR{Code/est-mle-binom.R}{mle-binom}`, but the
file is absent from the repository. The object `phat` (used on line 294 via
`\inlnR{```cat(phat[1])```}[phat]`) is never defined, so `generated/phat.tex` is always
empty.

**Fix:** Create `Code/est-mle-binom.R` with code that computes `phat` (the MLE for a
binomial proportion — context: basketball player, 16/20 free throws, so `phat <- 16/20`).

### Cause 2 — R timeout: `Code/est-ci-boot.R` times out during build

`\runR{Code/est-ci-boot.R}{ci-boot}[cache]` (estimation.tex:435) times out because the
`nrep=1000` bootstrap loops are too slow for the R server's timeout threshold. The objects
`medBoot`, `medCI`, `sim50`, `sim20`, `target` are not available when the subsequent
`\inlnR` commands execute. Confirmed in `Rdebug.txt`:
```
source("Code/est-ci-boot.R")
  TIMED OUT 2026/30/05/25/26 09:30:00 ------
```

**Fix options:**
- Reduce `nrep` in `est-ci-boot.R` (e.g., 500 instead of 1000) to stay within the timeout
- Or increase the talk2stat server timeout in `R.config`

Affected generated files (all zero bytes after build):

| Generated file | `\inlnR` expression | estimation.tex line |
|---------------|---------------------|---------------------|
| `generated/phat.tex` | `cat(phat[1])` | 294 |
| `generated/estci1.tex` | `cat(ci[1])` | 367 |
| `generated/estci2.tex` | `cat(ci[2])` | 367 |
| `generated/estsim50.tex` | `cat(mean(sim50[...]))` | 376 |
| `generated/estsim20.tex` | `cat(mean(sim20[...]))` | 383 |
| `generated/estmedboot.tex` | `cat(medBoot[["t0"]])` | 445 |
| `generated/estmedci1.tex` | `cat(medCI[1])` | 447 |
| `generated/estmedci2.tex` | `cat(medCI[2])` | 447 |
| `generated/esttarget.tex` | `cat(target)` | 448 |
| `generated/esttarget2.tex` | `cat(target)` | 470 |
| `generated/estmeansim50.tex` | `cat(mean(sim50[1,]))` | 469 |
| `generated/estmeansim50ci.tex` | `cat(mean(sim50[2,]...))` | 475 |

**Note:** `estci1.tex` and `estci2.tex` (from `est-ci-clt.R`, which did not time out) are
also zero bytes. This is likely a session-ordering issue: `est-ci-clt.R` succeeds and
produces `ci`, but a timeout in a later script may cause the R session to reset, losing
the earlier variables before the `\inlnR` commands run.

---

## OVERFULL HBOXES — Very wide (>50pt)

All 21 of these come from `\showChunk` code-listing blocks sitting inside a paragraph
(no blank line separating the preceding text from the command). They are almost certainly
cosmetic — code blocks render in their own verbatim frame and do not visually overflow.
Verify in the PDF; no easy fix without reconfiguring the runcode listing width.

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

Values under ~5pt are usually invisible in print. Values above ~20pt are worth
checking in the PDF.

| File | Lines | Width | Priority |
|------|-------|-------|----------|
| `chapters/regcorr.tex` | 212–216 | 40pt | Medium |
| `chapters/front_matter.tex` | 107 | 34pt | Medium |
| `chapters/Rintro.tex` | 27–39 | 27pt | Medium |
| `chapters/Rintro.tex` | 586–593 | 18pt | Low |
| `chapters/llnclt.tex` | 13–31 | 16pt | Low |
| `chapters/regcorr.tex` | 10–11 | 13pt | Low |
| `chapters/regcorr.tex` | 134–141 | 11pt | Low |
| `chapters/probability.tex` | 1013–1018 | 11pt | Low |
| `chapters/EDA.tex` | 521–530 | 10pt | Low |
| `chapters/Rintro.tex` | 106–110 | 9pt | Low |
| `chapters/datacollect.tex` | 29–35 | 9pt | Low |
| `chapters/llnclt.tex` | 13–31 | 9pt | Low |
| `chapters/datacollect.tex` | 380–385 | 7pt | Low |
| `chapters/estimation.tex` | 4–16 | 7pt | Low |
| `chapters/datacollect.tex` | 206–211 | 7pt | Low |
| `chapters/datacollect.tex` | 253–261 | 7pt | Low |
| `chapters/estimation.tex` | 280–283 | 6pt | Low |
| `chapters/front_matter.tex` | 137–150 | 7pt | Low |
| *(~20 more under 5pt — negligible)* | | | Negligible |

---

## OTHER WARNINGS

| Warning | Details |
|---------|---------|
| `Package soulutf8 Warning: This package is obsolete` | Minor — loaded by a dependency; harmless |
| `LaTeX Font Warning: Some font shapes were not available` | Font fallback — check special characters render correctly in PDF |
| `Package hyperref Warning: Token not allowed in a PDF string` | `chapters/nyccrashes.tex` line 1 — chapter title contains a macro. Affects PDF bookmark string only, not body text |
