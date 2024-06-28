## Simpson’s Paradox
5 / (5 + 6)
3 / (3 + 4)

6 / (6 + 3)
9 / (9 + 5)

(5 + 6) / (5 + 6 + 6 + 3)
(3 + 9) / (3 + 4 + 9 + 5)

set.seed(2023)
g <- 4                            # number of groups
n <- 40                           # number of instances in each group
z <- rep(1:g, each = n)           # grouping variable
x <- runif(n * g, 0, 2) + z       # x variable that depends on z
y <- 3 * z - x + rnorm(n * g)     # y variable that depends on x and z
plot(x, y, pch=19, col=4, cex=0.7) # plot the whole data
abline(lm(y ~ x), lwd=3, col="navyblue")   # show the overall linear trend

points(x, y, pch = z, col = z)      # plot the data with group labeled
for (grp in 1:g)
  abline(lm(y[z==grp] ~ x[z==grp]), lwd=3, col=grp, lty=2)

## Berkson’s bias
set.seed(2023)
n  <- 1000
book  <- rnorm(n)
movie <- rnorm(n)
plot(book, movie) # plot all the books and movies
cor(book, movie)

good.b <- book > quantile(book, 0.9)
good.m <- movie > quantile(movie, 0.9)
good  <- good.b | good.m
plot(book[good], movie[good]) # plot only the good books or good movies
cor(book[good], movie[good])
fit <- lm(book[good] ~ movie[good])
abline(fit)

plot(book, movie) # plot the whole data
points(book[good], movie[good], col="red")

x <- rnorm(10000)
y = x[x>=1]
c(mean(x), mean(y))
## z <- sort(x)

## N <- 100
## P <- 1:N 
## sample(P, 0.5*N, replace = FALSE)
## sample(P, 0.5*N, replace = TRUE)

## set.seed(2023)
## N <- 1000
## P <- rpois(N, 1)
## hist(P)
## mu <- mean(P)
## n  <- 500
## rpt <- 1000
## S.ur  <- replicate(rpt, sample(P, n, replace = TRUE))
## hist(colMeans(S.ur))
## mean((colMeans(S.ur) - mu)^2)
## S.uwr  <- replicate(rpt, sample(P, n, replace = FALSE))
## mean((colMeans(S.uwr) - mu)^2)

## A <- P + runif(N, 0, 2)
## S.wr  <- replicate(rpt, sample(P, n, replace = TRUE, prob = A))
## mean((colMeans(S.wr) - mu)^2)


## ## S.wwr  <- replicate(rpt, sample(P, n, replace = FALSE, W))
## ## mean((colMeans(S.wwr) - mu)^2)

## ## ## A <- P + runif(N, 0, 2)
## ## ## W <- A / sum(A)
## ## wr <- function(P, W, n){
## ##     N <- length(P)
## ##     idx <- sample(N, n, replace = TRUE, W)
## ##     s <- P[idx]
## ##     w <- W[idx]
## ##     mean(s/w) / N
## ## }
## ## S.wr  <- replicate(rpt, wr(P, W, n))
## ## mean((S.wr - mu)^2)

## ## wwr <- function(P, W, n){
## ##     N <- length(P)
## ##     idx <- sample(N, n, replace = FALSE, W)
## ##     s <- P[idx]
## ##     w <- W[idx]
## ##     mean(s/w) / N
## ## }
## ## S.wwr <- replicate(rpt, wwr(P, W, n))
## ## mean((S.wwr - mu)^2)
