pdf("images/chapter_8/agesbp.pdf", width=6, height=4)
#label===REGagesbp1
sbp <- read.table("Data/systolic.txt", header=T)
par(mar = c(2.5, 2.5, 0, 0), mgp = c(1.5, 0.5, 0))
plot(sbp$AGE, sbp$SBP, xlab="Age", ylab="Systolic Blood Pressure")
#===end
dev.off()

## library("xtable")
## print(xtable(t(sbp)), scalebox=0.7)

#label===REGagesbp2
print(fitsbp <- lm(SBP ~ AGE, data=sbp))  # (@\wingding{1}@)
#===end
b <- round(as.numeric(fitsbp$coefficients), digits=4)
