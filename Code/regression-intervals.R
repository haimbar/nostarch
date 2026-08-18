# Compare a confidence interval for a mean with a prediction interval.

set.seed(2026)
age <- runif(120, min = 12, max = 18)
height <- 45 + 1.4 * age + rnorm(length(age), sd = 2.5)
students <- data.frame(age, height)

#label===REGintervals1
height_fit <- lm(height ~ age, data = students)
new_student <- data.frame(age = 15)
predict(
  height_fit, newdata = new_student, interval = "confidence"
)
predict(
  height_fit, newdata = new_student, interval = "prediction"
)
#===end

age_grid <- data.frame(age = seq(12, 18, length.out = 200))
mean_interval <- predict(
  height_fit, newdata = age_grid, interval = "confidence"
)
person_interval <- predict(
  height_fit, newdata = age_grid, interval = "prediction"
)

plot_interval <- function(interval, title) {
  plot(
    students$age, students$height,
    xlab = "Age (years)", ylab = "Height (inches)", main = title,
    pch = 1, cex = 1.05, lwd = 1.2, ylim = c(55, 76),
    cex.axis = 1.15, cex.lab = 1.2, cex.main = 1.25
  )
  polygon(
    c(age_grid$age, rev(age_grid$age)),
    c(interval[, "lwr"], rev(interval[, "upr"])),
    col = "grey85", border = NA
  )
  points(students$age, students$height, pch = 1, cex = 1.05, lwd = 1.2)
  lines(age_grid$age, interval[, "fit"], lwd = 2.5)
  lines(age_grid$age, interval[, "lwr"], lty = 2, lwd = 2)
  lines(age_grid$age, interval[, "upr"], lty = 2, lwd = 2)
}

pdf("images/chapter_8/regression-intervals.pdf", width = 8, height = 4)
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))
plot_interval(mean_interval, "Mean height")
plot_interval(person_interval, "One new student")
dev.off()
