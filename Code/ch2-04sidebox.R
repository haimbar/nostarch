pdf("images/chapter_2/sidebysidebp.pdf", width=4, height=4)
boxplot(y ~ g, axes=FALSE, border=c("navyblue","darkgreen"),
        col=c("wheat1", "thistle1"), xlab="", ylim=c(min(y), max(y) * 1.1))
text(1:2, max(y) * 1.05, c("Group 1", "Group 2"), cex=0.6)
axis(2)
dev.off()
