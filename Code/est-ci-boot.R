myboot <- function(x, statistic, R = 1000) {
    t0 <- statistic(x)   # observed statistic
    mb <- rep(0, R)      # placeholder assuming a scalar statistic
    n <- length(x)
    for (i in 1:R) {
        xb <- x[sample(1:n, size = n, replace = TRUE)]
        mb[i] <- statistic(xb)
    }
    list(t0 = t0, t = mb)
}


### estimating the population median with sample median
target <- qgamma(0.5, shape = 2, scale = 2)
set.seed(2021)
n <- 50
x <- rgamma(n, shape = 2, scale = 2)
medBoot <- myboot(x, median)
medCI <- quantile(medBoot$t, c(.025, .975))


## is the bootstrap CI matching its level?
do1rep <- function(n) {
    x <- rgamma(n, shape = 2, scale = 2)
    medBoot <- myboot(x, median, R = 1000)
    c(medBoot$t0, quantile(medBoot$t, c(.025, .975)))
}


nrep <- 1000
sim50 <- replicate(nrep, do1rep(50))
## point estimator
mean(sim50[1,])
## empirical coverage of percentile BI
mean(sim50[2,] < target & target < sim50[3,])


## let's try a smaller sample size
sim20 <- replicate(nrep, do1rep(20))
mean(sim20[2, ] < target & sim20[3,] > target)


## Figure: show 50 bootstrap confidence intervals for two sample sizes
make_boot_show <- function(n) {
    boot_show <- t(replicate(50, do1rep(n)))
    covered <- boot_show[, 2] < target & target < boot_show[, 3]
    ord <- order(boot_show[, 1])
    list(ci = boot_show[ord, 2:3], covered = covered[ord])
}

plot_boot_show <- function(obj, main, xlim) {
    ci_show <- obj$ci
    covered <- obj$covered
    plot(NA, xlim = xlim, ylim = c(1, nrow(ci_show)),
         xlab = "", ylab = "simulated interval", main = main)
    abline(v = target, lwd = 2, lty = 2)
    for (i in seq_len(nrow(ci_show))) {
        col <- if (covered[i]) "gray45" else "firebrick3"
        segments(ci_show[i, 1], i, ci_show[i, 2], i,
                 lwd = 2, col = col)
    }
}

set.seed(2028)
boot_show50 <- make_boot_show(50)
boot_show20 <- make_boot_show(20)
xlim <- range(boot_show50$ci, boot_show20$ci, target)

pdf("images/chapter_6/bootstrap_intervals_by_sample_size.pdf",
    width = 7, height = 6)
par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
plot_boot_show(boot_show50, "n = 50", xlim)
legend("bottomright",
       legend = c("covered truth", "missed truth", "true median"),
       col = c("gray45", "firebrick3", "black"),
       lty = c(1, 1, 2), lwd = c(2, 2, 2), bty = "n")
plot_boot_show(boot_show20, "n = 20", xlim)
dev.off()
