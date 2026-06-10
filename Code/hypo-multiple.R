#label===do1screen
do1screen <- function(m = 20, n = 30) {
  pvals <- numeric(m)
  for (j in 1:m) {
    placebo <- rnorm(n, mean = 0, sd = 1)
    drug    <- rnorm(n, mean = 0, sd = 1)  # no effect at all
    pvals[j] <- t.test(drug, placebo)$p.value
  }
  pvals
}

set.seed(1)
do1screen()
#===end

#label===pvalues
B <- 2000
all_p <- replicate(B, do1screen(), simplify = TRUE)
dim(all_p)  # 20 x 2000 matrix: 40,000 p-values in total
#===end

pdf("images/chapter_5/hypo-pvalues.pdf", width = 5, height = 4)
#label===hist
hist(all_p, breaks = 30, col = "skyblue",
     main = "Histogram of 40,000 p-values from Pure Noise",
     xlab = "p-value")
#===end
dev.off()

pdf("images/chapter_5/hypo-sigcount.pdf", width = 5, height = 4)
#label===sigcount
sig_count <- apply(all_p < 0.05, 2, sum)

hist(sig_count, breaks = seq(-0.5, max(sig_count) + 0.5, by = 1),
     col = "orange",
     main = "Number of 'Significant' Drugs (p < 0.05)\nUnder Pure Noise",
     xlab = "Count per Experiment")
#===end
dev.off()

#label===meansig
mean(sig_count >= 1)
#===end


pdf("images/chapter_5/hypo-minp.pdf", width = 5, height = 4)
#label===minp
min_p <- apply(all_p, 2, min)
hist(min_p, breaks = 30, col = "lightgreen",
     main = "Smallest p-value from Each Experiment",
     xlab = "Minimum p-value")
#===end
dev.off()


##


#label===do1screen_alt
do1screen_alt <- function(m = 20, n = 30, effect = 0.5) {
  pvals <- numeric(m)
  true_effect <- sample(1:m, 4)
  for (j in 1:m) {
    placebo <- rnorm(n, mean = 0, sd = 1)
    if (j %in% true_effect) {
      drug <- rnorm(n, mean = effect, sd = 1)
    } else {
      drug <- rnorm(n, mean = 0, sd = 1)
    }
    pvals[j] <- t.test(drug, placebo)$p.value
  }
  list(p = pvals, truth = true_effect)
}

set.seed(2)
#===end


##


#label===altresults
B <- 1000
results <- replicate(B, do1screen_alt(), simplify = FALSE)

TP_unc <- FP_unc <- TP_bonf <- FP_bonf <- numeric(B)

for (b in 1:B) {
  p <- results[[b]]$p
  truth <- results[[b]]$truth

  sig_unc <- which(p < 0.05)
  TP_unc[b] <- sum(sig_unc %in% truth)
  FP_unc[b] <- sum(!(sig_unc %in% truth))

  sig_bonf <- which(p < 0.05/20)
  TP_bonf[b] <- sum(sig_bonf %in% truth)
  FP_bonf[b] <- sum(!(sig_bonf %in% truth))
}

c("TP_unc"  = mean(TP_unc),
  "FP_unc"  = mean(FP_unc),
  "TP_bonf" = mean(TP_bonf),
  "FP_bonf" = mean(FP_bonf))
#===end
