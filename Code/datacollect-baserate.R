set.seed(1000002)
popsize <- 1000
B_neg_rate <- 0.02
blood_type_bneg <- sample(popsize, size = B_neg_rate*popsize) # (@\wingding{1}@)

nrep <- 2000
teddy <- rep(NA, nrep)
test_bneg <- rep(NA, nrep)

for (i in 1:nrep) {
  teddy[i] <- sample(popsize, size=1) # (@\wingding{2}@)
  if (teddy[i] %in% blood_type_bneg) {
      test_bneg[i] <- TRUE # (@\wingding{3}@)
  } else {
      test_bneg[i] <- sample(c(FALSE, TRUE), 1, prob=c(0.95, 0.05)) # (@\wingding{4}@)
  }
}

teddy_test_bneg = teddy[test_bneg ==TRUE]
n_test_bneg = length(teddy_test_bneg)

p_bneg <- sum(teddy_test_bneg %in% blood_type_bneg) / n_test_bneg # (@\wingding{5}@)

cat(n_test_bneg, "\n")
cat(100 - 100 * p_bneg, "\n")
