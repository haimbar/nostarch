set.seed(123)
boxs <- c("GG", "GS", "SS") # define the three boxes
## The following function simulate one round of the game
boxcoin <- function(boxs){
    box <- sample(boxs, 1)
    idx <- sample(1:2, 1)
    coin <- substr(box, start=idx, stop=idx)
    return(c(box, coin))
}
res <- replicate(n=1000, boxcoin(boxs))     # play the game for n times
print(mean(res[1, res[2,] == "G"] == "GG")) # approximate the probability
