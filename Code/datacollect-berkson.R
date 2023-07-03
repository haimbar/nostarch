set.seed(2021)
pdf("images/chapter_6/berkson1.pdf", width=4, height=4)
n  <- 1000              # total number of books and movies
book  <- rnorm(n)       # all the n books
movie <- rnorm(n)       # all the n movies
plot(book, movie)       # plot all the books and movies
abline(lm(movie~book))  # relation between all books and movies
dev.off()

pdf("images/chapter_6/berkson2.pdf", width=4, height=4)
good.b <- book > quantile(book, 0.9)   # indicator of good books
good.m <- movie > quantile(movie, 0.9) # indicator of good movies
good  <- good.b | good.m      # indicator of good books or movies
plot(book[good], movie[good]) # plot only the good books or good movies
## relation between good books or good movies
abline(lm(movie[good]~book[good]))
dev.off()

cat("Correlation between all books and movies:",
    cor(book, movie), "\n")
cat("Correlation between good books and good movies:",
    cor(book[good], movie[good]), "\n")
