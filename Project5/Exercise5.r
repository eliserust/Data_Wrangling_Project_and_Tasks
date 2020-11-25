## Elise Rust
## Exercise #4 QBS 181
## October 2020

#1) In the Flowsheet table, extract the cc/kg in disp_name and convert it to CC-Kg
rm(list = ls())

install.packages("odbc")
install.packages("RODBC")
install.packages("sqldf")
install.packages("tidyverse")
install.packages("splitstackshape")
library(splitstackshape)
library(tidyverse)
library(RODBC)
library(sqldf)
library(stringr)
myconnection <- odbcConnect("dartmouth_qbs181", uid = "*****", pwd = "*********")

Flowsheets <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Flowsheets")
head(Flowsheets)

#str_extract(Flowsheets$DISP_NAME, "cc/kg")
Flowsheets$DISP_NAME <- str_replace(Flowsheets$DISP_NAME, "cc/kg", "CC-Kg")
head(Flowsheets)

#2) In the flowsheets table, find any alphanumeric character and replace them with spaces

Flowsheets <- gsub(pattern = "[[:alnum:]]", replacement = " ", Flowsheets)
alphanumerics <- gsub(pattern = "[[:alnum:]]", replacement = " ", Flowsheets)

#3) In the Provider table, split and create a new column which reflects first and last names
# Extract all providers whose last names start with "Wa"

Provider <- sqlQuery(myconnection, "SELECT * FROM [qbs181].[dbo].Provider")
Provider <- cSplit(Provider, "NEW_PROV_NAME", sep = ",")
names(Provider)[2] <- "Last Name"
names(Provider)[3] <- "First Name"
str_extract_all(Provider$'Last Name', "^Wa")
