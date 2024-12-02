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
plot(bodyfat$BodyFat, fit$fitted.values, xlab="Body Fat",
     ylab="Estimated Body Fat")
abline(1, 1)
#===end
dev.off()
