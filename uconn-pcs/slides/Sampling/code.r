# Tanya
(5 + 6) / (11 + 9)

# Sonya
(3+9) / (7+14)

g <- 4
n <- 40
z <- rep(1:4, n)
x <- runif(n*g, 0, 2) + z
y <- 3 * z - x + rnorm(n*g)

plot(x, y, cex=1.5)
points(x, y, pch=z, col=z, cex=1.5)

set.seed(2024)
n <- 1000
book <- rnorm(n)
movie <- rnorm(n)
cor(book, movie)
plot(book, movie)
goodbook <- book > quantile(book, 0.9)
goodmovie <- movie > quantile(movie, 0.9)
good <- goodbook | goodmovie

points(book[good], movie[good], cex=1.5, col="red")
