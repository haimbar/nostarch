## Calculate the sum of all the integers from 1 to 100
#label===loop-demo-for
## Using a for loop:
total <- 0 # (@\wingding{1}@)
for (i in 1:100) { # (@\wingding{2}@)
  total <- total + i # (@\wingding{3}@)
}
cat("Total: ", total, "\n")
#===end

#label===loop-demo-while
## Using a while loop:
total <- 0
i <- 1 # (@\wingding{1}@)
while (i <= 100) { # (@\wingding{2}@)
  total <- total + i
  i <- i + 1 # (@\wingding{3}@)
}
cat("Total: ", total, "\n")
#===end

#label===demoivre-for
## Approximate the area under f(x) = exp(-x^2/2) using 50 subintervals:
a <- -6
b <- 6
n <- 50
h <- (b - a) / n # (@\wingding{1}@)
area <- 0
for (i in 0:(n - 1)) { # (@\wingding{2}@)
  x <- a + i * h
  area <- area + exp(-x^2 / 2) * h # (@\wingding{3}@)
}
cat("Approximate area:", round(area, 6), "\n")
cat("True value sqrt(2*pi):", round(sqrt(2 * pi), 6), "\n")
#===end

#label===demoivre-while
## Refine the approximation until successive estimates agree to 1e-6:
h <- 1.0
area <- 0
area_prev <- Inf # (@\wingding{1}@)
while (abs(area - area_prev) > 1e-6) { # (@\wingding{2}@)
  area_prev <- area
  area <- 0
  x <- -6
  while (x < 6) {
    area <- area + exp(-x^2 / 2) * h
    x <- x + h
  }
  h <- h / 2 # (@\wingding{3}@)
}
if (abs(area - sqrt(2 * pi)) < 0.01) { # (@\wingding{4}@)
  cat("Converged: area =", round(area, 6), "\n")
} else {
  cat("Did not converge\n")
}
#===end
