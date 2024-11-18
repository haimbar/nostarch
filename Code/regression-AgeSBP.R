pdf("images/chapter_8/agesbp.pdf", width=6, height=4)
sbp <- read.table("Data/systolic.txt", header=T)
plot(sbp$AGE, sbp$SBP, xlab="Age", ylab="Systolic Blood Pressure")
dev.off()

## library("xtable")
## print(xtable(t(sbp)), scalebox=0.7)

print(fitsbp <- lm(SBP ~ AGE, data=sbp))
b <- round(as.numeric(fitsbp$coefficients), digits=4)
