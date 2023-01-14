help(date)
?date

## savecwd <- getwd()
getwd()
## setwd("~/work")
## setwd(savecwd)

courseNames <- c("Data Science", "Statistics", "Probability")
class(courseNames)
str(courseNames)
length(courseNames)

oddLT20 <- seq(1, 20, by=2)
print(oddLT20)
print(length(oddLT20))

(firstThirteen <- 1:13)

ones <- rep(1, 10)
sum(ones)
cumsum(ones)

paste(courseNames)
paste(courseNames, collapse=", ")
concatvar <- paste(courseNames, collapse=", ")

suits <- c(rep("C",13), rep("D",13), rep("H", 13), rep("S", 13))
cards <- paste0(suits, rep(1:13, 4))
cat(cards)

set.seed(5252)
(pokerHand <- matrix(sample(cards, 20, replace=FALSE), nrow=4, ncol=5))

save(pokerHand, file="tmp/pokerHand.RData")
load("tmp/pokerHand.RData")

cat(LETTERS)
cat(letters)
cat(month.abb)
cat(month.name)
cat(pi)

if (! ("lattice" %in% installed.packages()))
  install.packages("lattice")
  library("lattice")

library("lattice")
bwplot(voice.part ~ height, data=singer, xlab="Height (inches)")

pdf("images/chapter_1/operaheight.pdf", height=5, width=5)
library("lattice")
plot(bwplot(voice.part ~ height, data=singer, xlab="Height (inches)"))
dev.off()

cat("  ", getwd(), "done\n")
