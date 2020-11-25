## Exercise #7
## Elise Rust
## November 2020

#1.	Scrape the QBS webpage https://geiselmed.dartmouth.edu/qbs/2019-cohort/

install.packages("rjson")
install.packages("blsAPI")
library(rjson)
library(blsAPI)
library(rvest)
library(dplyr)

scraping_qbs <-  read_html("https://geiselmed.dartmouth.edu/qbs/2019-cohort/")
head(scraping_qbs)

names <- scraping_qbs %>% 
  html_nodes("div.threecol-one") %>% 
  html_text()

namesdf <- as.data.frame(names, na.rm = TRUE)

#clean up formatting before separating columns
namesdf$names <- gsub("BA","BA, ", namesdf$names, fixed=TRUE)
namesdf$names <- gsub("BS","BS, ", namesdf$names, fixed=TRUE)

namesdf$names <- gsub("USA","USA, ", namesdf$names, fixed=TRUE)
namesdf$names <- gsub("China","China, ", namesdf$names, fixed=TRUE)
namesdf$names <- gsub("Bachelor",", Bachelor", namesdf$names, fixed=TRUE)
namesdf$names <- gsub("("," ,", namesdf$names, fixed=TRUE)

#cluster languages into one string
namesdf$names[1] <- gsub("English, Spanish, Korean","English Spanish Korean", namesdf$names[1], fixed=TRUE)
namesdf$names[3] <- gsub("English,Chinese","English Chinese", namesdf$names[3], fixed=TRUE)
namesdf$names[6] <- gsub("English, Korean, Spanish","English Korean Spanish", namesdf$names[6], fixed=TRUE)
namesdf$names[9] <- gsub("English, Chinese Mandarin","English Chinese Mandarin", namesdf$names[9], fixed=TRUE)
namesdf$names[12] <- gsub("English, Chinese Mandarin","English Chinese Mandarin", namesdf$names[12], fixed=TRUE)
namesdf$names[14] <- gsub("English, Mandarin","English Mandarin", namesdf$names[14], fixed=TRUE)

# make individual changes to unique rows
namesdf$names[9] <- gsub("Lili  ,Oliver) Liu", "Lili (Oliver) Liu", namesdf$names[9], fixed=TRUE)

#separate columns
namesdf <- namesdf %>%
  separate(names, into = c("Name", "Degree", "Hometown", "State", "Country", "Languages", "Major", "College"), sep = ",")
 
# Edit outliers (2,3,5)
namesdf[2, ] = c("Alisha Bhimani", "BA", NA, NA, "USA", "English", NA, "College")
namesdf[3, ] = c("Mengdie Ge", "BA", NA, NA, "China", "English, Chinese", "Bachelor of Arts in Business Management", "Hainan University")
namesdf[5, ] = c("Alexander Ivanov", "BA", NA, NA, "USA", "English", NA, "Dartmouth College")

# remove blank rows
namesdf <- namesdf[-c(4, 8, 11, 15), ]  


## Question 2: obtain a web token from this url www.ncdc.noaa.gov/cdo-web/token and 
# obtain min and max temperature of closest station to WRIGHT PATTERSON AFB, OH US
install.packages("rnoaa")
library(rnoaa)
library(rjson)

key <- "JLcyXYtQRFHousWIAOyWqlsdyxxaSldE"
stations_Dayton <- ncdc_stations(datasetid='GHCND', 
                                 locationid='FIPS:39113',
                                 token = key)

stations_Dayton$data %>% 
  filter(name == "DAYTON INTERNATIONAL AIRPORT, OH US") %>% 
  select(mindate, maxdate, id)
# get station ID = 'GHCND:USW00093815'

# get climate data with station id, mindate, and maxdate from above
climate_Dayton <- ncdc(datasetid='GHCND', 
                startdate = '2015-01-01', 
                enddate = '2016-01-01', 
                stationid='GHCND:USW00093815',
                token = key)

max_temperature <- ncdc(datasetid='GHCND', 
             startdate = '2015-01-01', 
             enddate = '2015-12-31', 
             limit = 365,
             stationid='GHCND:USW00093815',
             datatypeid = 'TMAX',
             token = key)
min_temperature <- ncdc(datasetid='GHCND', 
                        startdate = '2015-01-01', 
                        enddate = '2015-12-31', 
                        limit = 365,
                        stationid='GHCND:USW00093815',
                        datatypeid = 'TMIN',
                        token = key)

# sort to determine the maximum and minimum temperature
max_temperature$data %>%
  arrange(desc(value))
min_temperature$data %>%
  arrange(value)




