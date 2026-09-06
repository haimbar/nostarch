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

#label===teadist
set.seed(2021)
tea_score <- replicate(100000, {
  guess <- sample(8, 4)
  sum(guess %in% 1:4)
})
tea_values <- 0:4
tea_exact <- dhyper(tea_values, m = 4, n = 4, k = 4)
tea_sim <- table(factor(tea_score, levels = tea_values)) / length(tea_score)
pdf("images/chapter_5/hypo-tea-null.pdf", width = 5, height = 4)
par(mar = c(2.5, 2.5, 0, 0), mgp = c(1.5, 0.5, 0))
bar_x <- barplot(tea_exact, names.arg = tea_values, col = "grey75",
                 border = "white", ylim = c(0, 0.55),
                 xlab = "Number correct", ylab = "Relative frequency")
lines(bar_x, tea_sim, type = "b", pch = 19, col = "grey20")
legend("topright", legend = c("Exact", "Simulation"),
       col = c("grey75", "grey20"), pch = c(15, 19), bty = "n")
dev.off()
#===end
