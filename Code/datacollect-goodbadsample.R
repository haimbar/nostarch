pdf("images/chapter_6/population.pdf", width=3.5, height=3.5)
#label===BIASgbs1
set.seed(2023)
N = 500
height <- rnorm(N, 70, 2.6)
weight <- -194.49 + 5.30 * height + rnorm(N, 0, 23.26)
population <- data.frame(height=height, weight=weight)
plot(population)
#===end
dev.off()

pdf("images/chapter_6/representSample.pdf", width=3.5, height=3.5)
#label===BIASgbs2
plot(population)
n <- 50
idx <- sample(N, n)
rsample <- population[idx,]
points(rsample, col="green", pch=2, cex=1.2)
#===end
dev.off()

pdf("images/chapter_6/biasedSample.pdf", width=3.5, height=3.5)
#label===BIASgbs3
plot(population)
n <- 50
f = lm(weight ~ height)
w = abs(f$residuals) / abs(height-70)
idx <- sample(N, n, prob=w)
rsample <- population[idx,]
points(rsample, col="red", pch=2, cex=1.2)
#===end
dev.off()
