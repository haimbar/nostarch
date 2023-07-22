b2g <- 1.05 # B/G
# Since B/G=1.05, B=1.05G, so Pr(boy)=B/(B+G)
pboy <- 1.05/(1+1.05)
n <- 300
nsim <- 1
set.seed(100091)
boysInSample <- rbinom(nsim, n, pboy)
cat("Prob. boy:", pboy, ". Simulated number of boys in a sample of 300 is:", mean(boysInSample),"\n")


pdf("images/chapter_4/CLTboygirl.pdf", width=10, height=4)
par(mfrow=c(1, 3))

n <- 300
nsim <- 10000
set.seed(100091)
boysInSample <- rbinom(nsim, n, pboy)
hist(boysInSample, breaks=30, border="white", col="grey66", xlim=c(130,190), freq=FALSE, main="n=300")
abline(v=pboy*n, col=3, lwd=3)
abline(v=148, col=2, lwd=2)

# sample size is 10 times larger:
boysInSample2 <- rbinom(nsim, 10*n, pboy)
hist(boysInSample2, breaks=30, border="white", col="grey66", xlim=c(1400,1700), freq=FALSE, main="n=3,000")
abline(v=pboy*10*n, col=3, lwd=3)
abline(v=1480, col=2, lwd=2)

# sample size is 100 times larger than the original example:
boysInSample3 <- rbinom(nsim, 100*n, pboy)
hist(boysInSample3, breaks=30, border="white", col="grey66", xlim=c(14500,16000), freq=FALSE, main="n=30,000")
abline(v=pboy*100*n, col=3, lwd=3)
abline(v=14800, col=2, lwd=2)

par(mfrow=c(1,1))
dev.off()
