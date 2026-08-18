# Demonstrate response outliers, high leverage, and influence.

set.seed(2026)

# Ordinary observations: house size (thousands of square feet) and sale price
# (thousands of dollars).
size <- seq(1, 3, length.out = 20)
price <- 100 + 150 * size + rnorm(length(size), sd = 18)
ordinary <- data.frame(size, price)

# Each dataset adds one unusual house to the same ordinary observations.
response_outlier <- rbind(
  ordinary,
  data.frame(size = 2, price = 700)
)

high_leverage <- rbind(
  ordinary,
  data.frame(size = 5, price = 850)
)

influential <- rbind(
  ordinary,
  data.frame(size = 5, price = 400)
)

base_fit <- lm(price ~ size, data = ordinary)

plot_case <- function(data, title, limits, show_legend = FALSE) {
  unusual <- nrow(data)
  fit_with_point <- lm(price ~ size, data = data)

  plot(
    data$size[-unusual], data$price[-unusual],
    xlim = limits$x, ylim = limits$y,
    xlab = "House size (1,000 sq. ft.)",
    ylab = "Sale price ($1,000s)",
    main = title, pch = 1, cex = 1.25, lwd = 1.4,
    cex.axis = 1.15, cex.lab = 1.2, cex.main = 1.25
  )
  points(
    data$size[unusual], data$price[unusual],
    pch = 19, col = "#D55E00", cex = 1.8
  )

  # The dashed line excludes the unusual point; the solid line includes it.
  abline(base_fit, lty = 2, lwd = 2.5, col = "grey45")
  abline(fit_with_point, lty = 1, lwd = 2.5)

  if (show_legend) {
    legend(
      "topleft",
      legend = c("Ordinary point", "Unusual point",
                 "Fit without point", "Fit with point"),
      pch = c(1, 19, NA, NA),
      lty = c(NA, NA, 2, 1),
      lwd = c(NA, NA, 2.5, 2.5),
      col = c("black", "#D55E00", "grey45", "black"),
      pt.cex = c(1.25, 1.8, NA, NA),
      bty = "n", cex = 0.95
    )
  }
}

pdf("images/chapter_8/outliers.pdf", width = 10, height = 4)
par(mfrow = c(1, 3), mar = c(4.5, 4.6, 3.5, 0.7))

plot_case(
  response_outlier,
  "Response outlier,\nlow leverage",
  list(x = c(0.8, 3.2), y = c(200, 740)),
  show_legend = TRUE
)

plot_case(
  high_leverage,
  "High leverage,\nnot influential",
  list(x = c(0.8, 5.2), y = c(200, 900))
)

plot_case(
  influential,
  "High leverage\nand influential",
  list(x = c(0.8, 5.2), y = c(200, 900))
)

dev.off()
