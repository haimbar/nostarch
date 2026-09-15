pdf("images/chapter_2/barplot.pdf", width=6, height=4)
#label===barplot-xcat
barplot(table(xcat), col=c("lightblue", "wheat1", "thistle2",
                           "paleturquoise"))
#===end
#pie(table(xcat),col=c("lightblue", "wheat1", "thistle2", "paleturquoise"))
dev.off()
