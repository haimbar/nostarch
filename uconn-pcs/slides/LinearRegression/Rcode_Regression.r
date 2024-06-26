## explore the correlation
set.seed(1)
n <- 100
x <- rnorm(n)
err <- rnorm(n)
y <- 100 * x + err
cor(x, y)

plot(x, y)
## plot(x, y, main=paste("r =",cor(x, y)))

## non linear relationship 
face = read.csv("face.csv")
head(face)
x <- face$x
y <- face$y
cor(x, y)

plot(x, y)

## Bload pressure data
dat <- read.table("systolic.txt", header=T)
## read data into R
n <- dim(dat)[1]
## get the sample size
age <- dat$AGE
sbp <- dat$SBP

## Let's plot the data to explore the relationship
plot(age, sbp, cex=3)

cor(age, sbp)

fit <- lm(sbp ~ age)
abline(fit)
summary(fit)
coef(fit)

fit$fitted.values
plot(sbp, fit$fitted.values)
abline(a=0, b=1)

## idx <- which(sbp < 200)
## plot(age[idx], sbp[idx])
## cor(age[idx], sbp[idx])

## body fat data
bodyfat <- read.csv("bodyfat.csv")
names(bodyfat)
## read data into R
n <- dim(bodyfat)[1]
## get the sample size
fit <- lm(BodyFat ~ Age + Weight + Chest + Wrist + BMI, data=bodyfat)
coef(fit)
plot(bodyfat$BodyFat, fit$fitted.values)

## correctness vs usefullness
set.seed(1)
n <- 100
x <- rnorm(n)
err <- rnorm(n)
y <- 2 + 4 * x + x^2 +  err
cor(x, y)

plot(x, y)
fit <- lm(y ~ x)
abline(fit)

plot(y, fit$fitted.values)
abline(a=0, b=1)

x2 <- x^2
fit <- lm(y ~ x + x2)
plot(y, fit$fitted.values)
abline(a=0, b=1)

## set.seed(1)
## n <- 10
## x <- rnorm(n)
## a <- 2
## y <- 1 + a * x + rnorm(n)
## plot(x, y, main=paste("r =",cor(x, y)))
## fit <- lm(y ~ x)
## coef(fit)
## abline(fit)

## sim <- function(n){
##     x <- rnorm(n)
##     a <- 2
##     y <- 2 + a * x + (rchisq(n, 1) - 1)
##     fit <- lm(y ~ x)
##     coef(fit)
## }
## set.seed(1)
## n <- 1000
## rep <- 1000
## res <- replicate(rep, sim(n))

## hist(res[1,])
## hist(res[2,])

## rowMeans(res)

## qqnorm(res[1,])
