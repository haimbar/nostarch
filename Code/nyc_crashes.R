############################################################
## R script for NYC Labor Day Week 2025 crash case study
## Base R only, plus the sf package (installed by bookinit.R) for the
## borough basemap in Figure 9-4, built from NYC Open Data's official
## Borough Boundaries (Data/nyc_borough_boundaries.geojson). No
## tidyverse.
############################################################

library(sf)

############################################################
#label===read
df <- read.csv("Data/nyc_crashes_lbdwk_2025.csv",
               stringsAsFactors = FALSE)
#===end


############################################################
#label===inspect
str(df)                             # structure of df
(raw_nrow <- nrow(df))              # number of rows of df
(raw_ncol <- ncol(df))              # number of columns of df
(raw_names_head <- head(names(df))) # first few variable names of df
#===end


############################################################
#label===rename_build
old_names <- names(df)
new_names <- tolower(old_names)          # force to lower cases
new_names <- gsub("\\.", "_", new_names) # replace . with _
#===end


############################################################
#label===rename_apply
names(df) <- new_names
(renamed_head <- head(names(df)))
#===end


############################################################
#label===dates_convert
df$crash_date_date <- as.Date(df$crash_date, format = "%m/%d/%Y")
#===end


############################################################
#label===dates_check
(raw_min_date <- min(df$crash_date_date, na.rm = TRUE))
(raw_max_date <- max(df$crash_date_date, na.rm = TRUE))
(raw_date_table <- table(df$crash_date_date))
#===end


############################################################
#label===filter_week
week_start <- as.Date("2025-08-31")
week_end <- as.Date("2025-09-06")

in_week <- (df$crash_date_date >= week_start) &
           (df$crash_date_date <= week_end)
#===end


############################################################
#label===filter_apply
(rows_before_filter <- nrow(df))
(rows_in_week <- sum(in_week, na.rm = TRUE))

df <- df[in_week, ]

(filtered_min_date <- min(df$crash_date_date, na.rm = TRUE))
(filtered_max_date <- max(df$crash_date_date, na.rm = TRUE))
#===end


############################################################
#label===location_preview
(location_preview <- head(df[, c("location", "latitude", "longitude")]))
#===end


############################################################
#label===location_unique
(location_unique_n <- length(unique(df$location)))
(location_missing_n <- sum(is.na(df$location) | df$location == ""))
#===end


############################################################
#label===id_check
## COLLISION_ID should uniquely identify each crash record.
length(unique(df$collision_id))
nrow(df)
any(duplicated(df$collision_id))
#===end


############################################################
#label===location_drop
## The location column is a text version of latitude and longitude.
## We drop it now and clean the numeric coordinates in the next section.
df$location <- NULL
#===end


############################################################
#label===borough_clean
df$borough <- trimws(df$borough)
df$borough[df$borough == ""] <- NA
#===end


############################################################
#label===zip_clean
if (is.numeric(df$zip_code)) {
  df$zip_code[df$zip_code == 0] <- NA
}
#===end


############################################################
#label===missing_counts
sum(is.na(df$borough))
sum(is.na(df$zip_code))

both_missing <- is.na(df$borough) & is.na(df$zip_code)
sum(both_missing)

## Cross-tabulation: do missing borough and missing zip code co-occur?
table(borough_missing = is.na(df$borough),
      zip_missing = is.na(df$zip_code))
#===end


############################################################
#label===geo_bad
bad_geo <- (df$latitude <= 0) |
           (df$longitude >= 0) |
           (df$latitude < 40) |
           (df$latitude > 41) |
           (df$longitude < -75) |
           (df$longitude > -73)

sum(bad_geo, na.rm = TRUE)
#===end


############################################################
#label===geo_recode
df$latitude[bad_geo] <- NA
df$longitude[bad_geo] <- NA

geo_missing <- is.na(df$latitude) | is.na(df$longitude)
sum(geo_missing)
#===end


############################################################
#label===fillable_make
zip_missing <- is.na(df$zip_code)
geo_present <- !is.na(df$latitude) & !is.na(df$longitude)

df$fillable_zip <- geo_present & zip_missing
#===end


############################################################
#label===weekday
df$weekday <- factor(weekdays(df$crash_date_date),
                     levels = c("Sunday", "Monday", "Tuesday",
                                "Wednesday", "Thursday",
                                "Friday", "Saturday"))
#===end


############################################################
#label===fillable_table
table(df$weekday, df$fillable_zip)

prop_fillable_zip <- tapply(df$fillable_zip,
                            df$weekday,
                            mean)
prop_fillable_zip
#===end


############################################################
#label===datetime_make
datetime_str <- paste(df$crash_date, df$crash_time)

df$datetime <- as.POSIXct(datetime_str,
                          format = "%m/%d/%Y %H:%M")
#===end


############################################################
#label===hour_make
df$hour <- as.integer(format(df$datetime, "%H"))
df$minute <- as.integer(format(df$datetime, "%M"))
#===end


############################################################
#label===hour_table
tab_hour_borough <- table(df$hour, df$borough)
tab_hour_borough
#===end


############################################################
pdf("images/chapter_9/crashes_by_hour.pdf",
    width = 7, height = 4.5)

#label===hour_plot
borough_cols <- c("darkorange", "steelblue", "seagreen",
                  "orchid", "gray50")

barplot(t(tab_hour_borough),
        col = borough_cols,
        border = NA,
        xlab = "Hour of day",
        ylab = "Number of crashes")

legend("topleft",
       legend = colnames(tab_hour_borough),
       fill = borough_cols,
       bty = "n",
       cex = 0.8)
#===end

dev.off()


############################################################
#label===rounded_times
sum(df$hour == 0, na.rm = TRUE)
sum(df$minute == 0, na.rm = TRUE)
mean(df$minute == 0, na.rm = TRUE)
sum(df$hour == 0 & df$minute == 0, na.rm = TRUE)
#===end


############################################################
#label===hour_corrected_make
## Reassign exact-midnight crashes uniformly for comparison.
mid_idx <- df$hour == 0 & df$minute == 0
n_midnight <- sum(mid_idx)

set.seed(20250901)
df$hour_corrected <- df$hour
df$hour_corrected[mid_idx] <- sample(0:23, n_midnight, replace = TRUE)

tab_hour_total <- table(df$hour)
tab_hour_corrected <- table(df$hour_corrected)

## Preserve borough breakdown by reassigning within each borough.
df$hour_corrected_borough <- df$hour
for (b in unique(df$borough[!is.na(df$borough)])) {
  idx <- which(df$borough == b & mid_idx)
  if (length(idx)) {
    df$hour_corrected_borough[idx] <- sample(0:23, length(idx),
                                              replace = TRUE)
  }
}

tab_hour_borough_total <- table(df$hour, df$borough)
tab_hour_borough_corrected <- table(df$hour_corrected_borough, df$borough)
#===end


############################################################
#label===midnight_by_borough
## Does the exact-midnight rate vary by borough?
exact_midnight <- df$hour == 0 & df$minute == 0
midnight_by_borough <- tapply(exact_midnight, df$borough, sum,
                              na.rm = TRUE)
total_by_borough <- table(df$borough)
midnight_rate_by_borough <- midnight_by_borough / total_by_borough

midnight_by_borough
total_by_borough
round(midnight_rate_by_borough, 3)
#===end


############################################################
pdf("images/chapter_9/crashes_by_hour_corrected.pdf",
    width = 10, height = 4.5)

#label===hour_corrected_plot
borough_cols <- c("darkorange", "steelblue", "seagreen",
                  "orchid", "gray50")

par(mfrow = c(1, 2))

barplot(t(tab_hour_borough_total),
        col = borough_cols,
        border = NA,
        xlab = "Hour of day",
        ylab = "Number of crashes",
        main = "Original hours")

barplot(t(tab_hour_borough_corrected),
        col = borough_cols,
        border = NA,
        xlab = "Hour of day",
        ylab = "Number of crashes",
        main = "Midnight crashes reassigned within borough")

legend("topleft",
       legend = colnames(tab_hour_borough_total),
       fill = borough_cols,
       bty = "n",
       cex = 0.8)
#===end

dev.off()


############################################################
#label===business_make
df$business_day <- !(df$weekday %in% c("Saturday", "Sunday"))
#===end


############################################################
#label===business_table
day_type <- factor(df$business_day, levels = c(FALSE, TRUE),
                   labels = c("Weekend", "Business day"))
tab_bd_borough <- table(day_type, df$borough)
tab_bd_borough
#===end


############################################################
pdf("images/chapter_9/crashes_by_day_type.pdf",
    width = 6.5, height = 4.5)

#label===business_plot
barplot(t(tab_bd_borough),
        beside = TRUE,
        col = c("darkorange", "steelblue", "seagreen",
                "orchid", "gray50"),
        border = NA,
        names.arg = c("Weekend", "Business day"),
        xlab = "Day type",
        ylab = "Number of crashes")

legend("topleft",
       legend = colnames(tab_bd_borough),
       fill = c("darkorange", "steelblue", "seagreen",
                "orchid", "gray50"),
       bty = "n",
       cex = 0.8)
#===end

dev.off()


############################################################
#label===business_ratio
## Ratio of business-day crashes to weekend crashes, per borough.
ratio_bd_weekend <- tab_bd_borough["Business day", ] /
  tab_bd_borough["Weekend", ]
round(ratio_bd_weekend, 2)
#===end


############################################################
#label===business_hours_make
df$business_hours <- (df$hour >= 7) & (df$hour < 19)
#===end


############################################################
#label===business_hours_table
hours_type <- factor(df$business_hours, levels = c(FALSE, TRUE),
                     labels = c("Outside business hours", "Business hours"))
tab_bh_borough <- table(hours_type, df$borough)
tab_bh_borough

prop_bh_borough <- prop.table(tab_bh_borough, margin = 2)
round(prop_bh_borough, 3)
#===end


############################################################
#label===injury_consistency
## Check whether total injured/killed match the sum of subcategories.
inj_cols <- c("number_of_pedestrians_injured",
              "number_of_cyclist_injured",
              "number_of_motorist_injured")
kill_cols <- c("number_of_pedestrians_killed",
               "number_of_cyclist_killed",
               "number_of_motorist_killed")
df$injured_sum <- rowSums(df[, inj_cols])
df$killed_sum <- rowSums(df[, kill_cols])

sum(df$number_of_persons_injured != df$injured_sum, na.rm = TRUE)
sum(df$number_of_persons_killed != df$killed_sum, na.rm = TRUE)
#===end


############################################################
#label===severity_make
df$severe <- (df$number_of_persons_injured > 0) |
             (df$number_of_persons_killed > 0)
#===end


############################################################
#label===severity_rate
sum(df$severe, na.rm = TRUE)
mean(df$severe, na.rm = TRUE)
#===end


############################################################
pdf("images/chapter_9/severity_locations.pdf",
    width = 9, height = 4.8)

#label===severity_map
## Load the city's official borough boundaries (NYC Open Data) so the
## crash locations can be read against real coastlines, not a blank
## grid.
boroughs <- st_read("Data/nyc_borough_boundaries.geojson", quiet = TRUE)

## Correct for the longitude/latitude scale mismatch at this latitude,
## so the maps are not visibly stretched.
map_asp <- 1 / cos(mean(df$latitude, na.rm = TRUE) * pi / 180)
lon_range <- range(df$longitude, na.rm = TRUE)
lat_range <- range(df$latitude, na.rm = TRUE)

par(mfrow = c(1, 2))

plot(NA, xlim = lon_range, ylim = lat_range, asp = map_asp,
     xlab = "Longitude", ylab = "Latitude", main = "Not severe")
rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4],
     col = "lightsteelblue1", border = NA)
plot(st_geometry(boroughs), add = TRUE, col = "gray95",
     border = "gray60")
points(df$longitude[!df$severe], df$latitude[!df$severe],
       col = "gray40", pch = 19, cex = 0.45)
box()

plot(NA, xlim = lon_range, ylim = lat_range, asp = map_asp,
     xlab = "Longitude", ylab = "Latitude", main = "Severe")
rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4],
     col = "lightsteelblue1", border = NA)
plot(st_geometry(boroughs), add = TRUE, col = "gray95",
     border = "gray60")
points(df$longitude[df$severe], df$latitude[df$severe],
       col = "firebrick", pch = 19, cex = 0.45)
box()
#===end

dev.off()


############################################################
#label===vehicle_columns
veh_cols <- grep("^vehicle_type_code_", names(df), value = TRUE)
veh_cols
#===end


############################################################
#label===vehicle_count
vehicle_entries <- df[veh_cols]
vehicle_entries[] <- lapply(vehicle_entries, trimws)
vehicle_entries[vehicle_entries == ""] <- NA

df$n_vehicles <- rowSums(!is.na(vehicle_entries))
table(df$n_vehicles)
#===end


############################################################
#label===severity_by_vehicle
severe_label <- factor(df$severe, levels = c(FALSE, TRUE),
                       labels = c("Not severe", "Severe"))
tab_severe_veh <- table(severe_label, df$n_vehicles)
tab_severe_veh

prop_severe_by_veh <- prop.table(tab_severe_veh, margin = 2)
prop_severe_by_veh
#===end


############################################################
pdf("images/chapter_9/severity_by_vehicle_count.pdf",
    width = 6, height = 4)

#label===severity_by_vehicle_plot
barplot(prop_severe_by_veh["Severe", ],
        col = "lightblue",
        border = NA,
        ylim = c(0, 1),
        xlab = "Number of vehicles",
        ylab = "Proportion severe")

abline(h = mean(df$severe, na.rm = TRUE),
       lty = 2,
       col = "gray33")
#===end

dev.off()


############################################################
#label===severity_inference_table
## 2x2 table of severe crashes by day type
tab_business_severe <- table(df$business_day, df$severe)
tab_business_severe
#===end

############################################################
#label===severity_chisq
## Pearson chi-squared test for business day and severity.
chisq_business_severe <- chisq.test(tab_business_severe)
chisq_business_severe
#===end

############################################################
#label===severity_binom_table
## Overall counts used for binomial test
severity_counts <- table(df$severe)
severity_counts
#===end

############################################################
#label===severity_glm_prep
## Prepare data for logistic regression: select predictors and drop missing
pred_cols <- c("severe", "business_day", "n_vehicles", "borough")
sev_model_data <- df[, pred_cols]
sev_model_data <- sev_model_data[complete.cases(sev_model_data), ]
## Quick summary of the model data
summary(sev_model_data)
#===end

############################################################
#label===severity_glm_fit
## Fit logistic regression: severe ~ business_day + n_vehicles
## Use the prepared dataset to avoid missing-data surprises
fit_severe <- glm(severe ~ business_day + n_vehicles,
                  data = sev_model_data,
                  family = binomial)
capture.output(summary(fit_severe), file = "generated/nyc-glm-fit.tex")
#===end

############################################################
#label===severity_glm_or
## Show odds ratios and Wald 95% confidence intervals for interpretation
coef_est <- coef(summary(fit_severe))
or <- exp(coef(fit_severe))
wald_ci <- exp(confint.default(fit_severe))
capture.output(
  cbind(Estimate = coef(fit_severe),
        OR = or,
        "2.5%" = wald_ci[, 1],
        "97.5%" = wald_ci[, 2]),
  file = "generated/nyc-glm-or.tex"
)
#===end

############################################################
#label===severity_glm_diag
## Simple diagnostics: fitted probabilities and deviance residuals
fitted_prob <- predict(fit_severe, type = "response")
resid_dev <- residuals(fit_severe, type = "deviance")
capture.output(summary(fitted_prob), file = "generated/nyc-glm-fitted.tex")
capture.output(summary(resid_dev), file = "generated/nyc-glm-resid.tex")
#===end

############################################################
#label===nyc-severity-inference
## Master chunk to recompute inference objects for inline R.
## Recompute table, chi-squared, rate, exact CI, and model fit.
tab_business_severe <- table(df$business_day, df$severe)
chisq_business_severe <- chisq.test(tab_business_severe)
severity_counts <- table(df$severe)
severe_rate <- mean(df$severe, na.rm = TRUE)
severe_rate_ci <- binom.test(sum(df$severe, na.rm = TRUE), nrow(df))
if (!exists("sev_model_data")) {
  pred_cols <- c("severe", "business_day", "n_vehicles", "borough")
  sev_model_data <- df[, pred_cols]
  sev_model_data <- sev_model_data[complete.cases(sev_model_data), ]
}
fit_severe <- glm(severe ~ business_day + n_vehicles,
                  data = sev_model_data,
                  family = binomial)
#===end


############################################################
#label===severe_by_hour
tab_severe_hour <- table(df$severe, df$hour)
tab_severe_hour

prop_severe_by_hour <- prop.table(tab_severe_hour, margin = 2)
prop_severe_by_hour
#===end


############################################################
pdf("images/chapter_9/severity_by_hour.pdf",
    width = 7, height = 4)

#label===severe_by_hour_plot
plot(as.integer(colnames(prop_severe_by_hour)),
     prop_severe_by_hour["TRUE", ],
     type = "o",
     pch = 19,
     col = "firebrick",
     xlab = "Hour of day",
     ylab = "Proportion severe",
     ylim = c(0, 1))

abline(h = mean(df$severe, na.rm = TRUE),
       lty = 2,
       col = "gray40")
#===end

dev.off()


############################################################
#label===severity_score
df$severity_score <- df$number_of_persons_injured +
                     5 * df$number_of_persons_killed
#===end


############################################################
#label===top_severe
ord <- order(df$severity_score, decreasing = TRUE, na.last = NA)

top10 <- df[ord[1:10], c("crash_date", "crash_time", "borough",
                         "zip_code", "latitude", "longitude",
                         "number_of_persons_injured",
                         "number_of_persons_killed",
                         "severity_score")]
names(top10)[names(top10) == "number_of_persons_injured"] <- "injured"
names(top10)[names(top10) == "number_of_persons_killed"] <- "killed"
names(top10)[names(top10) == "severity_score"] <- "score"

top10
#===end


############################################################
#label===factor_clean
cf1_raw <- df$contributing_factor_vehicle_1
cf1_clean <- tolower(trimws(cf1_raw))

cf1_clean[cf1_clean == ""] <- NA
cf1_clean[cf1_clean == "unspecified"] <- NA
#===end


############################################################
#label===factor_table
cf1_table <- sort(table(cf1_clean), decreasing = TRUE)
cf1_table

head(cf1_table, 5)
#===end


############################################################
pdf("images/chapter_9/top_contributing_factors.pdf",
    width = 8.5, height = 4.5)

par(mar = c(5, 8, 1, 1))

#label===factor_plot
top_factors <- head(cf1_table, 8)
top_factor_counts <- as.numeric(top_factors)
factor_labels <- c(
  "driver inattention/distraction" = "Inattention",
  "following too closely" = "Following too closely",
  "failure to yield right-of-way" = "Failure to yield",
  "unsafe speed" = "Unsafe speed",
  "passing or lane usage improper" = "Lane use improper",
  "backing unsafely" = "Backing unsafely",
  "driver inexperience" = "Driver inexperience",
  "passing too closely" = "Passing too closely")
names(top_factor_counts) <- factor_labels[names(top_factors)]

barplot(rev(top_factor_counts),
        horiz = TRUE,
        las = 1,
        cex.names = 0.85,
        col = "steelblue",
        border = NA,
        xlab = "Number of crashes")
#===end

dev.off()


############################################################
#label===vehicle_type_clean
vt1 <- trimws(df$vehicle_type_code_1)
vt2 <- trimws(df$vehicle_type_code_2)

## Blank entries and the one "unknown" value are treated as missing.
vt1[tolower(vt1) %in% c("", "unknown")] <- NA
vt2[tolower(vt2) %in% c("", "unknown")] <- NA
#===end


############################################################
#label===vehicle_type_table
vt1_table <- sort(table(vt1), decreasing = TRUE)
vt2_table <- sort(table(vt2), decreasing = TRUE)

head(vt1_table, 10)
head(vt2_table, 10)
#===end


############################################################
pdf("images/chapter_9/top_vehicle_types.pdf",
    width = 8.5, height = 4.5)

par(mar = c(5, 8, 1, 1))

#label===vehicle_type_plot
top_vehicle_types <- head(vt1_table, 8)
top_vehicle_counts <- as.numeric(top_vehicle_types)
vehicle_labels <- c(
  "Sedan" = "Sedan",
  "Station Wagon/Sport Utility Vehicle" = "SUV/station wagon",
  "Taxi" = "Taxi",
  "Bike" = "Bike",
  "Motorcycle" = "Motorcycle",
  "Pick-up Truck" = "Pick-up truck",
  "Bus" = "Bus",
  "Box Truck" = "Box truck")
names(top_vehicle_counts) <- vehicle_labels[names(top_vehicle_types)]

barplot(rev(top_vehicle_counts),
        horiz = TRUE,
        las = 1,
        cex.names = 0.85,
        col = "seagreen",
        border = NA,
        xlab = "Number of crashes")
#===end

dev.off()


############################################################
#label===publisher_summary
## Summary statistics for the recommendations section.
on_hour <- df$minute == 0
n_exact_midnight <- sum(df$hour == 0 & on_hour, na.rm = TRUE)
n_on_hour <- sum(on_hour, na.rm = TRUE)
prop_on_hour <- mean(on_hour, na.rm = TRUE)
n_both_missing <- sum(is.na(df$borough) & is.na(df$zip_code),
                      na.rm = TRUE)

inj_mismatch <- df$number_of_persons_injured != df$injured_sum
n_injury_mismatch <- sum(inj_mismatch, na.rm = TRUE)

cf1_raw <- tolower(trimws(df$contributing_factor_vehicle_1))
n_unspecified <- sum(cf1_raw == "unspecified", na.rm = TRUE)
#===end


############################################################
#label===master
## To reproduce the analysis in the chapter:
## 1. Set the working directory to the project root.
## 2. Run this file from top to bottom in R.
## 3. Each labeled chunk matches one code snippet in the text.
#===end
