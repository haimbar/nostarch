## roll a die
die <- 1:6
n <- 1000
set.seed(1)
rolls <- sample(die, n, replace = TRUE)
E = c(2, 4, 6)
even <- rolls %in% E
sum(even) / n

## Elevator waiting time
set.seed(1)
n <- 1000
days <- runif(n, min=1, max=15)
## cat(days <- runif(n, min=1, max=15))
event <- days < 13
sum(event) / n
12 / 14

## Intransitive Dice
A <- c(2, 2, 4, 4, 9, 9)
B <- c(1, 1, 6, 6, 8, 8)
C <- c(3, 3, 5, 5, 7, 7)

set.seed(1)
n <- 1000
Ascore <- sample(A, n, replace = TRUE)
Bscore <- sample(B, n, replace = TRUE)
Cscore <- sample(C, n, replace = TRUE)
AwinB <- Ascore > Bscore
BwinC <- Bscore > Cscore
CwinA <- Cscore > Ascore
sum(AwinB) / n # mean(AwinB)
sum(BwinC) / n
sum(CwinA) / n

## Two Children Problem
gender <- c("boy", "girl")
family <- sample(gender, 2, replace=TRUE)

set.seed(1)
n <- 1000
families <- replicate(n,
                      sample(gender, 2, replace=TRUE)
                      )
firstgirl <- families[1,] == "girl"
Jones <- families[,firstgirl]
JonesGirls <- colSums(Jones == 'girl')
mean(JonesGirls == 2)

secondgirl <- families[2,] == "girl"

withgirl <- firstgirl | secondgirl
Smith <- families[,withgirl]

SmithGirls <- colSums(Smith == 'girl')
mean(SmithGirls == 2)

## Bertrand’s Box
boxes <- matrix(
    c("G", "G", "G", "S", "S", "S"),
      nrow=2, ncol=3)

bert <- function(boxes){
    boxid <- sample(1:3, 1)
    box <- boxes[,boxid]
    coin <- sample(box, 1)
    return(c(boxid, coin)) 
}

bert(boxes)

n <- 1000
set.seed(1)
games <- replicate(n, bert(boxes))
godcoin <- games[2,] == "G"
godcoingames <- games[,godcoin]
mean(godcoingames[1,] == "1")

## Monty Hall problem
choice <- 3

mont <- function(choice){
    car <- sample(1:3, 1)
    if (choice == car){
        host <- sample((1:3)[-c(choice)], 1)
    } else {
        host <- (1:3)[-c(choice, car)]
    }
    return(c(car, host))
}

mont(choice)

set.seed(1)
n <- 1000
result <- replicate(n, mont(choice))
open2 <- result[2,] == 2
open2games <- result[,open2]
mean(open2games[1,] == 1)

## Birthday Problem
share <- function(){
    room <- sample(1:365, 23, replace = TRUE)
    length(unique(room)) < 23
}

n <- 1000
set.seed(1)
res <- replicate(n, share())
mean(res)

same <- function(){
    room <- sample(1:365, 23, replace = TRUE)
    1 %in% room
}

n <- 1000
set.seed(1)
res <- replicate(n, same())
mean(res)
