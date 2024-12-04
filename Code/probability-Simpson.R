#label===PRsimpson1
set.seed(123)
g <- 4                           # (@\wingding{1}@)
n <- 40                          # (@\wingding{2}@)
z <- rep(1:g, each = n)          # (@\wingding{3}@)
x <- runif(n * g, 0, 2) + z      # (@\wingding{4}@)
y <- 3 * z - x + rnorm(n * g)    # (@\wingding{5}@)
#===end


pdf("images/chapter_3/probability-Simpson-plots.pdf", height=3.5, width=3.5*1.5)
#label===PRsimpson2
plot(x, y, pch=19, col=4, cex=0.9)       # (@\wingding{6}@)
abline(lm(y ~ x), lwd=3, col="navyblue") # (@\wingding{7}@)
#===end

#label===PRsimpson3
plot(x, y, pch = z, col = z)                                  # (@\wingding{8}@)
for (grp in 1:g)                                              # (@\wingding{9}@)
    abline(lm(y[z==grp] ~ x[z==grp]), lwd=3, col=grp, lty=2)  # (@\wingding{10}@)
#===end
dev.off()
