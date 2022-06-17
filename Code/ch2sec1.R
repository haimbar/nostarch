
set.seed(220526)
x <- seq(0, 4 * pi, by=0.02)
g <- factor(rbinom(n=length(x), size=1, prob=0.5))
y <- 3 * (x > 2 * pi) * x + 4 * sin(3 * x) + 10 * (as.numeric(g) - 1) + rnorm(length(x), mean=0, sd=3)
yL <- y > 25
df1 <- data.frame(x, g, y, yL)
head(df1, 4)
summary(df1)

pdf("images/chapter_2/boxploty.pdf", width=4, height=4)
boxplot(y, axes=FALSE, border="purple", col="grey66")
axis(2)
dev.off()

pdf("images/chapter_2/histy.pdf", width=4, height=4)
hist(y, breaks=30, col="lightblue", border="blue", main="")
dev.off()

pdf("images/chapter_2/sidebysidebp.pdf", width=4, height=4)
boxplot(y ~ g, axes=FALSE, border=c("navyblue","darkgreen"), col=c("wheat1", "thistle1"), xlab="", ylim=c(min(y), max(y) * 1.1))
text(1:2, max(y) * 1.05, c("Group 1", "Group 2"), cex=0.6)
axis(2)
dev.off()

pdf("images/chapter_2/histoverlay.pdf", width=4, height=4)
hist(y[g==0], breaks=20, xlim=c(min(y), max(y)), col="orange", border="white", main="", xlab="y")
hist(y[g==1], breaks=20, xlim=c(min(y), max(y)), col="#00008090", border="grey66", add=TRUE)
dev.off()

pdf("images/chapter_2/scatter.pdf", width=4, height=4)
plot(x, y, pch=19, col="navyblue", cex=0.3, axes=FALSE)
axis(1)
axis(2)
dev.off()

pdf("images/chapter_2/scatter2.pdf", width=4, height=4)
cols <- ifelse(g==1, "navyblue", "orange")
plot(x, y, pch=19, col=cols, cex=0.3, axes=FALSE)
axis(1)
axis(2)
abline(h=30, lty=2, col="red", lwd=3)
dev.off()


x <- rpois(10000, 10)
xcat <- cut(x, breaks=c(0, 9, 12, 16, 25), include.lowest=TRUE)
table(xcat)


pdf("images/chapter_2/barplot.pdf", width=6, height=4)
barplot(table(xcat), col=c("lightblue", "wheat1", "thistle2", "paleturquoise"))
#pie(table(xcat),col=c("lightblue", "wheat1", "thistle2", "paleturquoise"))
dev.off()


y <- 30 + 4.5 * x -2 * (x - 15)^2 + rnorm(1000, 0, 10)
ycat <- cut(y, breaks=c(0, 30, 60, 100, 300))
ftable(xcat, ycat)

pdf("images/chapter_2/spineplot.pdf", width=5, height=5)
spineplot(ycat ~ xcat)
prop.table(ftable(ycat ~ xcat))
dev.off()

pdf("images/chapter_2/smooth.pdf", width=5, height=5)
x <- seq(-5, 5, length=100000)
y <- x^3 + rnorm(length(x), mean=0, sd=5)
#plot(x,y,cex=0.1)
smoothScatter(x, y, main="", nbin=50)
dev.off()
