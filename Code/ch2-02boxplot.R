pdf("images/chapter_2/boxploty.pdf", width=4, height=4)
boxplot(y, axes=FALSE, border="purple", col="grey66")
axis(2)
dev.off()
