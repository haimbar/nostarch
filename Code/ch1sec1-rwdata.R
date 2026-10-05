write.csv(pokerHand, file="tmp/pokerHand.csv", row.names=TRUE)
pH = read.csv("tmp/pokerHand.csv")
print(pH)
