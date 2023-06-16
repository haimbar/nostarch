set.seed(123)
players <- c("Tom", "Jerry")
res <- replicate(n=1000, sample(players, 5, replace=TRUE)) # Simulate n games
TomFirst = (res[1:3,] == "Tom")
## Whether Tom won in the first three rounds
TomTwice = colSums(TomFirst) == 2
## Whether Tom won twice in the first three rounds
TomFinal = (colSums(res == "Tom") >=3) & TomTwice
## Whether Tom would be the final winner
TomP = sum(TomFinal) / sum(TomTwice)
## The probability that Tom would be the final winner
print(c(Tom=TomP, Jerry=1-TomP))
