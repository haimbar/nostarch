mysum <- function(x) {
    s = 0
    for (i in x) {
        s = s + i
    }
    return (s)
}
print(c(sum(simData), mysum(simData)))
