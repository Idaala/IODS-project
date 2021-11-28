#Ida Alakörkkö
#Original link to data source: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt
#The HDI was created to emphasize that people and their capabilities should be the ultimate criteria for assessing the development of a country, not economic growth alone

# read data

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


library(dplyr)
library(stringr)
# look at the (column) names of human
names(hd)
names(gii)

# look at the structure of human
str(hd)
str(gii)
dim(hd)
dim(gii)
summary(hd)
summary(gii)

# The gii contains 195 observation and 10 variables. The hd contains 195 observations and 8 variables. The country variable is the same in both datasets

#rename variables

names(hd)[1] <- 'HDI_r'
names(hd)[2] <- 'country'
names(hd)[3] <- 'HDI'
names(hd)[4] <- 'life_exp'
names(hd)[5] <- 'exp_edu'
names(hd)[6] <- 'mean_edu'
names(hd)[7] <- 'GNI_cap'
names(hd)[8] <- 'GNI_r_hdi_r'

names(gii)[1] <- 'GII_r'
names(gii)[2] <- 'country'
names(gii)[3] <- 'GII'
names(gii)[4] <- 'mat_mor'
names(gii)[5] <- 'ado_birth'
names(gii)[6] <- 'parli_f'
names(gii)[7] <- 'edu2F'
names(gii)[8] <- 'edu2M'
names(gii)[9] <- 'labF'
names(gii)[10] <- 'labM'

# Mutate the "Gender inequality" data and create two new variables.
# The first new variable is a ratio of Female and Male populations with secondary education in each country. 
# (i.e. edu2F / edu2M). The second new variable should be the ratio of labour force participation of females and males in each country (i.e. labF / labM).

gii <- mutate(gii, edu2_F_M = edu2F/edu2M)

gii <- mutate(gii, lab_f_m = labF/labM)

#Join together the two datasets using the variable Country as the identifier

human <- inner_join(hd, gii, by = 'country')

glimpse(human)

#contains 195 observations and 19 variables. 

# Write the joined dataframe into a file.
write.table(human, file = "human.csv", sep = "\t", col.names = TRUE)



#RStudio Exercise 5
#Some more data wrangling 

human <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep  =",", header = T)

# look at the (column) names of human
names(human)

# look at the structure of human
str(human)
dim(human)

# print out summaries of the variables
summary(human)

#HDI stands for human development index. The variables have been named shorter and more descriptive. 

# Transform the Gross National Income (GNI) variable to numeric
human <- mutate(human, GNI = as.numeric(str_replace(human$GNI, pattern=",", replace ="")))

#Exclude unneeded variables

# columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- select(human, one_of(keep))

# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# Other way to dealing with not available (NA) values
human1 <- filter(human, complete.cases(human))

#Remove the observations which relate to regions instead of countries

last <- nrow(human) - 7

# Choose everything until the last 7 observations
human <- human[1:last, ]

#Define the row names of the data by the country names and remove the country name column from the data
rownames(human) <- human$Country
human <- select(human, -Country)

#dataset human contains 155 observations and 8 variables.

#save the data
write.table(human, file = "human.csv", sep = "\t", col.names = TRUE)


