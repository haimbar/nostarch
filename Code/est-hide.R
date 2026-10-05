#label===setup
set.seed(123)
mu <- runif(1, min = 10, max = 30)  # Nature hides mu
n <- 20                             # sample size
x <- rnorm(n, mean = mu, sd = 1)    # clues are in the sample
summary(x)
#===end

## point estimates
#label===estimates
estimates <- c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x)))
#===end



## squared error
#label===error
err <- (estimates - mu)^2
#===end

