shots <- 20
made <- 16

pgrid <- seq(0.01, 0.99, by = 0.01)
loglike <- dbinom(made, size = shots, prob = pgrid, log = TRUE)
phat <- pgrid[which.max(loglike)]

# Save figure for the book build
pdf("images/chapter_6/loglik_binom.pdf", width = 6, height = 4)
plot(pgrid, loglike, type = "l", xlab = "Free-throw probability p",
     ylab = "Log Likelihood")
abline(v = phat, lty = 2, col = "red")
text(phat, min(loglike), labels = paste0("MLE = ", round(phat, 2)), pos = 4, col = "red")
dev.off()
