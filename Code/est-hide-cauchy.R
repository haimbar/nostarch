do1rep <- function(n, mu, datagen) {
    x <- datagen(n, mu)                           # generate data
    est <-  c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x)))
    return((est - mu)^2)                          # return squared error
}


do1rep(50, mu, function(n, mu) mu + rt(n, df = 1))


nrep <- 1000                                   # number of replicates
n <- 20                                        # sample size
sim.t <- replicate(nrep,
                   do1rep(n, mu, function(n, mu) mu + rt(n, df = 1)))
rowMeans(sim.t)                                # summarize the means
