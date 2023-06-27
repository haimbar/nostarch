set.seed(123)   # could vary the seed to prevent cheating
mu <- runif(1, min = 10, max = 30)  # Nature hides mu
n <- 20                             # sample size
x <- rnorm(n, mean = mu, sd = 1)    # clues are in the sample
summary(x)

## point estimates
(estimates <- c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x))))



## squared error
err <- (estimates - mu)^2




