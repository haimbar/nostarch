pdf("images/chapter_regression/nonLinear.pdf", width=5, height=5)
set.seed(1)
n <- 200
x <- rnorm(n) # generate observations for variable x
x <- c(x, -x) # make x symmetric about zero
y <- 10 * x^2 + rnorm(2 * n) # y is mainly determined by x
plot(x, y, main=paste("r=", round(cor(x, y), digits=3)))
dev.off()
