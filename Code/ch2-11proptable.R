pdf("images/chapter_2/spineplot.pdf", width=5, height=5)
#label===spineplot-proptable
spineplot(ycat ~ xcat)
prop.table(ftable(ycat ~ xcat))
#===end
dev.off()
