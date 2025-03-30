pdf("images/chapter_6/population.pdf", width=3.5, height=3.5)
#label===BIASgbs1
set.seed(2023)
N = 500
height <- rnorm(N, 70, 2.6)
weight <- -194.49 + 5.30 * height + rnorm(N, 0, 23.26)
population <- data.frame(height=height, weight=weight)
plot(population, ylim=range(weight), xlim=range(height),
     pch=19, cex=0.5, col='grey', axes=FALSE)
abline(-194.49, 5.3, lwd=2)
axis(1); axis(2)
#===end
dev.off()

pdf("images/chapter_6/representSample.pdf", width=3.5, height=3.5)
#label===BIASgbs2
plot(population, ylim=range(weight), xlim=range(height),
     pch=19, cex=0.5, col='grey', axes=FALSE)
abline(-194.49, 5.3, lwd=2)
axis(1); axis(2)
n <- 50
idx1 <- sample(N, n)
rsample <- population[idx1,]
points(rsample, col="darkgreen", pch=17, cex=1)
#===end
dev.off()

pdf("images/chapter_6/biasedSample.pdf", width=3.5, height=3.5)
#label===BIASgbs3
plot(population, ylim=range(weight), xlim=range(height),
     pch=19, cex=0.5, col='grey', axes=FALSE)
abline(-194.49, 5.3, lwd=2)
axis(1); axis(2)
n <- 50
f = lm(weight ~ height)                       # (@\wingding{1}@)
w = abs(f$residuals) / abs(height-70)         # (@\wingding{2}@)
idx2 <- sample(N, n, prob=w)                   # (@\wingding{3}@)
rsample <- population[idx2,]
points(rsample, col="red", pch=16, cex=1.2)
#===end
dev.off()

#label===BIASgbs4
var0 <- var(height)
var1 <- var(height[idx1])
var2 <- var(height[idx2])
#===end
