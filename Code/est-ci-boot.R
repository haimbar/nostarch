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
sim_50 <- replicate(nrep, do1rep(50))
## point estimator
mean(sim_50[1,])
## empirical coverage of percentile BI
mean(sim_50[2,] < target & target < sim_50[3,])


## let's try a smaller sample size
sim_20 <- replicate(nrep, do1rep(20))
mean(sim_20[2, ] < target & sim_20[3,] > target)
