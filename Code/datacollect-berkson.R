set.seed(2021)
pdf("images/chapter_6/berkson1.pdf", width=4, height=4)
n  <- 1000
book  <- rnorm(n)
movie <- rnorm(n)
plot(book, movie) # plot all the books and movies
abline(lm(movie~book))
dev.off()

pdf("images/chapter_6/berkson2.pdf", width=4, height=4)
good.b <- book > quantile(book, 0.9)
good.m <- movie > quantile(movie, 0.9)
good  <- good.b | good.m
plot(book[good], movie[good]) # plot only the good books or good movies
abline(lm(movie[good]~book[good]))
dev.off()

cat("Correlation between all books and movies:",
    cor(book, movie), "\n")
cat("Correlation between good books and good movies:",
    cor(book[good], movie[good]), "\n")
