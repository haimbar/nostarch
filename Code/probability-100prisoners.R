#label===PR100prisoners1
set.seed(123)
n <- 100
prisoners <- 1:n
open.random <- function(prisoners, n=length(prisoners)) {  # (@\wingding{1}@)
    drawers <- sample(1:n, size=n, replace=FALSE)          # (@\wingding{2}@)
    pardon <- TRUE                                         # (@\wingding{3}@)
    for (i in prisoners) {                                 # (@\wingding{4}@)
        opens <- sample(drawers, n/2)                      # (@\wingding{5}@)
        if (!(i %in% opens)) {                             # (@\wingding{6}@)
            pardon <- FALSE                                # (@\wingding{7}@)
            break                                          # (@\wingding{8}@)
        }
    }
    return (pardon)
}

open.smart <- function(prisoners, n=length(prisoners)) {   # (@\wingding{9}@)
    drawers <- sample(1:n, size=n, replace=FALSE)
    pardon <- TRUE
    for (i in prisoners) {
        opens <- rep(NA, n/2)                              # (@\wingding{10}@)
        opens[1] <- drawers[i]                             # (@\wingding{11}@)
        for (j in 2:(n/2)){                                # (@\wingding{12}@)
            if (opens[j-1] == i) {                         # (@\wingding{13}@)
                break                                      # (@\wingding{14}@)
            } else { 
                opens[j] <- drawers[opens[j-1]]            # (@\wingding{15}@)
            }
        }
        if (!(i %in% opens)) {
            pardon <- FALSE
            break
        }
    }
    return (pardon)
}
#===end

#label===PR100prisoners2
print(prob.openrandom <- mean(replicate(10000, open.random(prisoners))))
print(prob.opensmart <- mean(replicate(10000, open.smart(prisoners))))
#===end
