pdf("images/chapter_7/population.pdf", width=3.5, height=3.5)
#label===BIASgbs1
set.seed(2027)
N = 1000
height <- rnorm(N, 70, 2.6)
weight <- -194.49 + 5.30 * height + rnorm(N, 0, 23.26)
population <- data.frame(height=height, weight=weight)
plot(population, ylim=range(weight), xlim=range(height),
     pch=19, cex=0.5, col='grey', axes=FALSE)
abline(-194.49, 5.3, lwd=2)
axis(1); axis(2)
#===end
dev.off()

pdf("images/chapter_7/representSample.pdf", width=3.5, height=3.5)
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

pdf("images/chapter_7/biasedSample.pdf", width=3.5, height=3.5)
#label===BIASgbs3
plot(population, ylim=range(weight), xlim=range(height),
     pch=19, cex=0.5, col='grey', axes=FALSE)
abline(-194.49, 5.3, lwd=2)
axis(1); axis(2)
n <- 50
idx2 <- order(weight, decreasing = TRUE)[1:n]        # (@\wingding{1}@)
rsample <- population[idx2,]
points(rsample, col="red", pch=16, cex=1.2)
#===end
dev.off()

#label===BIASgbs4
sd0 <- sd(weight)
sd1 <- sd(weight[idx1])
sd2 <- sd(weight[idx2])
#===end
