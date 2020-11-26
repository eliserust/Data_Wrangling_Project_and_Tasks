## Elise Rust
## QBS 181 - Data Wrangling
## November 2020
## Final Exam

library(tidyverse)
library(dplyr)
library(lubridate)

# 1)	Consider the following blood pressure dataset (IC_BP_v2.csv). Perform the following operations
blood_pressure <- read.csv(file.choose(), stringsAsFactors = FALSE)

# a.	Convert BP alerts to BP status
blood_pressure <- blood_pressure %>%
  rename(BPStatus = BPAlerts)

sample_n(blood_pressure, 10)

# b.	Define Hypo-1 & Normal as Controlled blood pressure; Hypo-2, HTN1, HTN2 & HTN3 as Uncontrolled 
#     blood pressure: Controlled & Uncontrolled blood pressure as 1 or 0 (Dichotomous Outcomes) 
blood_pressure <- blood_pressure %>%
  mutate(Status_Type = case_when(
    BPStatus == "Hypo1" ~ "Controlled",
    BPStatus == "Normal" ~ "Controlled", 
    BPStatus == "Hypo2" ~ "Uncontrolled",
    BPStatus == "HTN1" ~ "Uncontrolled", 
    BPStatus == "HTN2" ~ "Uncontrolled", 
    BPStatus == "HTN3" ~ "Uncontrolled", 
  )) %>%
  mutate(Outcomes = case_when(
    Status_Type == "Controlled" ~ 1,
    Status_Type == "Uncontrolled" ~ 0
  ))

sample_n(blood_pressure, 10)

# c.	Merge this table with demographics (SQL table) to obtain their enrollment dates
install.packages("odbc")
install.packages("RODBC")
install.packages("sqldf")
library(RODBC)
library(sqldf)

myconnection <- odbcConnect("dartmouth_qbs181", uid = "****", pwd = "*********")

demo <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Demographics")

demo <- demo %>%
  rename(ID = contactid)

bp_demo <- merge(blood_pressure, demo, by = "ID")

sample_n(bp_demo, 10)

# d: Create a 12-week interval of averaged scores of each customer 
## ObservedTime is days since 1st January 1900, with the fraction as the portion of a day. Converted to datetime in SQL and imported back into R.
bp_sql <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[erust].IC_BP_v2")

## now with a time component, narrow down these mean scores within a 12 week interval
Mean_Systolic <- bp_sql %>%
  group_by(ID) %>%
  mutate(earliest_date = min(ObservedDate)) %>%
  mutate(date_12 = earliest_date + (12*7*24*60*60)) %>% #number of seconds in 12 weeks
  filter(ObservedDate >= earliest_date, ObservedDate <= date_12) %>%
  summarize(Mean_Systolic = mean(SystolicValue, na.rm=TRUE))

Mean_Diastolic <- bp_sql %>%
  group_by(ID) %>%
  mutate(earliest_date = min(ObservedDate)) %>%
  mutate(date_12 = earliest_date + (12*7*24*60*60)) %>% #number of seconds in 12 weeks
  filter(ObservedDate >= earliest_date, ObservedDate <= date_12) %>%
  summarize(Mean_Diastolic = mean(Diastolicvalue, na.rm=TRUE))
  
Mean_Scores <- merge(Mean_Systolic, Mean_Diastolic)
sample_n(Mean_Scores, 10)

# e: Compare the scores from baseline (first week) to follow-up scores (12 weeks)
Week1 <- bp_sql %>%
  group_by(ID) %>%
  filter(ObservedDate == min(ObservedDate)) %>%
  mutate(week1_systolic = SystolicValue) %>%
  mutate(week1_diastolic = Diastolicvalue)

Week12 <- bp_sql %>%
  group_by(ID) %>%
  filter(ObservedDate == min(ObservedDate) + (12*7*24*60*60)) %>%
  mutate(week12_systolic = SystolicValue) %>%
  mutate(week12_diastolic = Diastolicvalue)

Week1vs12 <- merge(Week1, Week12, by="ID")
Week1vs12 <- Week1vs12 %>%
  group_by(ID) %>%
  mutate(Sys_Diff = week12_systolic - week1_systolic) %>%
  mutate(Dias_Diff = week12_diastolic - week1_diastolic)

Week1vs12 %>%
  select(ID, ObservedTime.x, week1_systolic, week12_systolic, week1_diastolic, week12_diastolic, Sys_Diff, Dias_Diff) %>%
  sample_n(10)
  
#f: How many customers were brought from uncontrolled regime to controlled regime after 12 weeks of intervention?
bp_sql_new <- bp_sql_new %>%
  mutate(Status_Type = case_when(
    BPAlerts == "Hypo1" ~ "Controlled",
    BPAlerts == "Normal" ~ "Controlled", 
    BPAlerts == "Hypo2" ~ "Uncontrolled",
    BPAlerts == "HTN1" ~ "Uncontrolled", 
    BPAlerts == "HTN2" ~ "Uncontrolled", 
    BPAlerts == "HTN3" ~ "Uncontrolled", 
  )) %>%
  mutate(Outcomes = case_when(
    Status_Type == "Controlled" ~ 1,
    Status_Type == "Uncontrolled" ~ 0
  ))

# isolate regimes at baseline and then after 12 weeks.
initial_regime <- bp_sql_new %>%
  group_by(ID) %>%
  filter(ObservedDate == min(ObservedDate)) %>%
  mutate(initial_bp = Outcomes)
outcome_regime <- bp_sql_new %>%
  group_by(ID) %>%
  filter(ObservedDate == date_12) %>%
  mutate(outcome_bp = Outcomes)

regime <- merge(initial_regime,outcome_regime, by = "ID")
regime <- regime %>%
  mutate(change = initial_bp - outcome_bp)

length(regime$change[regime$change == "-1"])

## Question 2: Merge the tables Demographics, Conditions, and TextMessages
Dem_Conditions_Texts <- sqlQuery(myconnection, "select A.*, B.*, C.* from [qbs181].[dbo].Demographics A
                                inner join [qbs181].[dbo].Conditions B
                                on A.contactid = B.tri_patientid
                                inner join [qbs181].[dbo].Text C
                                on A.contactid = C.tri_contactid")

# obtain the final dataset such that we have 1 row per ID by choosing on the latest date when the text was sent
Dem_Conditions_Texts <- Dem_Conditions_Texts %>% 
  group_by(contactid) %>%
  filter(TextSentDate==max(TextSentDate))

slice_sample(Dem_Conditions_Texts, n = 10)
