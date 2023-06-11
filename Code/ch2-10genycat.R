y <- 30 + 4.5 * x -2 * (x - 15)^2 + rnorm(1000, 0, 10)
ycat <- cut(y, breaks=c(0, 30, 60, 100, 300))
ftable(xcat, ycat)
