pdf("images/chapter_4/CLT_binom.pdf", width=8, height=5)
par(mfrow=c(1, 2))

n <- 50
allMeans <- rep(0, 10000)
for (i in 1:10000) {
  samp <- rbinom(n, 1, 0.15)
  allMeans[i] <- mean(samp)
}
m <- min(allMeans)
M <- max(allMeans)
hist(allMeans, freq = F, breaks=40, xlim=c(m, M), main="", xlab="Sample mean", border="white", col="orchid")
abline(v=0.15, lwd=3, col="green")

# Repeat, this time with a larger sample size:
# 10000 iterations - show the distribution of the sample means:
n <- 500
allMeans <- rep(0, 10000)
for (i in 1:10000) {
  samp <- rbinom(n, 1, 0.15)
  allMeans[i] <- mean(samp)
}
hist(allMeans, freq = F, breaks=40, xlim=c(m, M), main="", xlab="Sample mean", border="white", col="orange")
abline(v=0.15, lwd=3, col="green")

par(mfrow=c(1, 1))
dev.off()
