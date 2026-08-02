#label===funcdef
mysum <- function(x) { # (@\wingding{1}@)
    s = 0
    for (i in x) {
        s = s + i
    }
    return (s) # (@\wingding{2}@)
} # (@\wingding{3}@)
#===end

#label===funcdefex
set.seed(210313)
n <- 10000
simData <- runif(n)
cat('From sum: ', sum(simData), '. From mysum: ', mysum(simData), '\n',
     sep = '')
#===end
