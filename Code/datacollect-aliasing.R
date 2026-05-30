pdf("images/chapter_6/aliasing1.pdf", width=7, height=4)
par(mar=c(4, 4, 0.5, 0.5), mfrow=c(1,2))
#label===aliasing1
library("pracma")
f <- 8                  # (@\wingding{1}@)
dt1 <- 0.1              # (@\wingding{2}@)
t1 = seq(0, 3, by=dt1)  # (@\wingding{3}@) 
y1 = cos(2*pi*f*t1)     # (@\wingding{4}@)
plot(t1, y1, axes=FALSE, col=2, pch=19, cex=0.6,
     xlab="t", ylab=expression(paste("cos(2 ", pi, " f t)")))
axis(1); axis(2)

dt1_est <- 0.001                # (@\wingding{5}@)
t1_est <- seq(0, 3, by=dt1_est) # (@\wingding{6}@)
y_est <- interp1(t1, y1, t1_est, method = "spline")  # (@\wingding{7}@)
plot(t1_est, y_est, type='l', axes=FALSE, col="grey", lwd=0.5,
     xlab="t", ylab=expression(paste("cos(2 ", pi, " f t)")))
points(t1, y1, col=2, pch=19, cex=0.6)
axis(1); axis(2)
#===end
dev.off()


pdf("images/chapter_6/aliasing2.pdf", width=4, height=4)
par(mar=c(4, 4, 0.5, 0.5))
#label===aliasing2
f <- 8                  # (@\wingding{1}@)
dt2 <- 0.01             # (@\wingding{2}@)
t2 <- seq(0, 3, by=dt2) # (@\wingding{3}@)
y2 <- cos(2*pi*f*t2)    # (@\wingding{4}@)
plot(t2, y2, type='l', axes=FALSE, col="grey", lwd=0.5,
     xlab="t", ylab=expression(paste("cos(2 ", pi, " f t)")))
points(t1, y1, col=2, pch=19, cex=0.6) # (@\wingding{5}@)
axis(1); axis(2)
#===end
dev.off()
