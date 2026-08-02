#label===HypoPermSetup
set.seed(20210628)
delta <- 0
n1 <- n2 <- 30
x1 <- rnorm(n1)
x2 <- rnorm(n2) + delta
xd <- mean(x2) - mean(x1)               
#===end

#label===HypoPermOnePerm
xpooled <- c(x1, x2)
xperm <- sample(xpooled, size = length(xpooled), replace = FALSE)
x1p <- xperm[1:n1]
x2p <- xperm[n1 + 1:n2]
xdp <- mean(x2p) - mean(x1p)
#===end

## How many possible permutations are there?
## If small, we can do exact test (like for the lady tasting tea)

#label===HypoPermFullCount
choose(n1 + n2, n1)
#===end

## put in a function
#label===HypoPermMyPermTest
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
#===end

#label===HypoPermNullDemo
p_null <- myPermTest(x1, x2)
p_null
#===end


#label===HypoPermDemo
delta <- 10
x1 <- rnorm(n1)
x2 <- rnorm(n2) + delta
p_demo <- myPermTest(x1, x2)
p_demo
#===end

## permutation test implemented in R package coin
