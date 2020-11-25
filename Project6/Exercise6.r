## Elise Rust
## Exercise #6
## October 22 2020

rm(list = ls())

install.packages("odbc")
install.packages("RODBC")
install.packages("sqldf")
library(RODBC)
library(sqldf)
library(lubridate)
library(dplyr)

myconnection <- odbcConnect("dartmouth_qbs181", uid = "*****", pwd = "*********")

#1. In the Demographics table, find missing values with Age

demographics <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Demographics")
is.na(demographics$tri_age)
demographics$tri_age[is.na(demographics$tri_age)] <- mean(demographics$tri_age, na.rm = TRUE)

#2. In the Phonecall table, add a new column call end time and calculate the field
phonecall2 <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].PhoneCall")
 
phonecall2 %>%
  mutate(CallStartTime = as.POSIXct(as.Date(as.character(CallStartTime)),origin="2016-01-01")) %>%
  mutate(CallEndTime = CallStartTime + CallDuration)
  

#3. Using information in the Encounters, Procedure, Provider tables, answer the following questions
Encounters <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Encounters")
Procedure <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Procedure")
Provider <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Provider")

Table1 <- sqlQuery(myconnection, "select A.*, B.*, C.* from [qbs181].[dbo].Encounters A
                                inner join [qbs181].[dbo].Provider B
                                on A.NEW_VISIT_PROV_ID = B.NEW_PROV_ID
                                inner join [qbs181].[dbo].Procedure C
                                on A.NEW_VISIT_PROV_ID = C.PROV_ID")

## a) What kind of procedure did the patient have which had the maximum length of stay?
Table1 %>%
  mutate(NEW_HSP_ADMIT_DATE = as.POSIXct(as.Date(as.character(NEW_HSP_ADMIT_DATE)),origin="2016-01-01")) %>%
  mutate(LengthOfStay = NEW_HSP_DISCH_DATE - NEW_HSP_ADMIT_DATE)

Table1[which.max(Table1$LengthOfStay),]

## b) Provide top 5 providers who saw patients staying at teh hospital for the maximum # of days
Table1 <- sqlQuery(myconnection, "select A.*, B.* from [qbs181].[dbo].Encounters A
                                inner join [qbs181].[dbo].Provider B
                                on A.NEW_VISIT_PROV_ID = B.NEW_PROV_ID")

Table1 <- Table1 %>%
  mutate(NEW_HSP_ADMIT_DATE = as.POSIXct(NEW_HSP_ADMIT_DATE, origin="2016-01-01", tryFormats = c('%Y-%m-%d'))) %>%
  mutate(LengthOfStay = NEW_HSP_DISCH_DATE - NEW_HSP_ADMIT_DATE)
