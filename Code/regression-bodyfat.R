bodyfat <- read.csv("Data/bodyfat.csv")
names(bodyfat)

fit <- lm(BodyFat ~ Age + Weight + Chest + Wrist + BMI, data=bodyfat)
summary(fit)
coef(fit)

pdf("images/chapter_8/fitbodyfat.pdf", width=6, height=4)
par(mar = c(2.5, 2.5, 0, 0), mgp = c(1.5, 0.5, 0))
plot(bodyfat$BodyFat, fit$fitted.values, xlab="Body Fat",
     ylab="Estimated Body Fat")
dev.off()

print(fit)

print(10)
