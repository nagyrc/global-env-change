#Global Env Change Research at CU Boulder
#R. Chelsea Nagy
#April 18, 2018

library(plyr)
library(tidyverse)
source('src/functions/helper_functions.R')

#make a list of all the individual data files in sub-directory
file_list <- list.files('data',
                        pattern = '.csv',
                        full.names = TRUE )  

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

#this uses the helper function (clean_gc) that Nate created and calls in source above
cleaned <- imported_csv %>%
  mutate(GCC = clean_gc(as.character(GC)))

unique(cleaned$GCC)

#shouldn't need this code below now
# Option 1 for removing the NAs
# This would work if all rows were TRULY NAs but we added a column field during import so this will not work as intended
na_remove <- apply(cleaned, 1, function(x) all(is.na(x)))

df <- cleaned[!na_remove, ]
unique(cleaned$GCC)

test <-  head(cleaned, -4) 
unique(test$GCC)



