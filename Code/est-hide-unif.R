sim.u <- replicate(nrep,
                   do1rep(n, mu,
                          function(n, mu) runif(n, mu - 10, mu + 10)))
rowMeans(sim.u)
