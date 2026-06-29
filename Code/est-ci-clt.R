ciclt <- function(x, alpha = .05) {
    xbar <- mean(x)
    z <- qnorm(1 - alpha / 2)
    dd <- z * sd(x) / sqrt(length(x))
    c(xbar - dd, xbar + dd)
}


set.seed(626)
mu <- runif(1, 1, 10)                        # unknown true mu
x <- rgamma(50, shape = mu/2, scale = 2)
ci <- ciclt(x)


do1rep <- function(n, mu, alpha = .05) {
    x <- rgamma(n, shape = mu / 2, scale = 2)
    ciclt(x, alpha)
}

nrep <- 1000
sim50 <- replicate(nrep, do1rep(50, mu))
mean(sim50[1, ] < mu & sim50[2,] > mu)


## smaller sample size
sim20 <- replicate(nrep, do1rep(20, mu))
mean(sim20[1, ] < mu & sim20[2,] > mu)


## Figure: show 50 confidence intervals for two sample sizes
make_ci_show <- function(n) {
    ci_show <- t(replicate(50, do1rep(n, mu)))
    covered <- ci_show[, 1] < mu & mu < ci_show[, 2]
    ord <- order(rowMeans(ci_show))
    list(ci = ci_show[ord, ], covered = covered[ord])
}

plot_ci_show <- function(obj, main, xlim) {
    ci_show <- obj$ci
    covered <- obj$covered
    plot(NA, xlim = xlim, ylim = c(1, nrow(ci_show)),
         xlab = "", ylab = "simulated interval", main = main)
    abline(v = mu, lwd = 2, lty = 2)
    for (i in seq_len(nrow(ci_show))) {
        col <- if (covered[i]) "gray45" else "firebrick3"
        segments(ci_show[i, 1], i, ci_show[i, 2], i,
                 lwd = 2, col = col)
    }
}

set.seed(2027)
ci_show50 <- make_ci_show(50)
ci_show20 <- make_ci_show(20)
xlim <- range(ci_show50$ci, ci_show20$ci, mu)

pdf("images/chapter_6/confidence_intervals_by_sample_size.pdf",
    width = 7, height = 6)
par(mfrow = c(2, 1), mar = c(3, 4, 2, 1))
plot_ci_show(ci_show50, "n = 50", xlim)
legend("bottomright",
       legend = c("covered truth", "missed truth", "true mu"),
       col = c("gray45", "firebrick3", "black"),
       lty = c(1, 1, 2), lwd = c(2, 2, 2), bty = "n")
plot_ci_show(ci_show20, "n = 20", xlim)
dev.off()
