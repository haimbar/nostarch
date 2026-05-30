x <- rpois(10000, 10)
xcat <- cut(x, breaks=c(0, 9, 12, 16, 25), include.lowest=TRUE)
table(xcat)
