pdf("images/chapter_7/aliasing1.pdf", width=7, height=4)
par(mar=c(4, 4, 0.5, 0.5), mfrow=c(1,2))
#label===aliasing1
library("pracma")
f <- 8                  # (@\wingding{1}@)
t1 = seq(0, 3, by=0.1)  # (@\wingding{2}@) 
y1 = cos(2*pi*f*t1)     # (@\wingding{3}@)
plot(t1, y1, axes=FALSE, col=2, pch=19, cex=0.6,
     xlab="t", ylab=expression(paste("cos(2 ", pi, " f t)")))
axis(1); axis(2)

t1_est <- seq(0, 3, by=0.001) # (@\wingding{4}@)
y_est <- interp1(t1, y1, t1_est, method = "spline")  # (@\wingding{5}@)
plot(t1_est, y_est, type='l', axes=FALSE, col="grey", lwd=0.5,
     xlab="t", ylab=expression(paste("cos(2 ", pi, " f t)")))
points(t1, y1, col=2, pch=19, cex=0.6)
axis(1); axis(2)
#===end
dev.off()


pdf("images/chapter_7/aliasing2.pdf", width=4, height=4)
par(mar=c(4, 4, 0.5, 0.5))
#label===aliasing2
f <- 8                  # (@\wingding{1}@)
t2 <- seq(0, 3, by=0.01) # (@\wingding{2}@)
y2 <- cos(2*pi*f*t2)    # (@\wingding{3}@)
plot(t2, y2, type='l', axes=FALSE, col="grey", lwd=0.5,
     xlab="t", ylab=expression(paste("cos(2 ", pi, " f t)")))
points(t1, y1, col=2, pch=19, cex=0.6) # (@\wingding{4}@)
axis(1); axis(2)
#===end
dev.off()
