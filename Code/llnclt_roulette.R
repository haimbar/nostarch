set.seed(75473)
n <- 40
samp2 <- rbinom(n, size=1, prob=18/37)
cat("Mean=",mean(samp2), ", SD=",sd(samp2),"\n")

pdf("images/chapter_4/LLN_roulette.pdf")
set.seed(95473)
ns <- seq(10, 2000, by=10)
L <- length(ns)
allMeans <- rep(0, L)
for (i in 1:L) {
  samp <- rbinom(ns[i], size=1, prob=18/37) # (@\wingding{1}@)
  allMeans[i] <- mean(samp)
}
plot(ns, allMeans, pch=19, cex=0.5, col=3, axes=FALSE)
axis(1); axis(2)
abline(h=18/37, lwd=3,col=2)
dev.off()

set.seed(15472)
n <- 10000
roulette <- rbinom(n, 1, 18/37)
cat("Prob. win=", mean(roulette),"\n")
cat("Paid: $", prettyNum(n, big.mark=","), ". Won: ", sum(roulette), "times.", "Total gain:", prettyNum(2*sum(roulette), big.mark = ","), "dollars. Net gain/loss:", prettyNum(2*sum(roulette)-n,big.mark = ","),"\n")
