#Ida Alakörkkö, 7.11.2021
#part 1 Data Wrangling (max 5p)

learning2014_data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header=TRUE)


learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/learning2014.txt", sep = "\t", header = TRUE)

str(learning2014_data)
dim(learning2014_data)

#The data contains 60 variables and 183 observations in those 60 variables. Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points

learning2014_data$gender
learning2014_data$Age
learning2014_data$Attitude
learning2014_data$deep
learning2014_data$stra
learning2014_data$Points
learning2014_data$surf

#Create deep, stra and surf

deep_que <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf_que <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra_que <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(learning2014_data, one_of(deep_que))
learning2014_data$deep <- rowMeans(deep_columns)

surface_columns <- select(learning2014_data, one_of(surf_que))
learning2014_data$surf <- rowMeans(surface_columns)

strategic_columns <- select(learning2014_data, one_of(stra_que))
learning2014_data$stra <- rowMeans(strategic_columns)

#Pick the columns. Remember to check if the variable is with big letter


New_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
sub_data <- select(learning2014_data, one_of(New_columns))


#rename to small letters as is done in learning2014

colnames(sub_data)[2] <- "age"
colnames(sub_data)[3] <- "attitude"
colnames(sub_data)[7] <-"points"

#Exclude observations where the exam points variable is zero

sub_data <- filter(sub_data, points >! 0)

#The data should then have 166 observations and 7 variables. sub_data contains 166 observations and 7 variables.

#next save the data as cvs or table format

?write.csv
write.csv(sub_data, file = "learning2014.csv", row.names = FALSE)
learn2014 <- read.csv("learning2014.csv")

str(learn2014)
head(learn2014)


#Part 2 Analysis (max 15 points)

#1. read the data

students2014 <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/learning2014.txt", sep = ",", header=TRUE)

str(students2014)
dim(students2014)

#2. explore the data

summary(students2014)

library(tidyverse)
library(ggplot2)

#in the summary, we can see that gender is a character variable. The rest of the variables are numeric. 

#graphical overview of the data. We can plots of some variables


plot(students2014$attitude, students2014$points)

plot(students2014$stra, students2014$points)

p1 <- ggplot(students2014, aes(x = attitude, y = points))

p2 <- p1 + geom_point()

p2

p3 <- p2 + geom_smooth(method = "lm")

p3

#It seems like a higher attitude results in higher scores. We can check the correlation between all the variables

cor(students2014$attitude, students2014$points)

ggpairs(students2014, title = "correlogram with ggpairs", lower= list(combo = wrap("facethist", bins = 20)))

ggpairs(students2014, columns = 2:4, ggplot2::aes(colour=gender)) 

#We can see from the scatterplotmatrix that attitude (0.436), stra (0.146) and surf (-0,144) correlate the most with points. 
#Hence, these variables will be as the explanatory variables. 

reg_model <- lm(points ~ attitude + stra + surf, data = students2014)

summary(reg_model)

#Attitude seems like the only variable that correlates statistically significant in explaining points. 
# let us remove a variable 


reg_model1 <- lm(points ~ attitude + stra, data = students2014)

summary(reg_model1)

#let us try another versions

reg_model2 <- lm(points ~ attitude + surf, data = students2014)

summary(reg_model2)


reg_model3 <- lm(points ~ attitude, data=students2014)

summary(reg_model3)

#In conclusion, a more cheerful attitude leads to better exam outcomes.It's possible that having a happy mindset earns you more points. 
#R squared of the model. 

#The R-squared (R2) statistic measures the proportion of a dependent variable's variance explained by the independent variable or variables in a regression model. 
#R-squared explains how much variance of one variable can be explained by the variance of another variable, whereas correlation explains the strength of the relationship between independent and dependent variables. 
#The R2 of a model is 0.50, which means that approximately half of the observed variation can be explained by the model's inputs. WHich means a higher R2 value, the better it fits the model
#the R2-value becomes lower as the variables are removed. This indicates a poorer fit. 

#R2-values of the different regression models

#reg_model= 0.2074
#reg_model1= 0.2048
#reg_model2= 0.1953
#reg_model3=  0.1906

#reg_model have the highest r2-value. Now we can check how good the model actually is. 

errors <- plot(reg_model, which= c(1,2,5), par(mfrow= c(2,2)))


#More or less points are closer to the straight line. Almost all points fall approximately along this straight line, so we can assume normality of the errors.
#We can observe in plot 1 that values are are quite randomly distributed throughout the area, indicating that errors do not follow any pattern, as one would anticipate from a reasonable model. Additionally there are no extreme outliers.
