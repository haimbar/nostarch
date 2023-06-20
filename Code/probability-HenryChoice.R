set.seed(123)
n <- 10000 # number of simulations
spin.shot <- replicate(n, sample(1:6, 2, replace=TRUE))
## Assume that the bullets are in chambers 1 and 2.
first.blank <- spin.shot[1,] > 2 # cases of no bullet in first shot
## the probability of a bullet in a random second shot
prob1 <- sum(spin.shot[2,first.blank] <= 2) / sum(first.blank)

twoshots <- function() {
    ## simulate two continuous shots
    first.shot <-sample(1:6, 1)
    second.shot <-ifelse(first.shot == 6, 1, first.shot+1)
    c(first.shot, second.shot)
}
shot.again <- replicate(n, twoshots())
first.blank <- shot.again[1,] > 2
prob2 <- sum(shot.again[2,first.blank] <= 2) / sum(first.blank)
print(prob.revolver <- round(c(prob1, prob2), digits=3))
