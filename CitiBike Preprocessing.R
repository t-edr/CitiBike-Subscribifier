#Used the following libraries.
library(NISTunits)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(tidyverse)

#import JC-202101-citibike-tripdata.csv

#Preprocessing 

#Create column of duration lengths of 5 minute increments. 
citi_jan$duration_length <- cut(citi_jan$trip_duration, breaks = c(0,300,600,900,1200,1500,1800,2100,2400,2700,3000,3300,3600,max(citi_jan$trip_duration, na.rm=T)), labels=c("0-5", "5-10", "10-15", "15-20", "20-25", "25-30", "30-35", "35-40", "40-45", "45-50", "50-55", "55-60", "60+")) 

#Calculate distance between longitude and latitude points using the Haversine formula function.
citi_jan$distance_miles <- haversine(citi_jan$start_station_latitude,citi_jan$end_station_latitude)

#Create column of approximate age group of 10 year increments. 
citi_jan$approx_age_group <- cut(citi_jan$birth_year, breaks = c(1930,1940, 1950,1960,1970,1980,1990,2000,2010,max(citi_jan$birth_year, na.rm=T)), labels=c("80-90", "70-80","60-70", "50-60", "40-50", "30-40", "20-30", "10-20", "<10"))

#Calculate trip duration in minutes.
citi_jan$duration_mins <- citi_jan$trip_duration/60

#Create column of day of the month in the citibike data.
citi_jan$day <- as.numeric(substr(citi_jan$start_time,9,10))

#Create column of day of the month in central park weather data.
central_park_weather_jan_21$day <- as.numeric(substr(central_park_weather_jan_21$date,9,10))

#Join citi_jan and central_park_weather_jan_21 datasets using the 'day' column.
citibike_weather <- merge(citi_jan, central_park_weather_jan_21, by="day")

#Create column to categorize duration length into three categories: short, medium, long. 
citibike_weather$duration_category <- cut(citibike_weather$duration_mins, breaks=c(0,15,45,max(citibike_weather$duration_mins, na.rm=T)), labels=c("short", "medium", "long"))

#Write citibike_weather dataframe to csv file.
write.csv(citibike_weather, 'citibike_jan_2021.csv')

#Note: All columns related to weather were later deleted after it was deemed unnecessary for the analysis.