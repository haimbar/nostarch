pdf("images/chapter_8/nonLinear.pdf", height=3.6, width=6)
#label===REGnonlinear1
set.seed(1)
n <- 200
x <- rnorm(n)
x <- c(x, -x)                # (@\wingding{1}@)
y <- 10 * x^2 + rnorm(2 * n) # (@\wingding{2}@)
plot(x, y, main=paste("r=", round(cor(x, y), digits=3)))
#===end
dev.off()
