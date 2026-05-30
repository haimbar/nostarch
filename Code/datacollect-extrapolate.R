set.seed(3527)

#label===EXT1
n <- 500
x <- seq(0, 2, length=n)           # (@\wingding{1}@)
e <- rnorm(n, 0, 0.05)             # (@\wingding{2}@)
y1 <- x + e                        # (@\wingding{3}@)
y2 <- log(1 + x) + e               # (@\wingding{4}@)
sgn <- ifelse(x > 1, -1, 1)        # (@\wingding{5}@)
y3 <- (x <= 1)*exp(sgn*x) + 
  (x > 1)*exp(-0.5*x+1.5) - 1 + e  # (@\wingding{6}@)
#===end

pdf("images/chapter_6/extra1.pdf", width=4, height=4)
par(mar=c(4, 4, 0.5, 0.5))
n1 <- 60
plot(x[1:n1], y1[1:n1], pch=19, cex=0.3, col="navyblue",
     xlab="x", ylab="y", axes=FALSE)
axis(1); axis(2)
abline(0,1, lwd=3, col="lightblue")
dev.off()

pdf("images/chapter_6/extra2.pdf", width=4, height=4)
par(mar=c(4, 4, 0.5, 0.5))
#label===EXT2
pts <- sample(1:n, 100)
plot(x[pts], y1[pts], pch=19, cex=0.7, col="navyblue",
     xlab="x", ylab="y", ylim=c(0, 2.1), axes=FALSE)
points(x[pts], y2[pts], pch=18, cex=0.7, col="green")
points(x[pts], y3[pts], pch=17, cex=0.7, col="orange")
text(1.7, 1.95, 'y1')
text(1.9, 1.2, 'y2')
text(0.9, 1.8, 'y3')
axis(1); axis(2)
abline(0,1, lwd=3, col="lightblue")
rect(0, 0, 0.4, 0.4, lty = 2, border="grey66")
#===end
dev.off()
