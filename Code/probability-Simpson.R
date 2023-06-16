set.seed(123)
g <- 4                            # number of groups
n <- 40                           # number of samples in each group
z <- rep(1:g, each = n)           # grouping variable
x <- runif(n * g, 0, 2) + z       # x variable that depends on z
y <- 3 * z - x + rnorm(n * g)     # y variable that depends on x and z
pdf("images/chapter_3/probability-Simpson-plots.pdf", height=5, width=5)
plot(x, y, pch=19, col=4, cex=0.7) # plot the whole data
abline(lm(y ~ x), lwd=3, col="navyblue")   # show the overall linear trend
plot(x, y, pch = z, col = z)       # plot the data with group labeled
for (grp in 1:g) # fit a line for each group
    abline(lm(y[z==grp] ~ x[z==grp]), lwd=3, col=grp, lty=2)
dev.off()
