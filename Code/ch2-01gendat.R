set.seed(220526)
x <- seq(0, 4 * pi, by=0.02)
g <- factor(rbinom(n=length(x), size=1, prob=0.5))
y <- 3 * (x > 2 * pi) * x + 4 * sin(3 * x) + 10 * (as.numeric(g) - 1) +
    rnorm(length(x), mean=0, sd=3)
yL <- y > 25
df1 <- data.frame(x, g, y, yL)
head(df1, 4)
summary(df1)
