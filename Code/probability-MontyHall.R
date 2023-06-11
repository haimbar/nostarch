set.seed(123)
n <- 1000
first <- 1
prize <- rep(NA, n)
host <- rep(NA, n)
for (i in 1:n){
    prize[i] <- sample(1:3, 1)
    if (prize[i] == 1){
        host[i] <- sample(c(2, 3), 1)
    } else if (prize[i] == 2) {
        host[i] <- 3
    } else if (prize[i] == 3) {
        host[i] <- 2
    }
}
observed <- prize[host == 3]
print(sum(observed == 2) / length(observed))
