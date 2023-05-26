set.seed(95473)
n <- 200
samp1 <- rnorm(n, 100, 15)
cat("Mean=",mean(samp1), ", SD=",sd(samp1),"\n")

pdf("images/chapter_4/qqplot1.pdf")
qqnorm(samp1, cex=0.9, pch=18, col="purple")
abline(100, 15, col="orange", lwd=3)
dev.off()

pdf("images/chapter_4/LLN_IQ.pdf")
set.seed(95473)
ns <- seq(10, 2000, by=10)      # (@\wingding{1}@)
L <- length(ns)
allMeans <- rep(0, L)           # (@\wingding{2}@)
for (i in 1:L) {                # (@\wingding{3}@)
  samp <- rnorm(ns[i], 100, 15)
  allMeans[i] <- mean(samp)     # (@\wingding{4}@)
}
plot(ns, allMeans, pch=19, cex=0.9, col=3, axes=FALSE)
axis(1); axis(2)
abline(h=100, lwd=3,col=2)
dev.off()
