set.seed(123)
n <- 10000
spin.shot <- replicate(n, sample(1:6, 2, replace=TRUE))          # (@\wingding{1}@)
first.blank <- spin.shot[1,] > 2                                 # (@\wingding{2}@)
prob1 <- sum(spin.shot[2,first.blank] <= 2) / sum(first.blank)   # (@\wingding{3}@)
twoshots <- function() {                                         # (@\wingding{4}@)
    first.shot <-sample(1:6, 1)                                  # (@\wingding{5}@)
    second.shot <-ifelse(first.shot == 6, 1, first.shot+1)       # (@\wingding{6}@)
    c(first.shot, second.shot)                                   # (@\wingding{7}@)
}
shot.again <- replicate(n, twoshots())                           # (@\wingding{8}@)
first.blank <- shot.again[1,] > 2                                # (@\wingding{9}@)
prob2 <- sum(shot.again[2,first.blank] <= 2) / sum(first.blank)  # (@\wingding{10}@)
print(prob.revolver <- round(c(prob1, prob2), digits=3))
