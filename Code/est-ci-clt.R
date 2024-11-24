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
