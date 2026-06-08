pdf("images/chapter_4/IQfit.pdf", width=5, height=5)
#label===iq-fit-plot
set.seed(95473)
n <- 200
samp <- rnorm(n, 100, 15)
hist(samp, freq=FALSE, main="", xlab="IQ score", border="white", col="lightblue")
xs <- seq(40, 180, length=1000)
lines(xs, dnorm(xs, 100, 15), col=2, lwd=3)
lines(xs, dnorm(xs, mean(samp), sd(samp)), col=3, lwd=3, lty=2)
#===end
dev.off()

#label===iq-tail-prob
cat(1-pnorm(150, mean=mean(samp), sd=sd(samp)), "\n")
#===end

#label===iq-mensa-cutoff
mensacutoff <- round(quantile(samp,probs = 0.98))
cat("Sample quantile:", mensacutoff,"\n")
cat("Population quantile:", qnorm(0.98, mean=mean(samp), sd=sd(samp)), "\n")
#===end

pdf("images/chapter_4/IQtail.pdf", width=5, height=4)
#label===iq-tail-plot
xs <- seq(40,180, length=1000)
plot(xs, dnorm(xs, 100, 15), col=2, lwd=2, type='l', axes=F, ylab="", xlab="IQ")
axis(1); axis(2)
xx <- seq(qnorm(0.98, mean=mean(samp), sd=sd(samp)), 200, length=20)
yy <- dnorm(xx, 100, 15)
polygon(c(xx, rev(xx)), c(rep(0,length(xx)), rev(yy)), col="green", border="green", lwd=2)
#===end

dev.off()

#label===iq-samplesize
sigma <- 15
for (E in c(5, 3, 2, 1))
    cat(sprintf("E = %d  =>  n = %d\n", E, ceiling((sigma / E)^2)))
#===end

