# Compare fitted values for training data with predictions for held-out data.

#label===REGbodyfatvalidation1
set.seed(2)
bodyfat <- read.csv("Data/bodyfat.csv")

test_rows <- sample(seq_len(nrow(bodyfat)), size = 0.25 * nrow(bodyfat))
train <- bodyfat[-test_rows, ]
test <- bodyfat[test_rows, ]

bodyfat_fit <- lm(
  BodyFat ~ Age + Weight + Chest + Wrist + BMI,
  data = train
)

train$fitted <- predict(bodyfat_fit, newdata = train)
test$predicted <- predict(bodyfat_fit, newdata = test)
#===end

plot_limits <- range(
  bodyfat$BodyFat, train$fitted, test$predicted
)

pdf("images/chapter_8/bodyfat-validation.pdf", width = 8, height = 4)
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))

plot(
  train$BodyFat, train$fitted,
  xlim = plot_limits, ylim = plot_limits, asp = 1,
  xlab = "Measured body fat (%)", ylab = "Fitted body fat (%)",
  main = "Training data", pch = 1, cex = 1.15,
  cex.axis = 1.1, cex.lab = 1.15, cex.main = 1.2
)
abline(0, 1, lty = 2, lwd = 2)

plot(
  test$BodyFat, test$predicted,
  xlim = plot_limits, ylim = plot_limits, asp = 1,
  xlab = "Measured body fat (%)", ylab = "Predicted body fat (%)",
  main = "Held-out test data", pch = 19, col = "#D55E00", cex = 1.15,
  cex.axis = 1.1, cex.lab = 1.15, cex.main = 1.2
)
abline(0, 1, lty = 2, lwd = 2)

dev.off()

train_rmse <- sqrt(mean((train$BodyFat - train$fitted)^2))
test_rmse <- sqrt(mean((test$BodyFat - test$predicted)^2))
print(c(training_RMSE = train_rmse, test_RMSE = test_rmse))
