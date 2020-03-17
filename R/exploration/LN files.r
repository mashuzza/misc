.libPaths("C:/Users/mlogan/Desktop/R_Packages")

library(tidyverse)
library(ggstance)
library(patchwork)
library(ggExtra)


sample_data<-read_csv("Z:/$POC_1$/Updated LN files/AI_Combined_File_Final.csv", 
                      guess_max = 264164, na = c("N/A", "", "NA", "NULL", "<NA>" ))

summary(sample_data[, 1:10])

## do the unorthodox thing and convert strings to factors

## create a copy of the dataset
dr_data<-sample_data


### convert characters to factors

dt<-sapply(dr_data, typeof) ## extract types of data from our sample
char_names<-names(which(dt == "character")) ## see what are characters

## also see that everything that starts with "src_" gets converted to factor as well

src_names<-grep("^src", names(dr_data), value=TRUE)

## convert all char to factors
dr_data[char_names]<-lapply(dr_data[char_names], factor)
dr_data[src_names]<-lapply(dr_data[src_names], factor)

## check what happened

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

dr_data<-dr_data%>%mutate(EP = as.numeric(str_replace_all(EP, c('\\)'= '', '\\(' = '-', ','= '', ' ' = ''))),
                               INC_LOSS = as.numeric(str_replace_all(INC_LOSS, c('\\)'= '', '\\(' = '-', ','= '', ' ' = ''))),
                               ZIP = as.factor(ZIP),
                               EFFDT = as.Date(EFFDT, "%m/%d/%Y"))

##what's the max char length in columns

char_cols<-sample_data[char_names]
lapply(char_cols, function(x) max(nchar(x), na.rm = T))

sapply(char_cols, function(x) max(nchar(x), na.rm = T))


nchar(as.character(dr_data$apn_number[248]))

## make some plots

ggplot(dr_data, aes(x = full_part_sale_desc)) + 
  geom_bar(stat= 'count', color = "black", fill = "lightgray") + 
  labs(title="Only 14% of all Columns Have More NA's than the Actual Data",
       subritle = "", x="% Missing Values", y = "") +
  coord_flip() +
  theme_bw()

ggplot(dr_data%>%filter(loan_amount>10000000), aes(x = loan_amount)) + 
  geom_histogram(binwidth = 10000000, color = "black", fill = "lightgray") + 
  labs(title="Your Title",
       subritle = "", x="Loan Amount", y = "")+
  theme_bw()


ggplot(dr_data%>%filter(loan_amount<10000000), aes(y = loan_amount)) + 
  geom_boxplot(color = "black", fill = "lightgray") + 
  labs(title="Your Title",
       subritle = "", x="Loan Amount", y = "")+
  theme_bw()

dr_data[which(dr_data$loan_amount>10000000),]%>%select(POLICYNUMBER:PRIMRANGE, loan_amount)

## let's see variable names and their types

vars<- sapply(dr_data, class)
vars_2 <- sapply(dr_data, typeof)
vars<- as.data.frame(vars)
vars<-as_tibble(rownames_to_column(vars))

vars_2 <- as.data.frame(vars_2)
vars_2<-as_tibble(rownames_to_column(vars_2))

# save them as a file for other folks

write_csv(vars, "C:/Users/mlogan/Desktop/vars.csv")
write_csv(vars_2, "C:/Users/mlogan/Desktop/vars_2.csv")

## just to see these are 5 entries that are the same
write_csv(AGH226065, "C:/Users/mlogan/Desktop/AGH226065.csv")

## see how we can reduce the dataset

multiple_policies<-dr_data%>%count(POLICYNUMBER) %>% arrange(desc(n)) %>% filter(n>1)

dr_data%>%distinct(POLICYNUMBER)



###########################
#### Data Exploration ####
##########################

## see variable types

var_types<-sapply(dr_data, class)

# 
var_types<-as.data.frame(var_types)

# make rownames to be the first column 

var_types<-rownames_to_column(var_types)
var_types<-var_types%>%arrange(var_types)

## see variable types in the dataset

var_types%>%group_by(var_types)%>%count()%>%ungroup

## Let's look at the variables using the template that the professor supplied

summary(dr_data$LN_seqnum) 

## let's explore the numerica variables


summary(dr_data$assessment_recording_dt)
boxplot(dr_data$assessment_recording_dt)

# visualize

ggplot(dr_data, aes(x = assessment_recording_dt, y = -0.00025)) +
  geom_boxploth(outlier.colour = "red", width = 0.00005) +
  # normal density plot
  geom_density(aes(x = assessment_recording_dt), inherit.aes = FALSE) +
  expand_limits(y = c(-0.0005, 0.0005)) +
  
  labs(title = "Title", 
       subtitle = 'secret subtitle',
       x = '',
       y = '') +
  theme_bw()

## version 1

ggplot(dr_data, aes(x = deed_recording_date, y = -0.00025)) +
  geom_boxploth(outlier.colour = "red", width = 0.00020) +
  # normal density plot
  geom_density(aes(x = deed_recording_date), inherit.aes = FALSE) +
  expand_limits(y = c(-0.0005, 0.0005)) +
  
  labs(title = "Title", 
       subtitle = 'secret subtitle',
       x = '',
       y = '') +
  theme_bw()

## version 2

p1<-ggplot(dr_data, aes(x = deed_recording_date)) +
  geom_density() +
  labs(title = "Title", 
       subtitle = 'secret subtitle',
       x = '',
       y = '') +
  theme_bw()

p2<-ggplot(dr_data, aes(y = '', x = deed_recording_date)) +
  geom_boxploth(outlier.colour = "red") +
  # normal density plot
  labs(x = '',
       y = '') +
  theme_bw()


p1/p2

## version 3 using ggExtra

p1

p4 <- ggMarginal(p1, type="boxplot")

p4



## try with other variable


ggplot(dr_data, aes(x = sale_date, y = -0.00025)) +
  geom_boxploth(outlier.colour = "red", width = 0.00020) +
  # normal density plot
  geom_density(aes(x = sale_date), inherit.aes = FALSE) +
  expand_limits(y = c(-0.0005, 0.0005)) +
  
  labs(title = "Title", 
       subtitle = 'secret subtitle',
       x = '',
       y = '') +
  theme_bw()


ggplot(dr_data, aes(x = loan_amount , y = -0.00025)) +
  geom_boxploth(outlier.colour = "red", width = 0.00020) +
  # normal density plot
  geom_density(aes(x = loan_amount), inherit.aes = FALSE) +
  expand_limits(y = c(-0.00025, 0.00025)) +
  
  labs(title = "Title", 
       subtitle = 'secret subtitle',
       x = '',
       y = '') +
  theme_bw()

###

p1<-ggplot(dr_data, aes(x = no_of_stories )) +
  geom_density() +
  labs(title = "Title", 
       subtitle = 'secret subtitle',
       x = '',
       y = '') +
  theme_bw()

p2<-ggplot(dr_data, aes(y = '', x = no_of_stories )) +
  geom_boxploth(outlier.colour = "red") +
  # normal density plot
  labs(x = '',
       y = '') +
  theme_bw()

p1/p2



## try a for loop

for (i in seq_along(var_types[1:3,1])) {
  
  plot <- ggplot(dr_data, aes(y = '', x = names(dr_data[,3]) )) +
    geom_boxploth(outlier.colour = "red") +
    # normal density plot
    labs(x = '',
         y = '') +
    theme_bw() 
print(plot)

summary(dr_data[,3] )

}

## for loop for practice

sub_data<-dr_data%>%select(MOD, EP)

class(sub_data)

sub_data<-as.data.frame(sub_data)


for(i in names(sub_data)) {
  
  print(paste(i,
              class(sub_data[, i])))
  
  print(sub_data %>% ggplot() + 
         ## geom_histogram(aes(x = sub_data[,i])) +
          geom_density(aes(x = sub_data[,i])) +
          labs (title = paste(i,  class(sub_data[, i]) ),
          x = paste (i),
          y = '') +
          theme_bw())
  
  print(summary(sub_data[, i])) 

}


