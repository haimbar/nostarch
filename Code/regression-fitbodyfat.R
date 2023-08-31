bodyfat <- read.csv("Data/bodyfat.csv")
names(bodyfat)

fit <- lm(BodyFat ~ Age + Weight + Chest + Wrist + BMI, data=bodyfat)
summary(fit)
coef(fit)

pdf("images/chapter_regression/fitbodyfat.pdf", width=6, height=4)
plot(bodyfat$BodyFat, fit$fitted.values, xlab="Body Fat",
     ylab="Estimated Body Fat")
dev.off()

print(fit)
