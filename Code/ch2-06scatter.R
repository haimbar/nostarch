pdf("images/chapter_2/scatter.pdf", width=4, height=4)
#label===scatter-plot
plot(x, y, pch=19, col="navyblue", cex=0.3, axes=FALSE)
axis(1)
axis(2)
#===end
dev.off()
