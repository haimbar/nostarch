pdf("images/chapter_4/IQfit.pdf", width=5, height=5)
set.seed(95473)
n <- 200
samp <- rnorm(n, 100, 15)
hist(samp, freq=FALSE, main="", xlab="IQ score", border="white", col="lightblue")
xs <- seq(40, 180, length=1000)
lines(xs, dnorm(xs, 100, 15), col=2, lwd=3)
lines(xs, dnorm(xs, mean(samp), sd(samp)), col=3, lwd=3, lty=2)
dev.off()

cat(1-pnorm(150, mean=mean(samp), sd=sd(samp)), "\n")

mensacutoff <- round(quantile(samp,probs = 0.98))
cat("Sample quantile:", mensacutoff,"\n")
cat("Population quantile:", qnorm(0.98, mean=mean(samp), sd=sd(samp)), "\n")

pdf("images/chapter_4/IQtail.pdf", width=5, height=4)
xs <- seq(40,180, length=1000)
plot(xs, dnorm(xs, 100, 15), col=2, lwd=2, type='l', axes=F, ylab="", xlab="IQ")
axis(1); axis(2)
xx <- seq(qnorm(0.98, mean=mean(samp), sd=sd(samp)), 200, length=20)
yy <- dnorm(xx, 100, 15)
polygon(c(xx, rev(xx)), c(rep(0,length(xx)), rev(yy)), col="green", border="green", lwd=2)

dev.off()

