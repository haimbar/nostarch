set.seed(123)
boxs <- c("GG", "GS", "SS")

boxcoin <- function(boxs){
    box <- sample(boxs, 1)
    idx <- sample(1:2, 1)
    coin <- substr(box, start=idx, stop=idx)
    return(c(box, coin))
}

res <- replicate(n=1000, boxcoin(boxs))

print(mean(res[1, res[2,] == "G"] == "GG"))
