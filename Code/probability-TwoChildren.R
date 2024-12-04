set.seed(123)
kids <- c("boy", "girl")                                            # (@\wingding{1}@)
n <- 1000
res <- replicate(n, sample(kids, 2, replace=TRUE))                  # (@\wingding{2}@)
n_twog = sum((res[1,] == "girl") & (res[2,] == "girl"))             # (@\wingding{3}@)
n_oldg = sum(res[1,] == "girl")                                     # (@\wingding{4}@)
n_oneg = sum((res[1,] == "girl") | (res[2,] == "girl"))             # (@\wingding{5}@)
prob.girls <- round(c(n_twog / n_oldg, n_twog / n_oneg), digits=3)  # (@\wingding{6}@)
