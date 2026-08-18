## Generate data from a normal distribution
#label===demo1pair
set.seed(20241125)
x1 <- rnorm(30)           # Group 1
x2 <- rnorm(30)           # Group 2, no difference in means

## test based on normal assumption
t.test(x1, x2)
## rank-based; distribution free (nonparametric) test
wilcox.test(x1, x2)
#===end


### design an experiment
#label===do1rep
do1rep <- function(n, datagen, delta = 0) {
    x1 <- datagen(n)
    x2 <- datagen(n) + delta
    p1 <- t.test(x1, x2, alternative = "less")$p.value
    p2 <- wilcox.test(x1, x2, alternative = "less")$p.value
    ## p3 <- myPermTest(x1, x2)
    c(t = p1, wilcox = p2) ##, perm = p3)
}

demo_rep <- do1rep(30, rnorm, 0)
demo_rep
#===end


### check empirical rejection rate
#label===checkrejrate
n <- 30
nrep <- 1000
sim <- replicate(nrep, do1rep(n, rnorm, 0))
rowMeans(sim < .05)
#===end


## put them into a function for ease of accessing
#label===emprejratefun
empRejRate <- function(nrep, n, datagen, delta = 0, alpha = .05) {
    sim <- replicate(nrep, do1rep(n, datagen, delta))
    rowMeans(sim < alpha)
}
#===end


## normal population
#label===comparepops
size_normal <- empRejRate(nrep, n, rnorm, 0)
power_normal <- empRejRate(nrep, n, rnorm, 0.5)
size_normal
power_normal

## Cauchy population
size_cauchy <- empRejRate(nrep, n, rcauchy, 0)
power_cauchy <- empRejRate(nrep, n, rcauchy, 0.5)
size_cauchy
power_cauchy
#===end


### power curve
#label===deltaseq
delta <- seq(0, 1, by = .2)
#===end

pdf("images/chapter_5/hypo-power-normal.pdf", width = 5, height = 4)
#label===power-normal
## normal distribution
rejrate <- sapply(delta, function(x) empRejRate(nrep, n, rnorm, x))
plot(delta, rejrate["t", ], type = "l",
     ylab = "empirical rejection rate", ylim = c(0, 1))
lines(delta, rejrate["wilcox", ], lty = 2, col = "blue")
abline(.05, 0)
legend("topleft", legend = c("t-test", "Wilcoxon"),
       lty = c(1, 2), col = c("black", "blue"), bty = "n")
#===end
dev.off()

pdf("images/chapter_5/hypo-power-cauchy.pdf", width = 5, height = 4)
#label===power-cauchy
## Cauchy distribution
rejrate <- sapply(delta, function(x) empRejRate(nrep, n, rcauchy, x))
plot(delta, rejrate["t", ], type = "l",
     ylab = "empirical rejection rate", ylim = c(0, 1))
lines(delta, rejrate["wilcox", ], lty = 2, col = "blue")
abline(.05, 0)
legend("topleft", legend = c("t-test", "Wilcoxon"),
       lty = c(1, 2), col = c("black", "blue"), bty = "n")
#===end
dev.off()
