############################################################
# R script for NYC Labor Day Week 2025 crash case study
# Base R only. No tidyverse.
# Each labeled chunk can be referenced in the book text.
############################################################

############################################################
#label===read
# This chunk goes with the "Importing the data" section.
# It reads the raw CSV file into R.
#===

# Read the crash data from the CSV file.
# Adjust the path "data/nyc_crashes_lbdwk_2025.csv" if needed.
df <- read.csv("data/nyc_crashes_lbdwk_2025.csv",
               stringsAsFactors = FALSE)

# Take a quick look at the structure.
str(df)
#===end


############################################################
#label===rename
# This chunk appears right after reading the data.
# It cleans variable names: lower case and underscores.
#===

old_names <- names(df)

# Convert to lower case
new_names <- tolower(old_names)

# Replace spaces and periods with underscores
new_names <- gsub(" ", "_", new_names)
new_names <- gsub("\\.", "_", new_names)

# Apply cleaned names
names(df) <- new_names

# Optional: check the first few variable names
head(names(df))
#===end


############################################################
#label===time_window
# This chunk goes in the section that checks the time frame.
# It inspects the range of crash dates in the raw data.
#===

# Convert crash_date to Date
df$crash_date_date <- as.Date(df$crash_date,
                              format = "%m/%d/%Y")

# Inspect the earliest and latest dates in the raw file
min(df$crash_date_date, na.rm = TRUE)
max(df$crash_date_date, na.rm = TRUE)

# Count how many distinct dates are present
table(df$crash_date_date)
#===end


############################################################
#label===filter_week
# This chunk belongs in the "Are all observations in the
# target week?" part.
# It filters to the Sunday–Saturday week of Labor Day 2025:
# Sunday Aug 31, 2025 to Saturday Sep 6, 2025.
#===

week_start <- as.Date("2025-08-31")  # Sunday
week_end   <- as.Date("2025-09-06")  # Saturday

# Logical indicator for rows in the target week
in_week <- (df$crash_date_date >= week_start) &
           (df$crash_date_date <= week_end)

# Number of rows before and after filtering
nrow(df)
sum(in_week, na.rm = TRUE)

# Keep only crashes in the target week
df <- df[in_week, ]

# Check the date range again after filtering
min(df$crash_date_date, na.rm = TRUE)
max(df$crash_date_date, na.rm = TRUE)
#===end


############################################################
#label===location_check
# This chunk fits the question about the `location` variable.
# It compares `location` with latitude/longitude.
#===

# Look at a few rows of location and coordinates
head(df[, c("location", "latitude", "longitude")])

# Optionally check how many unique location strings there are
length(unique(df$location))

# Simple check: does location look like "(lat, lon)"?
# You can examine the pattern in the text output and
# discuss whether it is redundant with latitude/longitude.
#===end


############################################################
#label===missing_borough_zip
# This chunk belongs in the missing-values section.
# It identifies borough values that should be NA and inspects
# joint missingness of borough and zip_code.
#===

# Clean borough: trim whitespace
df$borough <- trimws(df$borough)

# Treat empty strings as missing borough
df$borough[df$borough == ""] <- NA

# If desired, also treat specific codes as NA, e.g.:
# df$borough[df$borough %in% c("Unspecified", "UNKNOWN")] <- NA

# Zip code may be numeric; if so, 0 can be recoded to NA.
# (If it is character in your file, adjust accordingly.)
if (is.numeric(df$zip_code)) {
  df$zip_code[df$zip_code == 0] <- NA
}

# Count missing borough and missing zip
sum(is.na(df$borough))
sum(is.na(df$zip_code))

# Count rows where both borough and zip_code are missing
both_missing <- is.na(df$borough) & is.na(df$zip_code)
sum(both_missing)

# You can print a small sample of those rows if needed
# df[both_missing, c("crash_date", "crash_time",
#                    "borough", "zip_code")][1:10, ]
#===end


############################################################
#label===missing_geo
# This chunk also belongs in the missing-values section.
# It identifies unreasonable geocodes and recodes them to NA.
#===

# Copy original coordinates (optional)
# lat_orig <- df$latitude
# lon_orig <- df$longitude

# Define a simple rule for unreasonable geocodes:
# - latitude <= 0 or longitude >= 0 (e.g., (0,0))
# - or coordinates outside a broad NYC bounding box
bad_geo <- (df$latitude <= 0) |
           (df$longitude >= 0) |
           (df$latitude < 40) |
           (df$latitude > 41) |
           (df$longitude < -75) |
           (df$longitude > -73)

# Recode unreasonable coordinates as missing
df$latitude[bad_geo]  <- NA
df$longitude[bad_geo] <- NA

# Count records with missing geocode (either lat or lon missing)
geo_missing <- is.na(df$latitude) | is.na(df$longitude)
sum(geo_missing)

# Optionally inspect a few of them
# df[geo_missing, c("crash_date", "crash_time",
#                   "borough", "zip_code",
#                   "latitude", "longitude")][1:10, ]
#===end


############################################################
#label===fillable_zip
# This chunk answers the question about fillable_zip.
# It creates a logical variable indicating where a zip code
# could be filled in from existing geocodes and compares
# rates across days of the week.
#===

# A zip is missing if zip_code is NA
zip_missing <- is.na(df$zip_code)

# A geocode is present if both latitude and longitude are not NA
geo_present <- !is.na(df$latitude) & !is.na(df$longitude)

# fillable_zip is TRUE when geocode present but zip missing
df$fillable_zip <- geo_present & zip_missing

# Day of week as a factor (Sunday, Monday, ...)
df$weekday <- factor(weekdays(df$crash_date_date),
                     levels = c("Sunday", "Monday", "Tuesday",
                                "Wednesday", "Thursday",
                                "Friday", "Saturday"))

# Table of fillable_zip by weekday
table(df$weekday, df$fillable_zip)

# Proportion of fillable_zip by weekday
prop_fillable_zip <- tapply(df$fillable_zip,
                            df$weekday,
                            mean)
prop_fillable_zip
#===end


############################################################
#label===hour
# This chunk belongs in the "Data exploration" section.
# It creates an `hour` variable and examines hourly patterns.
#===

# Combine date and time strings into a POSIXct datetime
datetime_str <- paste(df$crash_date, df$crash_time)
df$datetime <- as.POSIXct(datetime_str,
                          format = "%m/%d/%Y %H:%M")

# Extract hour (0–23) and minute (0–59)
df$hour   <- as.integer(format(df$datetime, "%H"))
df$minute <- as.integer(format(df$datetime, "%M"))

# Count crashes by hour and borough
tab_hour_borough <- table(df$hour, df$borough)
tab_hour_borough

# Simple plot: crashes by hour for each borough (stacked)
# (In the book, you may prefer a nicer plot, but this is
# enough for a basic base-R barplot.)
if (interactive()) {
  barplot(tab_hour_borough,
          beside = FALSE,
          legend.text = TRUE,
          xlab = "Hour of day",
          ylab = "Number of crashes",
          main = "NYC crashes by hour and borough")
}

# Number of crashes at exactly midnight (hour == 0)
sum(df$hour == 0, na.rm = TRUE)

# Number of crashes at whole hours (minute == 0)
sum(df$minute == 0, na.rm = TRUE)
#===end


############################################################
#label===business_day
# This chunk continues the data exploration.
# It creates a business_day indicator and summarizes
# crashes by business_day and borough.
#===

# Define business days: Monday–Friday
df$business_day <- !(df$weekday %in% c("Saturday", "Sunday"))

# Table of crashes by business_day and borough
tab_bd_borough <- table(df$business_day, df$borough)
tab_bd_borough

# Simple barplot: crashes by business_day and borough
if (interactive()) {
  barplot(tab_bd_borough,
          beside = TRUE,
          legend.text = TRUE,
          names.arg = c("Non-business day", "Business day"),
          xlab = "Day type",
          ylab = "Number of crashes",
          main = "Crashes by business-day status and borough")
}
#===end


############################################################
#label===severity
# This chunk belongs in the "Severity analysis" section.
# It defines a logical severe indicator and examines counts.
#===

# A crash is severe if at least one person is injured or killed
df$severe <- (df$number_of_persons_injured > 0) |
             (df$number_of_persons_killed   > 0)

# Number of severe crashes
sum(df$severe, na.rm = TRUE)

# Proportion of severe crashes
mean(df$severe, na.rm = TRUE)
#===end


############################################################
#label===vehcount
# This chunk counts the number of vehicles involved in each crash.
# It then constructs a contingency table of severe by n_vehicles.
#===

# Identify the vehicle_type_code columns
veh_cols <- grep("^vehicle_type_code_", names(df), value = TRUE)

# Count how many vehicle_type_code fields are non-missing
df$n_vehicles <- rowSums(!is.na(df[veh_cols]))

# Inspect the distribution of n_vehicles
table(df$n_vehicles)

# Contingency table of severe by n_vehicles
tab_severe_veh <- table(df$severe, df$n_vehicles)
tab_severe_veh

# Optional: proportions of severe within each vehicle count
prop_severe_by_veh <- prop.table(tab_severe_veh, margin = 2)
prop_severe_by_veh
#===end


############################################################
#label===severe_by_hour
# This chunk constructs a contingency table of severe by hour.
#===

# Contingency table of severe (rows) by hour (columns)
tab_severe_hour <- table(df$severe, df$hour)
tab_severe_hour

# Optional: proportion of severe crashes within each hour
prop_severe_by_hour <- prop.table(tab_severe_hour, margin = 2)
prop_severe_by_hour
#===end


############################################################
#label===top_severe
# This chunk identifies the top 10 severe crashes and can be
# used for a discussion on geographic clustering.
#===

# Define a simple severity score:
# each injury counts as 1, each fatality counts as 5
df$severity_score <- df$number_of_persons_injured +
                     5 * df$number_of_persons_killed

# Order crashes from most to least severe
ord <- order(df$severity_score, decreasing = TRUE,
             na.last = NA)

# Extract the top 10 severe crashes
top10 <- df[ord[1:10],
            c("crash_date", "crash_time", "borough",
              "zip_code", "latitude", "longitude",
              "number_of_persons_injured",
              "number_of_persons_killed",
              "severity_score")]

top10

# For clustering discussion, you might inspect their
# locations visually in a map outside of this script.
#===end


############################################################
#label===contrib_factors
# This chunk belongs to the "Contributing factors" section.
# It examines contributing_factor_vehicle_1, normalizes case,
# and identifies the most common factors.
#===

# Extract raw contributing factors for vehicle 1
cf1_raw <- df$contributing_factor_vehicle_1

# Make a cleaned version: lower-case and trimmed
cf1_clean <- tolower(trimws(cf1_raw))

# Decide which values to treat as NA
# e.g., empty strings, "unspecified", "unknown"
cf1_clean[cf1_clean == ""] <- NA
cf1_clean[cf1_clean %in% c("unspecified",
                           "unknown",
                           "other vehicular")] <- NA

# Frequency table of cleaned contributing factors
cf1_table <- sort(table(cf1_clean), decreasing = TRUE)
cf1_table

# Top five contributing factors
head(cf1_table, 5)

# You can compare cf1_raw vs cf1_clean if you want to
# illustrate the effect of cleaning.
#===end


############################################################
#label===veh_types
# This chunk examines the most frequent vehicle categories
# for vehicle 1 and vehicle 2.
#===

# Vehicle type columns for vehicle 1 and 2
vt1 <- df$vehicle_type_code_1
vt2 <- df$vehicle_type_code_2

# Clean by trimming whitespace
vt1 <- trimws(vt1)
vt2 <- trimws(vt2)

# Optionally set empty strings to NA
vt1[vt1 == ""] <- NA
vt2[vt2 == ""] <- NA

# Frequency tables
vt1_table <- sort(table(vt1), decreasing = TRUE)
vt2_table <- sort(table(vt2), decreasing = TRUE)

# Most common vehicle categories (top 10 shown)
head(vt1_table, 10)
head(vt2_table, 10)

# You can discuss whether the most frequent types
# match what you expect for NYC traffic.
#===end


############################################################
#label===master
# This final chunk is not meant to appear in the text.
# It simply reminds the reader that running this script
# from top to bottom reproduces all objects used in the
# chapter figures and tables.
#===

# To reproduce the analysis in the chapter:
# 1. Set the working directory so that "data/nyc_crashes_lbdwk_2025.csv"
#    is found correctly.
# 2. Run this file from top to bottom in R.
# 3. Each labeled chunk corresponds to a code snippet in the text.
#===end
