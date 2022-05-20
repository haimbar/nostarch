set.seed(123)
birthday <- function(n=23, yours="1980-05-01"){
    # n is the number of people
    # yours is your birthday with format "year-mm-dd"
    N <- 365 # number of days each year
    room <- sample(1:N, size=n, replace=TRUE) # randomly choose n people
    doy <- as.numeric(strftime(yours, format="%j"))
    # convert the convert your birthday to day of year
    share <- length(unique(room)) < n
    ## if there are people sharing a common birthday
    same <- doy %in% room # if someone's birthday the same as yours
    return (c(share, same))
}

res <- replicate(n=1000, birthday(23))
prob.p23 <- rowMeans(res)

res <- replicate(n=1000, birthday(253))
prob.p253 <- rowMeans(res)
