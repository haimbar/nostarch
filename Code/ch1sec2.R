pdf("images/simunif1.pdf",width=4, height=3)
# Generate 10,000 points from a uniform distribution
set.seed(210313)
n <- 10000
simData <- runif(n)
hist(simData)
dev.off()
 
n <- 10000
simData <- runif(n, min=1, max=5)

# Simulate 200 coin-flips, using the runif function:
set.seed(220513)
n.trials <- 200
cat("Number of Heads is: ", sum(runif(n.trials) < 0.5), "\n")

pdf("images/simunif2.pdf",width=4, height=3)
set.seed(442886)
n.trials <- 200  # the number of coin-tosses in each experiment
reps <- 100  # the number of experiments
Heads <- rep(0, reps)  # A vector to store the results (initialize with 0s)
for (i in 1:reps) {
  Heads[i] <- sum((runif(n.trials) < 0.5))
}
hist(Heads, breaks=20)
dev.off()

pdf("images/simunif3.pdf",width=4, height=3)
set.seed(442886)
reps <- 100
n.trials <- 200
Heads <- rbinom(reps, n.trials, 0.5)
hist(Heads, breaks=20)
dev.off()

