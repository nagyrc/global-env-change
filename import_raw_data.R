#Global Env Change Research at CU Boulder
#R. Chelsea Nagy
#April 18, 2018


library(plyr)
library(tidyverse)
library(dplyr)

#check current working directory
getwd()

#set working directory
setwd("data/")

#make a list of all the individual data files in sub-directory
file_list <- list.files()  


#OPTION 1
###################################################
###test with Nate's code to add field with part of file name

#keep=c("GC", "PT", "AU", "BA", "BE", "GP", "AF", "BF", "CA", "TI", "SO", "SE", "BS", "LA", "DT", "CT", "CY", "CL", "SP", "HO", "DE", "ID", "AB", "C1", "RP", "EM", "RI", "OI", "FU", "FX", "CR", "NR", "TC", "Z9", "U1", "U2", "PU", "PI", "PA", "SN", "EI", "BN", "J9", "JI", "PD", "PY", "VL", "IS", "PN", "SU", "SI", "MA", "BP", "EP", "AR", "DI", "D2", "PG", "WC", "SC", "GA", "UT", "PM", "OA", "HC", "HP", "DA", "EA", "EY", "file_names")
#it doesn't recognize "EA" and "EY" as columns...remove these and see if it works...these are early access data- not super important
keep = c("GC", "PT", "AU", "BA", "BE", "GP", "AF", "BF", "CA", "TI", "SO", "SE", "BS", "LA", "DT", "CT", "CY", "CL", "SP", "HO", "DE", "ID", "AB", "C1", "RP", "EM", "RI", "OI", "FU", "FX", "CR", "NR", "TC", "Z9", "U1", "U2", "PU", "PI", "PA", "SN", "EI", "BN", "J9", "JI", "PD", "PY", "VL", "IS", "PN", "SU", "SI", "MA", "BP", "EP", "AR", "DI", "D2", "PG", "WC", "SC", "GA", "UT", "PM", "OA", "HC", "HP", "DA", "file_names")

imported_csv <- lapply(file_list,
                       FUN = function(x) {
                         
                         input_name <- x
                         
                         imported <- read_csv(x) %>%
                           mutate(file_names = x) %>%
                           dplyr::select(keep)
                       })
imported_csv <- do.call(rbind, imported_csv)



#cleaning GC column
unique(imported_csv$GC)
imported_csv$GCC <- as.character(imported_csv$GC)
is.character(imported_csv$GCC)

str(imported_csv$GCC)

unique(imported_csv$GCC)

cleaned <- imported_csv %>%
  mutate(GCC = ifelse(GC == 'Yes' | GC == 'Yes ' | GC == 'yes' | GC == 'yes?' | GC == 'Yes?' | GC == 'YEs', 'YES',
                      ifelse(GC == 'old', 'OLD',
                             ifelse(GC == ' ' | GC == '' | GC == 'maybe' | GC == 'Maybe' | GC == 'Maybe?' | GC == 't' | GC == NA, 'MAYBE',
                                    ifelse(GC == 'Nope' | GC == 'NOPE', 'NO', as.character(GC))))))

unique(cleaned$GCC)
#why are there still NAs?

sum(cleaned$GCC == "YES")
#this no longer works

###################################################





######################################
#OPTION 2
#read in and merge all data files
dataset <- ldply(file_list, read.csv, header = TRUE, sep = ",")

ccc <- colnames(dataset)
ccc

###
#this is a check; do not need to run every time
#look at the set up in the first .csv file
#Abbott<-read.csv("001AbbottLD.csv", header = TRUE, sep = ",", fill = TRUE)
#head(Abbott)
###


###
#cleaning data
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
data2 <- dataset[,-grep(pattern="^X.", colnames(dataset))]

colnames(data2)
#check this against column names to make sure I didn't delete any real info.
#GC is a column that Caelan added- his designation of related to global change or not

summary(data2$GC)
head(data2)

#cleaning GC column
str(data2$GC)
data2$GCC <- as.character(data2$GC)
is.character(data2$GCC)

cleaned <- data2 %>%
  mutate(GCC = ifelse(GC == 'Yes' | GC == 'Yes ' | GC == 'yes' | GC == 'yes?' | GC == 'Yes?'| GC == 'YEs', 'YES',
                      ifelse(GC == 'old', 'OLD',
                             ifelse(GC == ' ' | GC == '' | GC == 'maybe' | GC == 'Maybe' | GC == 'Maybe?' | GC == 't', 'MAYBE',
                                    ifelse(GC == 'Nope' | GC == 'NOPE', 'NO', as.character(GC))))))

sum(cleaned$GCC == "YES")
#614
sum(cleaned$GCC == "NO")
#3545
sum(cleaned$GCC == "MAYBE")
#6
sum(cleaned$GCC == "OLD")
#9821

unique(cleaned$GCC)
#now it only has yes, no, old, and maybe
