#Ida Alakörkkö, 19.11.2021, This data approach student achievement in secondary education of two Portuguese schools.
#Data source:P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.



math <- read.table("student-mat.csv", sep = ";",header=TRUE)

por <- read.tabe("student-por.csv", sep = ";",header=TRUE)

dim(math)

dim(por)

structure(math)

structure(por)

#the datasets contain a variety of variables. math dataset contains 395 observations and 33 variables. The por contains as well 33 variables and 649 observations
#the variables are binary/five-level classification.

por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())