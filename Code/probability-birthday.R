set.seed(123)
birthday <- function(n=23, yours="1980-05-01"){
## Define a function to simlate the birthday problem:
## n is the number of people on the bus;
## yours is your birthday in format "year-mm-dd".
    N <- 365 # number of days each year
    bus <- sample(1:N, size=n, replace=TRUE) # randomly choose n people
    ## convert your birthday to date of year
    doy <- as.numeric(strftime(yours, format="%j"))
    ## if someone's birthday is the same as yours
    same <- doy %in% bus
    ## if there are people sharing a common birthday
    share <- length(unique(bus)) < n
    return (c(same, share))
}
## bus with 23 people
res <- replicate(n=1000, birthday(23))
prob.p23 <- rowMeans(res)
## plane with 253 people
res <- replicate(n=1000, birthday(253))
prob.p253 <- rowMeans(res)

birthday <- function(n=23, yours="1980-05-01"){
    N <- 10^6
    bus <- sample(1:N, size=n, replace=TRUE) # randomly choose n people
    doy <- as.numeric(strftime(yours, format="%j"))
    same <- doy %in% bus
    share <- length(unique(bus)) < n
    return (c(same, share))
}

res <- replicate(n=1000, birthday(1000))
rowMeans(res)
