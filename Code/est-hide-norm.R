do1rep <- function(n, mu) {
    x <- rnorm(n, mean = mu, sd = 1)              # generate data
    est <-  c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x)))
    return((est - mu)^2)                          # return squared error
}


do1rep(50, mu)


nrep <- 1000                                  # number of replicates
n <- 20                                       # sample size
sim <- replicate(nrep, do1rep(n, mu))         # run the race
rowMeans(sim)                                 # summarize the means




