library(tidyverse)
library(odbc)


con <- dbConnect(odbc(), "AI1RSKSQLP01/RISKINSIGHT")
str(con)


# get the tables in 

rtn_table<-read_csv("Z:/$POC_1$/Updated LN files/AI_8826AI_8826_DEP_RV5_IV_RTN_N.csv", 
                    guess_max = 264164, na = c("N/A", "", "NA", "NULL", "<NA>", "-" ))

summary(rtn_table)



## replace (0.01) format to numeric

rtn_table1<-rtn_table%>%mutate(EP = as.numeric(str_replace_all(rtn_table$EP, c('\\)'= '', '\\(' = '-', ','= ''))),
                               INC_LOSS = as.numeric(str_replace_all(INC_LOSS, c('\\)'= '', '\\(' = '-', ','= ''))),
                               ZIP = as.character(ZIP),
                               EFFDT_enc = as.character(EFFDT_enc),
                               EFF_MY = as.character(EFF_MY))


## do the unorthodox thing and convert strings to factors

## create a copy of the dataset
rtn_data<-rtn_table1

## write this table to your SSMS

con <- dbConnect(odbc::odbc(), "AI1RSKSQLP01/RISKINSIGHT",
                 Database = "LexisNexis", Driver = 'SQL Server')
## check if exists
if (dbExistsTable(con, "AI_8826AI_8826_DEP_RV5_IV_RTN_N_updated"))
  dbRemoveTable(con, "AI_8826AI_8826_DEP_RV5_IV_RTN_N_updated")

## write the table
dbWriteTable(con, name =  "AI_8826AI_8826_DEP_RV5_IV_RTN_N_updated",value = rtn_data)

## disconnect
dbDisconnect(con)

