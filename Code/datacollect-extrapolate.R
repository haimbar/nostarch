set.seed(3527)

#label===EXT1
n <- 500
x <- seq(0, 2, length=n)           # (@\wingding{1}@)
e <- rnorm(n, 0, 0.05)             # (@\wingding{2}@)
y <- x - 0.4 * x^2 + e             # (@\wingding{3}@)
#===end

pdf("images/chapter_7/extra1.pdf", width=4, height=4)
par(mar=c(4, 4, 0.5, 0.5))
pts_zoom <- which(x <= 0.25)
plot(x[pts_zoom], y[pts_zoom], pch=19, cex=0.7, col="navyblue",
     xlab="x", ylab="y", xlim=c(0, 0.25), ylim=c(0, 0.25), axes=FALSE)
axis(1); axis(2)
abline(0, 1, lwd=3, col="lightblue")
dev.off()

pdf("images/chapter_7/extra2.pdf", width=8, height=4)
par(mfrow=c(1, 2), mar=c(4, 4, 1, 1))
#label===EXT2
plot(x, y, pch=19, cex=0.7, col="navyblue",
     xlab="x", ylab="y", ylim=c(0, 2.1), axes=FALSE)
axis(1); axis(2)
abline(0, 1, lwd=3, col="lightblue")
rect(0, 0, 0.25, 0.25, lty=2, border="grey66")
## Right panel: zoomed view of the dashed rectangle
pts_zoom <- which(x <= 0.25)
plot(x[pts_zoom], y[pts_zoom], pch=19, cex=0.7, col="navyblue",
     xlab="x", ylab="y", xlim=c(0, 0.25), ylim=c(0, 0.25), axes=FALSE)
axis(1); axis(2)
abline(0, 1, lwd=3, col="lightblue")
#===end
dev.off()
