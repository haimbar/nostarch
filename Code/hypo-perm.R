### get started
set.seed(20210628)
delta <- 0
n1 <- n2 <- n <- 30
x1 <- rnorm(n1)
x2 <- rnorm(n2) + delta
## permutation test
xd <- mean(x2) - mean(x1)               # a reasonable test statistic



xpooled <- c(x1, x2)
xperm <- sample(xpooled, size = length(xpooled), replace = FALSE)
xdp <-  mean(xperm[n1 + 1:n2]) - mean(xperm[1:n1])


## How many possible permutations are there?
## If small, we can do exact test (like for the lady tasting tea)
choose(n1 + n2, n1)

## put in a function
myPermTest <- function(x1, x2, nperm = 1000) {
    n1 <- length(x1)
    n2 <- length(x2)
    stat <- mean(x2) - mean(x1)
    xpl <- c(x1, x2)
    stat.sim <- replicate(nperm, {
        xperm <- sample(xpl, size = length(xpl), replace = FALSE)
        xd <- mean(xperm[n1 + 1:n2]) - mean(xperm[1:n1])
    })
    p.value <- mean(c(stat.sim, stat) >= stat)  # one-sided test
    p.value
}

delta <- 10
x1 <- rgamma(n, shape = 2, scale = 2)
x2 <- rgamma(n, shape = 2, scale = 2) + delta
myPermTest(x1, x2)

## permutation test implemented in R package coin
