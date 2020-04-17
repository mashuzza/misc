##########################################################################
###This script will make transformation to the Combinef Final Data file
### and will save the changes as a new csv file
#########################################################################

## load the packages

.libPaths("C:/Users/mlogan/Desktop/R_Packages")

library(tidyverse)
library(ggstance)
library(patchwork)
library(ggExtra)
library(e1071) ##for skewness
library(lubridate) ## for checking the dates

### get the file

sample_data<-read_csv("C:/Users/mlogan/Desktop/Wei's Project/LN Data/AI_Combined_File_Final.csv", 
                      guess_max = 264164, na = c("N/A", "", "NA", "NULL", "<NA>" ))

summary(sample_data[, 1:10])

## create a copy of the dataset
dr_data<-sample_data

## make some changes

dr_data<-dr_data%>%mutate(EP = as.numeric(str_replace_all(EP, c('\\)'= '', '\\(' = '-', ','= '', ' ' = ''))),
                          INC_LOSS = as.numeric(str_replace_all(INC_LOSS, c('\\)'= '', '\\(' = '-', ','= '', ' ' = ''))),
                          CLAIMCOUNT = as.numeric(str_replace_all(CLAIMCOUNT, c('-'= '0.00'))),
                          ZIP = as.character(ZIP),
                          EFFDT = as.Date(EFFDT, "%m/%d/%Y"),
                          LITINDICATOR = as.numeric(LITINDICATOR) )


### convert characters to factors

dt<-sapply(dr_data, typeof) ## extract types of data from our sample
char_names<-names(which(dt == "character")) ## see what are characters

## also see that everything that starts with "src_" gets converted to char as well

src_names<-grep("^src", names(dr_data), value=TRUE)

## get all description names for later use
desc_names <- grep("_desc", names(dr_data), value=TRUE)

dr_data[src_names]<-lapply(dr_data[src_names], as.character)


var_types<-sapply(dr_data, class)
var_types<-as.data.frame(var_types)


# make rownames to be the first column 

var_types<-rownames_to_column(var_types)
var_types<-var_types%>%arrange(var_types)

## check that variable types match

var_types%>%group_by(var_types)%>%count()%>%arrange(n) %>%ungroup

summary(dr_data)
str(dr_data)


# summary by 20 variables

summary(dr_data[, 1:20])
summary(dr_data[, 21:40])
summary(dr_data[, 41:60])
summary(dr_data[, 61:80])
summary(dr_data[, 81:100])

summary(dr_data[, 101:120])
summary(dr_data[, 121:140])
summary(dr_data[, 141:160])
summary(dr_data[, 161:180])
summary(dr_data[, 181:200])

summary(dr_data[, 201:210])

## let's make a few changes 

## remove multiple policies, keeping max MOD ones only

dr_data_trans<-dr_data%>%
  group_by(POLICYNUMBER)%>%
  filter(MOD == max(MOD)) %>% ungroup()

## remove extra variables: all src, all desc


dr_data_trans1<-dr_data_trans%>% select (- src_names, -desc_names, - EFF_MY, - LN_seqnum,
                                        - ZIP4, - property_street_address, - property_city_state_zip)

## let's look at numerical variables

dr_data_trans1%>%select(POLICYNUMBER,building_square_footage)%>% 
  mutate(building_square_footage1 = 
                          replace(building_square_footage, 
                                  building_square_footage <400 | building_square_footage > 12000, 
                                  median(building_square_footage, na.rm = T))) %>% 
  filter (building_square_footage <400 | building_square_footage > 12000) %>% print(n = 1000)


dr_data_trans2<-dr_data_trans1%>% 
  mutate(building_square_footage = 
           replace(building_square_footage, 
                   building_square_footage <400 | building_square_footage > 12000, 
                   median(building_square_footage, na.rm = T)),
         first_floor_sqr_footage = 
           replace(first_floor_sqr_footage,
                   first_floor_sqr_footage <300| first_floor_sqr_footage > 12000,
                   median(first_floor_sqr_footage, na.rm = T)),
         basement_square_footage = 
           replace(basement_square_footage,
                   basement_square_footage <200| basement_square_footage > 12000,
                   median(basement_square_footage, na.rm = T)),
         garage_square_footage = 
           replace(garage_square_footage,
                   garage_square_footage <200| garage_square_footage > 12000,
                   median(garage_square_footage, na.rm = T)),
         acres = 
           replace(acres,
                   acres > 100 ,
                   median(acres, na.rm = T)),
         loan_amount = 
           replace(loan_amount,
                   loan_amount > 500000,
                   median(loan_amount, na.rm = T)),
         second_loan_amount = 
           replace(second_loan_amount,
                   second_loan_amount > 500000,
                   median(second_loan_amount, na.rm = T))
         )
 


# save them as a file for other folks)

write_csv(dr_data_trans2,"C:/Users/mlogan/Desktop/AI_Combined_File_Final_transformed.csv")





