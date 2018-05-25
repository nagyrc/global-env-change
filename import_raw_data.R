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

clean_gc <- function(GC) {
  ifelse(GC == 'Yes' | GC == 'Yes ' | GC == 'yes' | GC == 'yes?' | GC == 'Yes?' | GC == 'YEs', 'YES',
         ifelse(GC == 'old', 'OLD',
                ifelse(GC == ' ' | GC == '' | GC == 'maybe' | GC == 'Maybe' | GC == 'Maybe?' | GC == 't' | is.na(GC), 'MAYBE',
                       ifelse(GC == 'Nope' | GC == 'NOPE', 'NO', as.character(GC)))))
}

#applies a function to all the files in file_list, cleans the GC field, and adds a field that indicates the author name
imported_csv <- lapply(file_list,
                       FUN = function(x) {
                         
                         input_name <- x
                         
                         imported <- read_csv(x) %>%
                           mutate(file_names = x) %>%
                           dplyr::select(keep)
                       })

#bind all of these together in one dataframe
imported_csv <- do.call(rbind, imported_csv)

#this uses the helper function (clean_gc) that Nate created and calls in source above
cleaned <- imported_csv %>%
  mutate(GCC = clean_gc(as.character(GC)))

unique(cleaned$GCC)



