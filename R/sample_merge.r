##########################################################################
###This script will attempt to join two sample files using one to many join
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

policy_term<-read_excel("C:/Users/mlogan/Desktop/try1.xlsx", 
                      guess_max = 12, na = c("N/A", "", "NA", "NULL", "<NA>" ))

## modify the date format

policy_term<-policy_term%>%mutate(EffDt = as.Date(EffDt, "%m/%d/%Y"))

summary(policy_term)


## get the second file

ln_data<-read_csv("C:/Users/mlogan/Desktop/sample_merge.csv", 
         guess_max = 15, na = c("N/A", "", "NA", "NULL", "<NA>" ))

summary(ln_data)

## play around with joining the two
## both files have PolicyNumber, EffDt and Mod

table1<-merge(x = ln_data, y = policy_term, 
      by.x = c("POLICYNUMBER", "EFFDT", "MOD"), by.y = c("PolicyNumber", "EffDt","Mod" ), 
      all = T)

table2<-merge(x = ln_data, y = policy_term, 
              by.x = c("POLICYNUMBER", "EFFDT", "MOD"), by.y = c("PolicyNumber", "EffDt","Mod" ), 
              all.x = T)


## let's try left join only on PolicyNumbers to create one-to-many match

table3<-left_join(policy_term, ln_data , 
by = c("PolicyNumber" = "POLICYNUMBER"))


write_csv(table3,"C:/Users/mlogan/Desktop/sample_merge_results.csv")












