pdf("images/chapter_2/histoverlay.pdf", width=4, height=4)
hist(y[g==0], breaks=20, xlim=range(y), col="orange", border="white", main="", xlab="y")
hist(y[g==1], breaks=20, xlim=range(y), col="#00008090", border="grey66", add=TRUE)
dev.off()
