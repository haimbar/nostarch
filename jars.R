# plot for Example 6.4
# Jar i (i = 1, ..., 9) has (10 - i) red balls and i green balls.

## Bounding box of the drawn content (jar borders): x in [0.6, 9.1],
## y in [-0.1, 1.05]. `pad` gives the border stroke (lwd = 1) a sliver of
## room on each side so xaxs/yaxs = "i" doesn't clip it in half; the
## device size matches the padded box's aspect ratio so there's no
## visible dead space beyond that.
pad <- 0.02
xlim <- c(0.6 - pad, 9.1 + pad)
ylim <- c(-0.1 - pad, 1.05 + pad)
pdf("images/chapter_6/jars.pdf", width = 7.4,
    height = 7.4 * diff(ylim) / diff(xlim))
par(mar = c(0, 0, 0, 0))
plot(0, 0, xlim = xlim, ylim = ylim, xlab = "",
    ylab = "", main = "", axes = FALSE, col = 0,
    xaxs = "i", yaxs = "i")
for (i in 1:9) {
    n_green <- i
    n_red <- 10 - i
    for (j in 1:n_green) {
        y <- (j - 1) * 0.1
        rect(i - 0.3, y, i - 0.2, y + 0.1, col = "green")
    }
    for (j in 1:n_red) {
        y <- (j - 1) * 0.1
        rect(i - 0.1, y, i, y + 0.1, col = "red")
    }
    rect(i - 0.4, -0.1, i + 0.1, 1.05, border = "black")
}
dev.off()
