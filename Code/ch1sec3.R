#label===ch1sec3-1
set.seed(321333)
n <- 10000
lambda <- 10
x <- -log(runif(n)) / lambda
#===end

options(digits=3)
#label===ch1sec3-2
mean(x)
mean(x, trim=0.1)
median(x)
#===end

pdf("images/chapter_1/expdistbp.pdf", width=6, height=4)
#label===ch1sec3-3
boxplot(x, cex=0.5, col=4, border="grey66", horizontal=TRUE, axes=FALSE,
        at=0.25)
axis(1, pos=0)
points(mean(x), 0.25, col=2, pch=19, cex=0.7)
points(mean(x, trim=0.1), 0.25, col="brown", pch=18)
#===end
dev.off()

pdf("images/chapter_1/expdisthist.pdf", width=6, height=4)
#label===ch1sec3-4
hist(x, breaks=50, border="white", col="lightblue", freq=FALSE,
     xlim=c(0, 0.6), main="")
deciles <- quantile(x, probs=seq(0.1, 0.9, by=0.1))
abline(v=deciles, lty=2, col="purple", lwd=2)
text(deciles, dexp(deciles, 10), paste0(seq(10, 90, by=10), "%"),
     cex=0.7, col="orange")
#===end
dev.off()

#label===ch1sec3-5
var(x)
sd(x) # note that sd(x) is sqrt(var(x))
IQR(x)
#===end


pdf("images/chapter_1/normdisthist.pdf", width=6, height=4)
#label===ch1sec3-6
y <- rnorm(10000, mean=2.5, sd=0.5)
hist(y, breaks=30, border="white", col="navyblue", freq=FALSE, main="")
xs <- seq (0, 5, length=500)
lines(xs, dnorm(xs, 2.5, 0.5), col="orange", lwd=4)
#===end

dev.off()

#label===ch1sec3-7
print(summary(y))
#===end

print(pastecs::stat.desc(y))

#label===ch1sec3-8
hotelrooms <- cut(runif(100), breaks=c(0, 0.4, 0.7, 1),
                  include.lowest=TRUE)
levels(hotelrooms) <- c("Motel 6", "Best Western", "Hilton")
autorental <- cut(runif(100), breaks=c(0, 0.7, 1), include.lowest=TRUE)
levels(autorental) <- c("Honda", "Tesla")
(hoteltbl <- table(hotelrooms)) # (@\wingding{1}@)
(autotbl <- table(autorental))  # (@\wingding{2}@)
table(hotelrooms, autorental)   # (@\wingding{3}@)
#===end
