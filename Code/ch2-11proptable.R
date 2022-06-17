pdf("images/chapter_2/spineplot.pdf", width=5, height=5)
spineplot(ycat ~ xcat)
prop.table(ftable(ycat ~ xcat))
dev.off()
