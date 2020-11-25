## Elise Rust
## QBS 181 Data Wrangling
## Midterm
## October 2020

rm(list = ls())

install.packages("SASxport") library(SASxport) library(haven) library(magrittr)
setwd("//mac/Home/Desktop/Papers/Dartmouth/Senior Year/Fall 20/Data Wrangling")

## import dataset into R data("Alfalfa") lookup.xport("DIQ_I.XPT") diabetes <- read.xport("DIQ_I.XPT") head(diabetes)
write.csv(diabetes,'diabetes.csv')

## pull dataset back in from ODBC driver in SQL install.packages("odbc") install.packages("RODBC") install.packages("sqldf")
library(RODBC) library(sqldf)
myconnection <- odbcConnect("dartmouth_qbs181", uid = "erust", pwd = "erust@qbs181") diabetes1 <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[erust].diabetes")

## explore dataset for null values, data types, etc.
str(diabetes)

# data types appear to be correct. All columns are integer types except for DIQ291 (Last A1c level) which is correctly a numerical type
is.na(diabetes)
sum(is.na(diabetes))

#[1] 441440
colSums(is.na(diabetes))

# search for non-alphanumeric characters grep(pattern = "[[:alnum:]]", diabetes, value = TRUE) 
# Dataset doesn't have any.

## Perform Data Cleanup
## fix null values
## perform a mean imputation on select columns where the mean provides valuable information diabetes$DID040[is.na(diabetes$DID040)] <- mean(diabetes$DID040, na.rm = TRUE) #age when diagnosed diabetes$DID060[is.na(diabetes$DID060)] <- median(diabetes$DID060, na.rm = TRUE) #time taking insulin diabetes$DIQ230[is.na(diabetes$DIQ230)] <- mean(diabetes$DIQ230, na.rm = TRUE)#time since seeing a specialist diabetes$DID250[is.na(diabetes$DID250)] <- mean(diabetes$DID250, na.rm = TRUE) #times seeing a doctor this year diabetes$DID260[is.na(diabetes$DID260)] <- mean(diabetes$DID260, na.rm = TRUE) #frequency of checking blood sugar
diabetes$DIQ280[is.na(diabetes$DIQ280)] <- mean(diabetes$DIQ280[diabetes$DIQ280 < 20], na.rm = TRUE) #average A1C level among those measured
diabetes$DIQ300S[is.na(diabetes$DIQ300S)] <- mean(diabetes$DIQ300S[diabetes$DIQ300S < 202], na.rm = TRUE) #average SBP level diabetes$DIQ300D[is.na(diabetes$DIQ300D)] <- mean(diabetes$DIQ300D[diabetes$DIQ300D < 252], na.rm = TRUE) #average DBP level
diabetes$DID320[is.na(diabetes$DID320)] <- mean(diabetes$DID320[diabetes$DID320 < 521], na.rm = TRUE) #average LDL level diabetes$DID341[is.na(diabetes$DID341)] <- mean(diabetes$DID341[diabetes$DID341 < 35], na.rm = TRUE) #average number of times Dr checked feet
diabetes$DID350[is.na(diabetes$DID350)] <- mean(diabetes$DID350[diabetes$DID350 < 21], na.rm = TRUE) #avg numer of tiems patient checked feet

## replace all remaining "NA" with "." in all columns to match codebook diabetes <- diabetes %>%
replace(is.na(diabetes), ".")

## add new columns diabetes <- diabetes %>%
mutate(DIQ159 = case_when(
DIQ175C < 12 & DIQ010 == 1 ~ "GO TO DIQ050", DIQ175C >= 12 & DIQ010 ==31 ~ "GO TO DIQ170", TRUE ~ "CONTINUE"
)) %>%
mutate(DIQ065 = case_when(
DIQ010 == 12 | DIQ010 == 3 | DIQ160 == 1 ~ "CONTINUE", TRUE ~ "GO TO END OF SECTION"

)) %>%
mutate(DIQ229 = case_when(
DIQ160 == 1 | DIQ010 == 3 ~ "CONTINUE",
TRUE ~ "GO TO END OF SECTION" )) %>%
mutate(DIQ295 = case_when(
DIQ175C < 12 ~ "END OF SECTION", TRUE ~ "CONTINUE"
)) %>%
mutate(DIQ060_Units = case_when(
DIQ060U == 1 ~"Months", DIQ060U == 2 ~"Years", TRUE ~ "Missing"
)) %>%
mutate(DIQ260_Units = case_when(
DIQ260U == 1 ~"Per day", DIQ260U == 2 ~"Per week", DIQ260U == 3 ~"Per month", DIQ260U == 4 ~"Per year", TRUE ~ "Missing"
)) %>%
mutate(DIQ350_Units = case_when(
DIQ350U == 1 ~"Per day", DIQ350U == 2 ~"Per week", DIQ350U == 3 ~"Per month", DIQ350U == 4 ~"Per year", TRUE ~ "Missing"
))

# rename columns
diabetes$SEQN <- rename(diabetes$SEQN = "sequence number") diabetes %>%
rename(
SequenceNumber = SEQN
)

# convert datatypes from character to integer. This is demonstrational. diabetes <- diabetes %>%
mutate_all(funs(type.convert(as.integer(replace(., .=='NULL', NA)))))

#counts of columns count(diabetes, vars = DIQ010)
counts <- diabetes %>% group_by(DIQ010::DIQ229) %>% summarise(count=n())
