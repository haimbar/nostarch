pdf("images/chapter_4/LLNtexts.pdf")
ssize <- c(5, seq(10, 1000, by=10))
myMsg <- rep(0, length(ssize))
set.seed((40001))
for (i in 1:length(ssize)) {
    myMsg[i] <- mean(12*rpois(ssize[i], 10))  # (@\wingding{1}@)
}
plot(ssize, myMsg, pch=17, col="blue", axes=FALSE, xlab="Sample Size",
     ylab="Average number of texts")
axis(1); axis(2)
abline(h=12*10, lwd=2,col=2)
dev.off()
