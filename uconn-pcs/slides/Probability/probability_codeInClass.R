## Elevator waiting time
set.seed(2023)
n <- 1000
elevators <- runif(n, min=1, max=15)
up <- elevators < 13
sum(up) / n

## Intransitive Dice
A <- c(2, 2, 4, 4, 9, 9)
B <- c(1, 1, 6, 6, 8, 8)
C <- c(3, 3, 5, 5, 7, 7)
n <- 1000
set.seed(2023)
sum(sample(A, n, replace = TRUE) > sample(B, n, replace = TRUE)) / n
set.seed(2023)
ab <- mean(sample(A, n, replace = TRUE) > sample(B, n, replace = TRUE))
bc <- mean(sample(B, n, replace = TRUE) > sample(C, n, replace = TRUE))
ac <- mean(sample(A, n, replace = TRUE) > sample(C, n, replace = TRUE))
c(ab, bc, ac)


rollA <- sample(A, n, replace=TRUE)
rollB <- sample(B, n, replace=TRUE)
rollC <- sample(C, n, replace=TRUE)
mean(rollA > rollB)
mean(rollB > rollC)
mean(rollC > rollA)

## Two Child Problem
kids <- c("boy", "girl")
set.seed(2023)
n <- 10000
sample(kids, 2, replace = TRUE)
res = replicate(n, sample(kids, 2, replace = TRUE))
firstgirl <- res[1,] == "girl"
mean(res[2,firstgirl] == "girl")

set.seed(2023)
n <- 1000
res = replicate(n, sample(kids, 2, replace = TRUE))
onegirl <- res[1,] == "girl" | res[2,] == "girl"
twogirls <- (res[1,onegirl] == "girl") & (res[2,onegirl] == "girl")
mean(twogirls)

boygirl <- (res[,onegirl] == "girl")
mean(colSums(boygirl) == 2)

## Bertrand’s Box
set.seed(2023)

boxes <- matrix(c("G", "G", "G", "S", "S", "S"), 2, 3)

boxcoin <- function(boxes) {
    boxid <- sample(1:3, 1)
    box <- boxes[,boxid]
    coin <- sample(box, 1)
    return(c(boxid, coin))
}

n <- 1000
res <- replicate(n, boxcoin(boxes))
id <- res[2,] == "G"
boxG <- res[1,id]
mean(boxG == "1")

## another data structure
boxes <- c("GG", "GS", "SS")

boxcoin <- function(boxes) {
    box <- sample(boxes, 1)
    idx <- sample(1:2, 1)
    coin <- substr(box, start=idx, stop=idx)
    return(c(box, coin))
}
boxcoin(boxes)

res <- replicate(n=100000, boxcoin(boxes))
sum(res[1,] == "GG" & res[2,] == "G") / sum(res[2,] == "G")

mean(res[1, res[2,] == "G"] == "GG")


## Monty Hall problem
set.seed(2023)
choice <- 1

monty <- function(choice) {
    car <- sample(1:3, 1)
    if (car == choice) {
        host <- sample(c(1:3)[-choice], 1)
    } else {
        host <- c(1:3)[-c(choice, car)]
    }
    c(car, host)
}

n <- 1000
res <- replicate(n, monty(1))
open3id <- res[2,] == 3
open3 <- res[,open3id]
car.open3 <- open3[1,]
stick <- mean(car.open3 == 1)
switch <- mean(car.open3 == 2)
c(stick, switch)

n <- 1000
n.open3 <- 0
n.door1 <- n.door2 <- 0
for (i in 1:n){
    onegame <- monty(1)
    if (onegame[2] == 3){
        n.open3 <- n.open3 + 1
        if (onegame[1] == 2) {
            n.door2 <- n.door2 +1
        }
        if (onegame[1] == 1) {
            n.door1 <- n.door1 +1
        }
    }
}
c(n.door1, n.door2) / n.open3


## Birthday Problem
n <- 1000
n.same <- 0
for (i in 1:n){
    oneroom <- sample(1:365, 23, replace = TRUE)
    uni <- unique(oneroom)
    if (length(uni) < 23){
        n.same <- n.same +1    
    }
}
n.same / n

n <- 1000
n.same <- 0
for (i in 1:n){
    oneroom <- sample(1:2400000, 500, replace = TRUE)
    uni <- unique(oneroom)
    if (length(uni) < 500){
        n.same <- n.same +1    
    }
}
n.same / n

birth <- function(n.person, N.days, n.trials=1000) {
    n.same <- 0
    for (i in 1:n.trials){
        oneroom <- sample(1:N.days, n.person, replace = TRUE)
        uni <- unique(oneroom)
        if (length(uni) < n.person){
            n.same <- n.same +1    
        }
    }
    n.same / n.trials
    ## return(n.same / n.trials)
}

birth(23, 365, 100000)
birth(28, 365)
birth(500, 2400000)

## Simpson’s Paradox
5 / (5 + 6)
3 / (3 + 4)

6 / (6 + 3)
9 / (9 + 5)

(5 + 6) / (5 + 6 + 6 + 3)
(3 + 9) / (3 + 4 + 9 + 5)

set.seed(2023)
g <- 4                            # number of groups
n <- 40                           # number of instances in each group
z <- rep(1:g, each = n)           # grouping variable
x <- runif(n * g, 0, 2) + z       # x variable that depends on z
y <- 3 * z - x + rnorm(n * g)     # y variable that depends on x and z
plot(x, y, pch=19, col=4, cex=0.7) # plot the whole data
abline(lm(y ~ x), lwd=3, col="navyblue")   # show the overall linear trend

plot(x, y, pch = z, col = z)      # plot the data with group labeled
for (grp in 1:g)
  abline(lm(y[z==grp] ~ x[z==grp]), lwd=3, col=grp, lty=2)
