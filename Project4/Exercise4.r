# Exercise #4 QBS 181
# October 8th, 2020

install.packages("stringr")
library(stringr)

#1: Connect to SQL database and extract data from DX table. Make all the entries in disp_Name to a lowercase
myconnection <- odbcConnect("dartmouth_qbs181", uid = "****", pwd = "**********")

DX <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].DX")
head(DX)

DX$DX_NAME <- tolower(DX$DX_NAME)
DX

#2: Remove any commas and whitespace

DX$DX_NAME <- str_remove_all(DX$DX_NAME, ",")
DX$DX_NAME <- str_trim(DX$DX_NAME, side=c("both"))

#3: Merge Inpatient and Outpatient tables based on NEW_PATIENT_DHMC_MRN by removing
#   any hyphens

inpatient <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Inpatient")
outpatient <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Outpatient")

inpatient$NEW_PATIENT_DHMC_MRN <- str_remove_all(inpatient$NEW_PATIENT_DHMC_MRN, "-")
outpatient$NEW_PATIENT_DHMC_MRN <- str_remove_all(outpatient$NEW_PATIENT_DHMC_MRN, "-")  

in_outpatient <- merge(inpatient, outpatient, by="NEW_PATIENT_DHMC_MRN")

#4: Do you see the same distinct NEW_PATIENT_DHMC_MRN when merged on NEW_PAT_ID?
inpatient$NEW_PAT_ID <- toupper(inpatient$NEW_PAT_ID)
in_outpatient1 <- merge(inpatient, outpatient, by="NEW_PAT_ID")
