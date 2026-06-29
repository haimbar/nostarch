pdf("images/chapter_8/corrLinear.pdf", width=9, height=2)
#label===REGcorrlinear1
set.seed(1)
n <- 200
x <- rnorm(n)         # (@\wingding{1}@)
err <- rnorm(n)       # (@\wingding{2}@)
y1 <-   10 * x + err  # (@\wingding{3}@)
y2 <-  0.6 * x + err  # (@\wingding{4}@)
y3 <-            err  # (@\wingding{5}@)
y4 <- -0.6 * x + err  # (@\wingding{6}@)
y5 <-  -10 * x + err  # (@\wingding{7}@)
par(mfrow=c(1, 5), mar=c(4, 4, 2, 0.1))
plot(x, y1, main=paste("r=", round(cor(x, y1), digits=3)))
plot(x, y2, main=paste("r=", round(cor(x, y2), digits=3)))
plot(x, y3, main=paste("r=", round(cor(x, y3), digits=3)))
plot(x, y4, main=paste("r=", round(cor(x, y4), digits=3)))
plot(x, y5, main=paste("r=", round(cor(x, y5), digits=3)))
#===end
dev.off()
