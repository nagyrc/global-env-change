#Global Env Change Research at CU Boulder
#R. Chelsea Nagy
#April 18, 2018

library(plyr)
library(tidyverse)
#source('src/functions/helper_functions.R')

#make a list of all the individual data files in sub-directory
file_list <- list.files('data',
                        pattern = '.csv',
                        full.names = TRUE )  

#create a list of which fields to keep- there are many here that we don't need
#it doesn't recognize "EA" and "EY" as columns...remove these and see if it works...these are early access data- not super important
keep = c("GC", "PT", "AU", "BA", "BE", "GP", "AF", "BF", "CA", "TI", "SO", "SE", "BS", "LA", "DT", "CT", "CY", "CL", "SP", "HO", "DE", "ID", "AB", "C1", "RP", "EM", "RI", "OI", "FU", "FX", "CR", "NR", "TC", "Z9", "U1", "U2", "PU", "PI", "PA", "SN", "EI", "BN", "J9", "JI", "PD", "PY", "VL", "IS", "PN", "SU", "SI", "MA", "BP", "EP", "AR", "DI", "D2", "PG", "WC", "SC", "GA", "UT", "PM", "OA", "HC", "HP", "DA", "file_names")


#applies a function to all the files in file_list and adds a field that indicates the author name
imported_csv <- lapply(file_list,
                       FUN = function(x) {
                         
                         input_name <- x
                         
                         imported <- read_csv(x) %>%
                           mutate(file_names = x) %>%
                           dplyr::select(keep)
                       })

#bind all of these together in one dataframe
imported_csv <- do.call(rbind, imported_csv)

#this is a function that will clean the GC field because there is much variation in these factors
clean_gc <- function(GC) {
  ifelse(GC == 'Yes' | GC == 'Yes ' | GC == 'yes' | GC == 'yes?' | GC == 'Yes?' | GC == 'YEs', 'YES',
         ifelse(GC == 'old', 'OLD',
                ifelse(GC == ' ' | GC == '' | GC == 'maybe' | GC == 'Maybe' | GC == 'Maybe?' | GC == 't' | is.na(GC), 'MAYBE',
                       ifelse(GC == 'Nope' | GC == 'NOPE', 'NO', as.character(GC)))))
}

#this uses the function above to clean the GC field and creates a new column with character values for the GC field
cleaned <- imported_csv %>%
  mutate(GCC = clean_gc(as.character(GC)))

unique(cleaned$GCC)

#write the combined .csv file with all 13,984 abstracts
write.csv(cleaned, file = 'output/all_records.csv')

head(cleaned)
head(imported_csv)

list1 <- substring(file_list, 9)
list1b <- str_sub(list1, 1, str_length(list1)-4)
list1c <- as.data.frame(list1b)
colnames(list1c)[colnames(list1c) == 'list1b'] <- 'combo'

list2  <- as.data.frame(read_csv("data/list2.csv"))
head(list2)

list2$initial <- str_sub(list2$`First name`, 1, 1)
list2$middle <- sub("\\s+\\S+$", '', list2$`First name`)

list2$combo <- paste (list2$`Last name`, list2$initial, sep = "")

list2b <- as.list(list2$combo)

diff <- setdiff(list2$combo, list1c$combo)

str(list1c)
str(list2)
list2$combo




#######################
library(dplyr)
anti_join(list1c$combo, list2$combo, by = "combo")

str(list1c)
list1d <- as.character(list1c)
is.character(list1d)

list2$combo <- as.factor(list2$combo)

is.factor(list2$combo)
is.factor(list1c$combo)

test <- table1[is.na(match(list1c$combo,list2$combo)),]
