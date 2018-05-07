#Global Env Change Research at CU Boulder
#R. Chelsea Nagy
#April 18, 2018


library(plyr)

#check current working directory
getwd()

#set working directory
setwd("data/")

#make a list of all the individual data files in sub-directory
file_list <- list.files()  

#check the number of files
numfiles <- length(file_list)

#read in and merge all data files
dataset <- ldply(file_list, read.csv, header=TRUE, sep=",")

###
#this is a check; do not need to run every time
#look at the set up in the first .csv file
#Abbott<-read.csv("001AbbottLD.csv", header = TRUE, sep = ",", fill = TRUE)
#head(Abbott)
###


#sort by those that Caelan grouped into related to GEC or not
summary(dataset$GC)
#roughly ~600 yes's, but this field needs to be cleaned...many weird ones in here

#489 variables looks like a lot...let's look at all field (column) names
colnames(dataset)
#there are many that are labeled as X.1-X.419...what are these?
#then EA and EY at the end...these look real

summary(dataset$X.1)

head(dataset)

#look at the end to make sure they are all legit
tail(dataset)
#they look fine, minus those weird X columns


###cleaning the data
#drop the weird X columns
data2<-dataset[,-grep(pattern="^X.", colnames(dataset))]

colnames(data2)
#check this against column names to make sure I didn't delete any real info.
#GC is a column that Caelan added- his designation of related to global change or not

summary(data2$GC)
head(data2)

#cleaning GC column
str(data2$GC)
data2$GCC<-as.character(data2$GC)
is.character(data2$GCC)

library(tidyverse)
cleaned <- data2 %>%
  mutate(GCC = ifelse(GC == 'Yes' | GC == 'Yes ' | GC == 'yes' | GC == 'yes?' | GC == 'Yes?', 'YES',
                      ifelse(GC == 'old', 'OLD',
                             ifelse(GC == ' ' | GC == 'maybe' | GC == 'Maybe?' | GC == 't', 'MAYBE',
                                    ifelse(GC == 'Nope' | GC == 'NOPE', 'NO', as.character(GC))))))

