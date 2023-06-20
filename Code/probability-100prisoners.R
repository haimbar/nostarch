set.seed(123)
n <- 100 # number of prisoners
prisoners <- 1:n # prisoners' numbers
open.random <- function(prisoners, n=length(prisoners)) {
    ## simulate the procedure of randomly open 50 (n/2) drawers
    drawers <- sample(1:n, size=n, replace=FALSE)
    ## randomly put prisoners' numbers in the drawers
    pardon <- TRUE # initialize pardon to be true
    for (i in prisoners) {
        opens <- sample(drawers, n/2)
        ## randomly open n/2 drawers
        if (!(i %in% opens)) {
            ## if any prisoner does not find his number all prisoners die
            pardon <- FALSE
            break
        }
    }
    return (pardon)
}

open.smart <- function(prisoners, n=length(prisoners)) {
    ## simulate the procedure of smartly open 50 (n/2) drawers
    drawers <- sample(1:n, size=n, replace=FALSE)
    pardon <- TRUE
    for (i in prisoners) {
        opens <- rep(NA, n/2)
        opens[1] <- drawers[i]
        for (j in 2:(n/2)){
            if (opens[j-1] == i) {
                break
            } else {
                opens[j] <- drawers[opens[j-1]]
            }
        }
        if (!(i %in% opens)) {
            pardon <- FALSE
            break
        }
    }
    return (pardon)
}

## survival probability of randomly open
print(prob.openrandom <- mean(replicate(10000, open.random(prisoners))))
## survival probability of using the better strategy
print(prob.opensmart <- mean(replicate(10000, open.smart(prisoners))))
