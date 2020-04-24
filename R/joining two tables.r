##########################################################################
###This script will joint the Combined_Final and Target Variable Tables
#########################################################################

## load the packages

.libPaths("C:/Users/mlogan/Desktop/R_Packages")

library(tidyverse)
library(ggstance)
library(patchwork)
library(ggExtra)
library(e1071) ##for skewness
library(lubridate) ## for checking the dates
library(readxl)


## get the first file

response_var_table<-read_excel("C:/Users/mlogan/Desktop/Wei's Project/Response Variable/Response Variable Cleaned.xlsx", 
                        guess_max = 700000, na = c("N/A", "", "NA", "NULL", "<NA>" ))

## modify the date format

response_var_table<-response_var_table%>%mutate(EffDt = as.Date(EffDt, "%m/%d/%Y"))

summary(response_var_table)


## get the second file

ln_data<-read_csv("C:/Users/mlogan/Desktop/Wei's Project/Transformed Data/AI_Combined_File_Final_transformed2.csv", 
                  guess_max = 250000, na = c("N/A", "", "NA", "NULL", "<NA>" ))

summary(ln_data)

## let's try left join only on PolicyNumbers to create one-to-many match

table3<-left_join(response_var_table, ln_data , 
                  by = c("PolicyNumber" = "POLICYNUMBER"))

summary(table3)


write_csv(table3,"C:/Users/mlogan/Desktop/Wei's Project/Data and Response Combined/AI_Combined_File_Final_transformed2_response.csv")

