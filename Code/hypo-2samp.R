# Generate data from a normal distribution
set.seed(20241125)
x1 <- rnorm(30)           # Group 1
x2 <- rnorm(30)           # Group 2, no difference in means

## test based on normal assumption
t.test(x1, x2)
## rank-based; distribution free (nonparametric) test
wilcox.test(x1, x2)     


### design an experiment
do1rep <- function(n, datagen, delta = 0) {
    x1 <- datagen(n)
    x2 <- datagen(n) + delta
    p1 <- t.test(x1, x2, alternative = "less")$p.value
    p2 <- wilcox.test(x1, x2, alternative = "less")$p.value
    ## p3 <- myPermTest(x1, x2)
    c(t = p1, wilcox=p2) ##, perm = p3)
}

do1rep(30, rnorm, 0)


### check empirical rejection rate
nrep <- 1000
sim <- replicate(nrep, do1rep(n, rnorm, 0))
rowMeans(sim < .05)


## put them into a function for ease of accessing
empRejRate <- function(nrep, n, datagen, delta = 0, alpha = .05) {
    sim <- replicate(nrep, do1rep(n, datagen, delta))
    rowMeans(sim < alpha)
}


## normal population
empRejRate(nrep, n, rnorm, 0)
empRejRate(nrep, n, rnorm, 0.5)

## Cauchy population
empRejRate(nrep, n, rcauchy, 0)
empRejRate(nrep, n, rcauchy, 0.5)


### power curve
delta <- seq(0, 1, by = .2)

## normal distribuion
rejrate <- sapply(delta, function(x) empRejRate(nrep, n, rnorm, x))
plot(delta, rejrate["t", ], type = "l",
     ylab = "emporical rejection rate", ylim = c(0, 1))
lines(delta, rejrate["wilcox", ], lty = 2, col = "blue")
abline(.05, 0)

## Cauchy distribuion
rejrate <- sapply(delta, function(x) empRejRate(nrep, n, rcauchy, x))
plot(delta, rejrate["t", ], type = "l",
     ylab = "emporical rejection rate", ylim = c(0, 1))
lines(delta, rejrate["wilcox", ], lty = 2, col = "blue")
abline(.05, 0)
