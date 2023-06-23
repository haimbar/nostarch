set.seed(123)
kids <- c("boy", "girl")
n <- 1000
res <- replicate(n, sample(kids, 2, replace=TRUE)) # simulate n families
## Number of families with two girls:
n_twog = sum((res[1,] == "girl") & (res[2,] == "girl"))
## Number of families with the older child being a girl:
n_oldg = sum(res[1,] == "girl")
## Number of families with at least one girl:
n_oneg = sum((res[1,] == "girl") | (res[2,] == "girl"))
## Compute the two probabilities:
cat(prob.girls <- round(c(n_twog / n_oldg, n_twog / n_oneg), digits=3))
