set.seed(123)   # could vary the seed to prevent cheating
mu <- runif(1, min = 10, max = 30)  # Nature hides mu
n <- 20                             # sample size
x <- rnorm(n, mean = mu, sd = 1)    # clues are in the sample
summary(x)

## point estimates
estimates <- c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x)))

## squared error
err <- (estimates - mu)^2
err

x <- rnorm(n, mean = mu, sd = 1)
estimates <- c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x)))
err <- (estimates - mu)^2
err

## function to play the game
onegame <- function(n, mu) {
    x <- rnorm(n, mean = mu, sd = 1)              # generate data
    est <-  c(mu1 = mean(x), mu2 = median(x), mu3 = mean(range(x)))
    return(est)                                   # return squared error
}

nrep <- 1000                                  # number of replicates
n <- 20                                       # sample size
ests <- replicate(nrep, onegame(n, mu))       # run the race
par(mfrow=c(1,3))
hist(ests[1,], main="Estimator 1", xlim=c(15, 17))
abline(v=mu, col="red")
hist(ests[2,], main="Estimator 2", xlim=c(15, 17))
abline(v=mu, col="red")
hist(ests[3,], main="Estimator 3", xlim=c(15, 17))
abline(v=mu, col="red")

## function to calculate squared error
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

# Cauchy population
par(mfrow=c(1,1))
hist(rt(1000, df = 1))

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

# Uniform
hist(runif(1000, mu - 10, mu + 10))

sim.u <- replicate(nrep,
                   do1rep(n, mu,
                          function(n, mu) runif(n, mu - 10, mu + 10)))
rowMeans(sim.u)

# Maximum likelihood estimation
par(mfrow=c(1,2))
# plot the likelihood
L <- function(p) {
    p^3 * (1 - p)^2
}
p <- seq(0, 1, length = 100)
plot(p, L(p), type = "l")
optimize(L, c(0, 1), maximum = TRUE)

# plot the log likelihood
l <- function(p) {
    3 * log(p) + 2 * log(1 - p)
}
p <- seq(0, 1, length = 100)
plot(p, l(p), type = "l")
optimize(L, c(0, 1), maximum = TRUE)

# illustrate the CI
pdf("ciIQ.pdf", width=8, height=5)
set.seed(2024)
n = 10
mu = 100
sigma = 20
samp <- rnorm (n, mu, sigma)
xbar <- mean (samp)
std <- sd (samp)
xs <- seq(40, 180, length =1000)
plot(xs, dnorm(xs, 100, 15), col=2, lwd=3, xlab="IQ", ylab="Density")
abline(v=mu, col=2, lwd=3, lty=2)
text(mu, 0.01, "mu", col=2, pos=4)
abline(v=xbar, col=3, lwd=3, lty=2)
text(xbar, 0.0051, "xbar", col=3, pos=4)
za = qnorm(0.975)
cl = xbar - za * std / sqrt(n)
cu = xbar + za * std / sqrt(n)
abline(v=cl, col=3, lwd=3, lty=2)
text(cl-10, 0, "cl", pos=4)
abline(v=cu, col=3, lwd=3, lty=2)
text(cl+20, 0, "cu", pos=4)
dev.off()

### illustrate the mean vs median
pdf("gammaMedian.pdf", width=8, height=5)
xs <- seq(0, 20, length =1000)
ys <- dgamma(xs, shape = 2, scale = 2)
plot(xs, ys, type = "l", col=2, lwd=3, xlab="x", ylab="Density")
target <- qgamma(0.5, shape = 2, scale = 2)
abline(v=target, col=2, lwd=3, lty=2)
text(target-2, 0.01, "median", col=2, pos=4)
abline(v=4, col=3, lwd=3, lty=2)
text(4, 0.01, "mean", col=3, pos=4)
dev.off()

### illustrate the bootstrap CI
target <- qgamma(0.5, shape = 2, scale = 2)
set.seed(2021)
n <- 50
x <- rgamma(n, shape = 2, scale = 2)
med <- median(x)

B = 1000
Bs = c()
for (i in 1:B) {
    xboot = sample(x, n, replace = TRUE)
    medboot = median(xboot)
    Bs[i] = medboot
}

medCI <- quantile(Bs, c(.025, .975))
medCI
