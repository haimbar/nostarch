pdf("images/chapter_2/barplot.pdf", width=6, height=4)
barplot(table(xcat), col=c("lightblue", "wheat1", "thistle2",
                           "paleturquoise"))
#pie(table(xcat),col=c("lightblue", "wheat1", "thistle2", "paleturquoise"))
dev.off()
