set.seed(123)
n <- 1000           # number of repetitions
prize <- rep(NA, n) # locations of the car
host <- rep(NA, n)  # the doors that the host may open
for (i in 1:n){
    prize[i] <- sample(1:3, 1)
    if (prize[i] == 1){                # if the car is behind door 1
        host[i] <- sample(c(2, 3), 1)  # the host will open door 2 or 3
    } else if (prize[i] == 2) {        # if the car is behind door 2
        host[i] <- 3                   # the host will open door 3
    } else if (prize[i] == 3) {        # if the car is behind door 3
        host[i] <- 2                   # the host will open door 2
    }
}
observed <- prize[host == 3] # we see the cases that the host open door 3
print(prob.monty <- sum(observed == 2) / length(observed))
