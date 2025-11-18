## generating a dataset for illustration
set.seed(123)

n_fam <- 10
fam_size <- 4

# latent probabilities to create clustering
p_fam <- runif(n_fam, 0.1, 0.7)

id <- rep(1:n_fam, each = fam_size)
symptom <- unlist(lapply(p_fam, function(p) rbinom(fam_size, 1, p)))

dat <- data.frame(family = id, symptom = symptom)

#label===dataHead
head(dat)
#===end

# Function to compute the test statistic
#label===familyStat
# Compute number of concordant affected (1–1) pairs across families
family_stat <- function(id, symptom) {
  total_pairs <- 0
  fam_ids <- unique(id)

  for (f in fam_ids) {
    fam_sym <- symptom[id == f]
    k <- sum(fam_sym == 1)
    # add number of concordant pairs
    if (k >= 2) {
      total_pairs <- total_pairs + k * (k - 1) / 2
    }
  }

  total_pairs
}
#===end


# Function to approximate permutation p-value
#label===familyPvalue
perm_pvalue <- function(id, symptom, B = 10000) {
  # observed statistic
  obs <- family_stat(id, symptom)

  # permutation distribution
  perm_stats <- numeric(B)
  for (b in 1:B) {
    perm_symptom <- sample(symptom)   # shuffle symptoms
    perm_stats[b] <- family_stat(id, perm_symptom)
  }

  # approximate p-value
  c(statistic = obs, pvalue = mean(perm_stats >= obs))
}
#===end

# Application to simulated data
#label===application
# compute p-value of observed statistic
obs_stat <- family_stat(dat$id, dat$symptom)
obs_stat
#===end
