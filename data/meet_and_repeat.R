#Ida Alakörkkö
#12.12.2021
#IODS data wrangling
# Data is taken from the second edition of Multivariate Analysis for the Behavioral Sciences (Vehkalahti and Everitt, 2019). 

# Read the BPRS data

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)

# Look at the (column) names of BPRS
names(BPRS)
names(RATS)

# Look at the structure of BPRS
str(BPRS)
str(RATS)
# print out summaries of the variables
summary(BPRS)

# In the wide tables each subject has its own row here. The columns in this case correspond to the "time" dimension. 
#and each measurement in their own column. 

#Convert the categorical variables of both data sets to factors. 


BPRS$treatment <- as.factor(BPRS$treatment)
BPRS$subject <- as.factor(BPRS$subject)
RATS$ID <- as.factor(RATS$ID)
RATS$Group <- as.factor(RATS$Group)


#Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS. 

# Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

#And now the second dataset 

ratsw <- RATS %>%
  gather(key = WD, value = weight, -ID, -Group) %>%
  mutate(time = as.integer(substr(WD, 3, 5)))


#Now the subjects have multiple rows. In other words. Each individual was on one row in the wide tables; now, each individual is on multiple rows.
#Long tables, on the other hand, have only one column for time information. 


write.csv(BPRSL, "data/bprs.csv", row.names = FALSE)
write.csv(ratsw, "data/rats.csv", row.names = FALSE)




