#label===ch1sec1-1
help(date)
?date
#===end

## savecwd <- getwd()
#label===ch1sec1-getwd
getwd()
#===end

## setwd("~/work")
## setwd(savecwd)

#label===ch1sec1-2
courseNames <- c("Data Science", "Statistics", "Probability")
#===end

#label===ch1sec1-3
class(courseNames)
#===end

#label===ch1sec1-4
str(courseNames)
#===end

#label===ch1sec1-5
length(courseNames)
#===end


#label===ch1sec1-6
oddLT20 <- seq(1, 20, by=2)
print(oddLT20)
print(length(oddLT20))
#===end

#label===ch1sec1-7
(firstThirteen <- 1:13)
#===end

#label===ch1sec1-8
ones <- rep(1, 10)
sum(ones)
cumsum(ones)
#===end

#label===ch1sec1-9
paste(courseNames)
paste(courseNames, collapse=", ")
concatvar <- paste(courseNames, collapse=", ")
#===end

#label===ch1sec1-deck
suits <- c(rep("C",13), rep("D",13), rep("H", 13), rep("S", 13))
cards <- paste0(suits, rep(1:13, 4))
cat(cards)
#===end

#label===ch1sec1-deal
set.seed(5252)
(pokerHand <- matrix(sample(cards, 20, replace=FALSE), nrow=4,
                     ncol=5))
dimnames(pokerHand) <- list(paste("Player", 1:nrow(pokerHand)),
                            paste("card", 1:ncol(pokerHand)))
#===end

#label===ch1sec1-save
save(pokerHand, file="tmp/pokerHand.RData")
#===end

#label===ch1sec1-load
load("tmp/pokerHand.RData")
#===end

cat(LETTERS)
cat(letters)
cat(month.abb)
cat(month.name)
cat(pi)

if (! ("lattice" %in% installed.packages()))
install.packages("lattice")

#label===ch1sec1-10
library("lattice")
#===end

#label===ch1sec1-vocal
library("lattice")
bwplot(voice.part ~ height, data=singer, xlab="Height (inches)")
#===end

pdf("images/chapter_1/operaheight.pdf", height=5, width=8)
library("lattice")
plot(bwplot(voice.part ~ height, data=singer, xlab="Height (inches)"), asp=1/1.6)
dev.off()

cat("  ", getwd(), "done\n")
