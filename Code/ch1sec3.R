set.seed(321333)
n <- 10000
lambda <- 10
x <- -log(runif(n)) / lambda

options(digits=3)
mean(x)
mean(x, trim=0.1)
median(x)

pdf("images/chapter_1/expdistbp.pdf", width=6, height=4)
boxplot(x, cex=0.5, col=4, border="grey66", horizontal=TRUE, axes=FALSE,
        at=0.25)
axis(1, pos=0)
points(mean(x), 0.25, col=2, pch=19, cex=0.7)
points(mean(x, trim=0.1), 0.25, col="brown", pch=18)
dev.off()

pdf("images/chapter_1/expdisthist.pdf", width=6, height=4)
hist(x, breaks=50, border="white", col="lightblue", freq=FALSE,
     xlim=c(0, 0.6), main="")
deciles <- quantile(x, probs=seq(0.1, 0.9, by=0.1))
abline(v=deciles, lty=2, col="purple", lwd=2)
text(deciles, dexp(deciles, 10), paste0(seq(10, 90, by=10), "%"), cex=0.7,
     col="orange")
dev.off()

var(x)
sd(x) # note that sd(x) is sqrt(var(x))
IQR(x)

pdf("images/chapter_1/normdisthist.pdf", width=6, height=4)
y <- rnorm(10000, mean=2.5, sd=0.5)
hist(y, breaks=30, border="white", col="navyblue", freq=FALSE, main="")
xs <- seq (0, 5, length=500)
lines(xs, dnorm(xs, 2.5, 0.5), col="orange", lwd=4)
dev.off()

print(summary(y))
print(psych::describe(y))

hotelrooms <- cut(runif(100), breaks=c(0, 0.4, 0.7, 1), include.lowest=TRUE)
levels(hotelrooms) <- c("Motel 6", "Best Western", "Hilton")
autorental <- cut(runif(100), breaks=c(0, 0.7, 1), include.lowest=TRUE)
levels(autorental) <- c("Honda", "Tesla")
(hoteltbl <- table(hotelrooms))
(autotbl <- table(autorental))
table(hotelrooms, autorental)

