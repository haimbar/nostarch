set.seed(1000002)
popsize <- 1000
B_neg_rate <- 0.02

blood_type_bneg <- sample(popsize, size = B_neg_rate*popsize) # (@\wingding{1}@)
nbneg <- length(blood_type_bneg)
perp <- sample(nbneg, size=1) # (@\wingding{2}@) The real perpetrator

teddy <- rep(0, 200)
for (i in 1:200) {
  teddy[i] <- sample(nbneg, size=1) # (@\wingding{3}@)
}

cat(sum(teddy == perp), "\n")
cat(100-100*sum(teddy == perp)/length(teddy), "\n")
