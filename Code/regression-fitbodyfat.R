#label===REGfitbodyfat1
bodyfat <- read.csv("Data/bodyfat.csv")
fit <- lm(BodyFat ~ Age + Weight + Chest + Wrist + BMI, data=bodyfat)
print(fit)
#===end

## names(bodyfat)
## summary(fit)
## coef(fit)

pdf("images/chapter_8/fitbodyfat.pdf", width=6, height=4)
#label===REGfitbodyfat2
plot_limits <- range(bodyfat$BodyFat, fit$fitted.values)
plot(bodyfat$BodyFat, fit$fitted.values,
     xlim = plot_limits, ylim = plot_limits, asp = 1,
     xlab = "Measured body fat (%)", ylab = "Fitted body fat (%)")
abline(0, 1, lty = 2, lwd = 2)
#===end
dev.off()
