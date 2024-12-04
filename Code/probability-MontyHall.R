set.seed(123)
n <- 1000
prize <- rep(NA, n)                    # (@\wingding{1}@)
host <- rep(NA, n)                     # (@\wingding{2}@)
for (i in 1:n){
    prize[i] <- sample(1:3, 1)         # (@\wingding{3}@)
    if (prize[i] == 1){                # (@\wingding{4}@)
        host[i] <- sample(c(2, 3), 1)  # (@\wingding{5}@)
    } else if (prize[i] == 2) {        # (@\wingding{6}@)
        host[i] <- 3                   # (@\wingding{7}@)
    } else if (prize[i] == 3) {        # (@\wingding{8}@)
        host[i] <- 2                   # (@\wingding{9}@)
    }
}
observed <- prize[host == 3]           # (@\wingding{10}@)
print(prob.monty <- sum(observed == 2) / length(observed))
