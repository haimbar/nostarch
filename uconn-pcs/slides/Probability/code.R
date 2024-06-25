## roll a die
die <- 1:6
sample(die, 1)

set.seed(1)
n <- 1000
rolls <- replicate(n, sample(die, 1))
E = c(2, 4, 6)
even <- rolls %in% E
sum(even) / n

## roll two dice
any(sample(die, 2, replace=TRUE) %in% E)

mrolls = replicate(10, sample(die, 2, replace=TRUE))
even <- mrolls %in% E
anyeven <- colSums(even) > 0




cards <- paste(rep(c("A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2"), 4),
               rep(c("♠", "♣", "♥", "♦"), each=13))


cards <- 1:52

## Elevator waiting time
n <- 100
days <- runif(n, min=1, max=15)
event <- days < 13
sum(event) / n

A <- c(2, 2, 4, 4, 9, 9)
B <- c(1, 1, 6, 6, 8, 8)
C <- c(3, 3, 5, 5, 7, 7)

n <- 10
Ascore <-  sample(A, n, replace=TRUE)
Bscore <-  sample(B, n, replace=TRUE)
Cscore <-  sample(C, n, replace=TRUE)

AwinB <- Ascore > Bscore
BwinC <- Bscore > Cscore
CwinA <- Cscore > Ascore

sum(AwinB) / n

## Two Children Problem
gender <- c("boy", "girl")
family <- sample(gender, 2, replace=TRUE)
family

set.seed(1)
n <- 1000
families <- replicate(n, sample(gender, 2, replace=TRUE))
## families
## families[1,]
## families[2,]
firstgirl <- families[1,] == "girl"
## firstgirl
Jones <- families[,firstgirl]
mean(Jones[2,] == "girl")


secondgirl <- families[2,] == "girl"
withgirl <- firstgirl | secondgirl
Smith <- families[, withgirl]
ngirls = colSums(Smith == "girl")
mean(ngirls == 2)


firstgirl <- families[1,] == "girl"
Jones <- families[,firstgirl]
JonesGirls <- colSums(Jones == 'girl')
mean(JonesGirls == 2)

secondgirl <- families[2,] == "girl"

withgirl <- firstgirl | secondgirl
Smith <- families[,withgirl]

SmithGirls <- colSums(Smith == 'girl')
mean(SmithGirls == 2)

box1 <- c("G", "G")
box2 <- c("G", "S")
box3 <- c("S", "S")
boxes <- matrix(c(box1, box2, box3), nrow=2, ncol=3)
boxes
(boxid <- sample(1:3, 1))
(box <- boxes[,boxid])
(coin <- sample(box, 1))

bert <- function(boxes){
    boxid <- sample(1:3, 1)
    box <- boxes[,boxid]
    coin <- sample(box, 1)
    return(c(boxid, coin))
}

n <- 1000
games <- replicate(n, bert(boxes))
## games
goldcoin <- games[2,] == "G"
## goldcoin
observed <- games[,goldcoin]
mean(observed[1,] == "1")

boxes <- Matrix(box1, box2, box3)
box <- sample(boxes, 1)[[1]]
coin <- sample(box, 1)

## Monty Hall Problem
mont <-  function(){
    doors <- c("goat", "goat", "goat", "goat")
    car <- sample(1:4, 1)
    doors[car] <- "car"
    ## doors
    choice <- 1
    hostchoices <- setdiff(1:4, c(choice, car))
    if (length(hostchoices) == 1) {
        host <- hostchoices
    } else {
        host <- sample(hostchoices, 1)
    }
    return(c(host, car))
}

n <- 10000
games <- replicate(n, mont())
open3 <- games[1,] == 3
observed <- games[,open3]
(switch = mean(observed[2,] == 2))
(stick = mean(observed[2,] == 1))

## Birthday Problem

share <- function(npeople){
    room <- sample(1:365, npeople, replace=TRUE)
    length(unique(room)) < npeople
}

n = 10000
mean(replicate(n, share(25)))

same <- function(npeople, mybirthday){
    room <- sample(1:365, npeople, replace=TRUE)
    mybirthday %in% room
}

mean(replicate(n, same(25, 1)))


## Coupon Collector Problemyy
seatnext <- function(ns, np){
    (x <- sample(1:ns, np, replace=FALSE))
    sx <- sort(x)
    all(diff(sx) > 1)
}

ns <- 15
np <- 4
n <- 1000
mean(replicate(n, seatnext(ns, np)))

sort!(x)
minimum(diff(x)) <= 1
end

using Random, StatsBase
Random.seed!(1)
n = 100
l = 0
for i in 1:n
    x = sample(1:15, 4, replace=false)
    l += next(x)
end
l / n
