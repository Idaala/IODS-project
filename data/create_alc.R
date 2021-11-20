#Ida Alakörkkö, 19.11.2021, This data approach student achievement in secondary education of two Portuguese schools.
#Data source:P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.

math <- read.csv("student-mat.csv", sep = ";",header=TRUE)

por <- read.csv("student-por.csv", sep = ";",header=TRUE)

#exploring the structure and dimension

dim(math)

dim(por)

structure(math)

structure(por)

#the datasets contain a variety of variables. Math dataset contains 395 observations and 33 variables. The por contains as well 33 variables and 649 observations
#the variables are binary/five-level classification. 

library(dplyr)

por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

free_cols <- c("id","failures","paid","absences","G1","G2","G3")

join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

dim(pormath)

str(pormath)

#pormath contains 370 students and 51 variables

colnames(pormath)

alc <- select(pormath, one_of(join_cols))


# columns that were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_cols]

# print out the columns not used for joining
notjoined_columns



for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(pormath, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

# access the 'tidyverse' packages dplyr and ggplot2
library(dplyr); library(ggplot2)


# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)


# Take the average (of weekends and weekdays) alcohol consumption.
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# create a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# Glimpse the structure and dimensions of the new dataframe
glimpse(alc)

# Write the dataframe into a file
write.table(alc, file = "alc.csv", sep = "\t", col.names = TRUE)


#Exercise 3. Analysis of the student performance including alcohol consumption

#Introduction

#

rm(list = ls())

alc <- read.csv("https://github.com/rsund/IODS-project/raw/master/data/alc.csv", sep = ",",header=TRUE)

glimpse(alc)

names(alc)


# Packages required by this script.
library(dplyr)
library(GGally)
library(ggplot2)
library(boot)








