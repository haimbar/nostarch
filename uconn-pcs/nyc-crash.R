## NYC MVC Crash data from NYC open data:
## https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95

## This is a subset from January 2022
crash <- read.csv("https://github.com/statds/ids-s22/raw/main/notes/data/nyc_mv_collisions_202201.csv")

## what variables are in the dataset
names(crash)

## frequency table by borough
xtabs(~ BOROUGH, data = crash)

## Create a hour variable with integer values from 0 to 23
crash$hour <- as.numeric(sub(":[0-9][0-9]", "", crash$CRASH.TIME))

table(crash$hour)
hist(crash$hour, breaks=24)
