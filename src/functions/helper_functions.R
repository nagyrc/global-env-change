#this is a function that will clean the GC field because there is much variation in these factors
clean_gc <- function(GC) {
  ifelse(GC == 'Yes' | GC == 'Yes ' | GC == 'yes' | GC == 'yes?' | GC == 'Yes?' | GC == 'YEs', 'YES',
         ifelse(GC == 'old', 'OLD',
                ifelse(GC == ' ' | GC == '' | GC == 'maybe' | GC == 'Maybe' | GC == 'Maybe?' | GC == 't' | is.na(GC), 'MAYBE',
                       ifelse(GC == 'Nope' | GC == 'NOPE', 'NO', as.character(GC)))))
}
