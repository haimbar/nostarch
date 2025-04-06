set.seed(2021)
pdf("images/chapter_6/berkson1.pdf", width=4, height=4)
n  <- 1000
book  <- rnorm(n)                       # (@\wingding{1}@)
movie <- rnorm(n)                       # (@\wingding{2}@)
plot(book, movie, pch=19, cex=0.5, col="grey33", axes=FALSE)
abline(lm(movie~book), lwd=3, col=2)
axis(1); axis(2)
dev.off()

pdf("images/chapter_6/berkson2.pdf", width=4, height=4)
good.b <- book > quantile(book, 0.9)    # (@\wingding{3}@)
good.m <- movie > quantile(movie, 0.9)  # (@\wingding{4}@)
good  <- good.b | good.m                # (@\wingding{5}@)
plot(book[good], movie[good], pch=19, cex=0.5, 
     col="grey33", axes=FALSE)
abline(lm(movie[good] ~ book[good]), lwd=3, col=2)
axis(1); axis(2)
dev.off()

cat("Correlation between all books and movies:", cor(book, movie), "\n")
cat("Correlation between good books and good movies:", cor(book[good], movie[good]), "\n")
