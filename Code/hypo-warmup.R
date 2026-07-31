#label===coinflip
set.seed(42)
sim <- rbinom(100000, size = 20, prob = 0.5)
p_coin <- mean(sim >= 16)
p_coin
#===end

#label===teacheck
set.seed(2021)
guess_right <- replicate(100000, {
  guess <- sample(8, 4)
  all(sort(guess) == 1:4)
})
p_tea <- mean(guess_right)
p_tea
#===end
