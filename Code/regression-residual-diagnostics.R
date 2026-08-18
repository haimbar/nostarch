# Residual plots for an appropriate line, curvature, and changing spread.

set.seed(2026)
x <- seq(0, 10, length.out = 80)

good <- data.frame(
  x = x,
  y = 3 + 1.2 * x + rnorm(length(x), sd = 1)
)
curved <- data.frame(
  x = x,
  y = 3 + 1.2 * x + 0.35 * (x - 5)^2 + rnorm(length(x), sd = 1)
)
fan <- data.frame(
  x = x,
  y = 3 + 1.2 * x + rnorm(length(x), sd = 0.25 + 0.25 * x)
)

plot_residuals <- function(data, title) {
  fit <- lm(y ~ x, data = data)
  plot(
    fitted(fit), residuals(fit),
    xlab = "Fitted value", ylab = "Residual", main = title,
    pch = 1, cex = 1.2, lwd = 1.3,
    cex.axis = 1.15, cex.lab = 1.2, cex.main = 1.25
  )
  abline(h = 0, lty = 2, lwd = 2, col = "grey40")
}

pdf("images/chapter_8/residual-diagnostics.pdf", width = 10, height = 3.8)
par(mfrow = c(1, 3), mar = c(4.5, 4.5, 3, 0.7))
plot_residuals(good, "Patternless")
plot_residuals(curved, "Curvature")
plot_residuals(fan, "Changing spread")
dev.off()
