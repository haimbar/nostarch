n <- seq(50,5000,by=10)
set.seed(59112)
allDiffs <- rep(0,length(n))
allRatios <- rep(0,length(n))
for (i in 1:length(n)) {
  sA <- rnorm(n[i],70,10)
  sB <- rnorm(n[i],60,20)
  dAB <- sA - sB
  rAB <- sA / sB
  allDiffs[i] <- mean(dAB)
  allRatios[i] <- mean(rAB)
}
par(mfrow=c(1,2))
plot(n, allDiffs,pch=19,col=3, xlab="n", ylab="Diff.", cex=0.5)
abline(h=10,col=2,lwd=2)
plot(n, allRatios,pch=19,col="orange", xlab="n", ylab="Ratio", cex=0.5)
abline(h=70/60,col=2,lwd=2)
par(mfrow=c(1,1))
