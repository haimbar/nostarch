set.seed(123) ## set the random seed so that results are reproducible
n <- 10000 ## number of days to simulate
## the sample space is the possible locations of the elevator [1, 15]
elevator <- runif(n, min=1, max=15) ## outcomes of experiments
up <- (elevator < 13)
## the elevator is below the 13th floor so that it will goes up
print(sum(up) / n)
