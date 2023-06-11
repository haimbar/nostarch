write.csv(pokerHand, file="tmp/pokerHand.csv", row.names=FALSE)
pH = read.csv("tmp/pokerHand.csv")
print(pH)
