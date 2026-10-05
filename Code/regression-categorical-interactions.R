# Fit additive and interaction models with a categorical predictor.

set.seed(2026)
students <- data.frame(
  study_hours = runif(80, min = 1, max = 10),
  tutoring = factor(rep(c("no", "yes"), each = 40))
)
students$score <- with(
  students,
  55 + 3 * study_hours + 4 * (tutoring == "yes") +
    1.5 * study_hours * (tutoring == "yes") + rnorm(80, sd = 4)
)

#label===REGcategorical1
score_fit <- lm(score ~ study_hours + tutoring, data = students)
#===end

#label===REGinteraction1
score_interaction_fit <- lm(
  score ~ study_hours * tutoring,
  data = students
)
#===end
