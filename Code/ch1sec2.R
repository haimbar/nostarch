pdf("images/chapter_1/simunif1.pdf",width=5, height=3)
#label===ch1sec2-1
# Generate 10,000 points from a uniform distribution
set.seed(210313)
n <- 10000
simData <- runif(n)
hist(simData, main="")
#===end
dev.off()
 
#label===ch1sec2-2
n <- 10000
simData <- runif(n, min=1, max=5)
#===end

# Simulate 200 coin-flips, using the runif function:
#label===ch1sec2-3
set.seed(220513)
ntrials <- 200
cat("Number of Heads is: ", sum(runif(ntrials) < 0.5), "\n")
#===end

pdf("images/chapter_1/simunif2.pdf", width=5, height=3)
#label===ch1sec2-4
set.seed(442886)
ntrials <- 200  # the number of coin-tosses in each experiment
nreps <- 100  # the number of experiments
Heads <- rep(0, nreps)  # A vector to store the results (initialize with 0s)
for (i in 1:nreps) {
  Heads[i] <- sum((runif(ntrials) < 0.5))
}
hist(Heads, breaks=20, main="")
#===end
dev.off()

pdf("images/chapter_1/simunif3.pdf", width=5, height=3)
#label===ch1sec2-5
set.seed(442886)
nreps <- 100
ntrials <- 200
Heads <- rbinom(nreps, ntrials, 0.5)
hist(Heads, breaks=20, main="")
#===end
dev.off()


