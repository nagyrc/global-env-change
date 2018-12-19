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


###########################
#to check to see who of the potential list were actually downloaded
list1 <- substring(file_list, 9)
list1b <- str_sub(list1, 1, str_length(list1)-4)
list1c <- as.data.frame(list1b)
colnames(list1c)[colnames(list1c) == 'list1b'] <- 'combo'

list2  <- as.data.frame(read_csv("output/list2.csv"))
head(list2)

list2$initial <- str_sub(list2$`First name`, 1, 1)
list2$middle <- sub("\\s+\\S+$", '', list2$`First name`)
list2$middle2 <-  sub(".* ", "", list2$`First name`)
list2$middle2b <- str_sub(list2$middle2, 1, 1)

#list2$combo <- paste (list2$`Last name`, list2$initial, list2$middle2b, sep = "")

str(list1c)
str(list2)
list2$combo

list2$middle2c <-  ifelse(str_detect(list2$`First name`, " "), sub(".* ", "", list2$`First name`), "")
list2$middle2d <- str_sub(list2$middle2c, 1, 1)

list2$combo <- paste(list2$`Last name`, list2$initial, list2$middle2d, sep = "")

experts <- list2[order(list2$combo),] 
pulled <- as.data.frame(list1c[order(list1c$combo),])

names(pulled)[1] <- "combo"

diff <- setdiff(experts$combo, pulled$combo)
408 - 225
#183, but there are 263 in this list...some of these are from folks with suffixes (e.g., III)
diff

write.csv(diff, file = 'output/diff.csv')

added <- setdiff(pulled$combo, experts$combo)
added
#81...where did these come from if they weren't on our CU experts list?!?

write.csv(added, file = 'output/added.csv')
###########################



