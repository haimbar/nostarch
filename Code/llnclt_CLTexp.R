pdf("images/chapter_4/CLT_exp.pdf", width=5, height=5)
set.seed(230630)
n <- 100
samp <- rexp(n, 5.5)
hist(samp, freq = F, breaks=20,main="", xlab="x", border="white")
xs <- seq(0, max(samp), length=1000)
lines(xs, dexp(xs,5.5), lwd=3, col=2) # show the true distribution
dev.off()

## 10000 iterations - show the distribution of the sample means:
pdf("images/chapter_4/CLT_exp2.pdf", width=8, height=5)
n <- 50
allMeans <- rep(0, 10000)   # (@\wingding{1}@)
for (i in 1:10000) {
  samp <- rexp(n,5.5)
  allMeans[i] <- mean(samp) # (@\wingding{2}@)
}
par(mfrow=c(1,2))
m <- min(allMeans)
M <- max(allMeans)
hist(allMeans, freq = F, breaks=40, xlim=c(m, M), main="", xlab="Sample mean", border="white", col="orchid")
abline(v=1/5.5, lwd=3, col="green")

## Repeat, this time with a larger sample size:
## 10000 iterations - show the distribution of the sample means:
n <- 500
allMeans <- rep(0, 10000)
for (i in 1:10000) {
  samp <- rexp(n,5.5)
  allMeans[i] <- mean(samp)
}
hist(allMeans, freq = F, breaks=40, xlim=c(m, M), main="", xlab="Sample mean", border="white", col="orange")
abline(v=1/5.5, lwd=3, col="green")
par(mfrow=c(1,1))
dev.off()
