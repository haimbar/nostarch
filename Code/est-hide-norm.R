do1est <- function(n, mu) {
    x <- rnorm(n, mean = mu, sd = 1)              # generate data
    est <-  c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x)))
    return(est)                                   # return estimates
}

do1rep <- function(n, mu) {
    est <- do1est(n, mu)
    return((est - mu)^2)                          # return squared error
}


do1est(50, mu)
do1rep(50, mu)


nrep <- 1000                                  # number of replicates
n <- 20                                       # sample size
sim <- replicate(nrep, do1rep(n, mu))         # run the race
rowMeans(sim)                                 # summarize the means


## Figure: compare estimates from several hide-and-seek games
do1est_game <- function(n, mu, datagen) {
    x <- datagen(n, mu)
    c("Mean" = mean(x),
      "Median" = median(x),
      "Midrange" = mean(range(x)))
}

make_estimates <- function(datagen) {
    estimates <- t(replicate(nrep, do1est_game(n, mu, datagen)))
    estimates - mu
}

plot_estimates <- function(est_sim, main) {
    cols <- c("skyblue3", "seagreen3", "salmon")
    ylim <- quantile(est_sim, c(0.02, 0.98))
    plot(NA, xlim = c(0.5, 3.5), ylim = ylim, xaxt = "n",
         xlab = "", ylab = "estimate - truth", main = main)
    abline(h = 0, lwd = 2, lty = 2)
    for (j in seq_len(ncol(est_sim))) {
        vals <- est_sim[, j]
        vals <- vals[ylim[1] <= vals & vals <= ylim[2]]
        d <- density(vals)
        d$y <- d$y / max(d$y) * 0.35
        polygon(c(j - d$y, rev(j + d$y)),
                c(d$x, rev(d$x)),
                col = cols[j], border = "gray40")
        points(rep(j, 80), sample(vals, 80),
               pch = 16, cex = 0.22, col = rgb(0, 0, 0, 0.25))
    }
    axis(1, at = 1:3, labels = colnames(est_sim))
}

set.seed(2026)
est_norm <- make_estimates(function(n, mu) rnorm(n, mean = mu, sd = 1))
est_cauchy <- make_estimates(function(n, mu) mu + rt(n, df = 1))
est_unif <- make_estimates(function(n, mu) runif(n, mu - 10, mu + 10))

pdf("images/chapter_6/estimator_violin_by_game.pdf", width = 7, height = 6)
par(mfrow = c(3, 1), mar = c(2.4, 4, 2, 1))
plot_estimates(est_norm, "Normal data")
plot_estimates(est_cauchy, "Cauchy data")
plot_estimates(est_unif, "Uniform data")
dev.off()
