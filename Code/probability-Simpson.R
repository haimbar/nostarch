set.seed(123)
g <- 4                            # number of groups
n <- 40                           # number of instances in each group
z <- rep(1:g, each = n)           # grouping variable
x <- runif(n * g, 0, 2) + z       # x variable that depends on z
y <- 2 * z - x + rnorm(n * g)     # y variable that depends on x and z
pdf("images/probability-Simpson-plots.pdf", height=5, width=5)
plot(x, y)                        # plot the whole data
plot(x, y, pch = z, col = z)      # plot the data with group labeled
dev.off()

## pdf("images/probability-Simpson-whole.pdf", height=5, width=5)
## pdf("images/probability-Simpson-group.pdf", height=5, width=5)
