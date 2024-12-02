pdf("images/chapter_8/corrLinear.pdf", width=9, height=2)
#label===REGcorrlinear1
set.seed(1)
n <- 200
x <- rnorm(n)        # generate observations on the variable x
err <- rnorm(n)      # generate some random error
y1 <-   10 * x + err # y1 has a very strong positive association with x
y2 <-  0.6 * x + err # y2 has a positive association with x
y3 <-            err # y3 has no linear association with x
y4 <- -0.6 * x + err # y4 has a negative association with x
y5 <-  -10 * x + err # y5 has a very strong negative association with x
par(mfrow=c(1, 5), mar=c(4, 4, 2, 0.1))
plot(x, y1, main=paste("r=", round(cor(x, y1), digits=3)))
plot(x, y2, main=paste("r=", round(cor(x, y2), digits=3)))
plot(x, y3, main=paste("r=", round(cor(x, y3), digits=3)))
plot(x, y4, main=paste("r=", round(cor(x, y4), digits=3)))
plot(x, y5, main=paste("r=", round(cor(x, y5), digits=3)))
dev.off()
#===end
