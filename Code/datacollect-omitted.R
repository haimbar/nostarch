set.seed(2027)

n <- 100
house_age <- seq(1:n)
house_distance <- 10/sqrt(house_age) - 0.5                # (@\wingding{1}@)
house_price <- 100 + 100*house_distance + rnorm(n, 0, 30) # (@\wingding{2}@)

pdf("images/chapter_6/omitted.pdf", width=4, height=4)
plot(sqrt(house_distance), house_price,
     ylim=c(0, max(house_price)),
     xlim=c(0,max(sqrt(house_distance))),
     axes=FALSE, pch=19, col="skyblue", cex=0.9,
     xlab="square(distance)", ylab="Price (in $1000)")
abline(lm(house_price ~ I(sqrt(house_distance))),         # (@\wingding{3}@)
       lwd=3, col="red", lty=2)
axis(1); axis(2)
dev.off()
