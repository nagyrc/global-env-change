#Global Env Change Research at CU Boulder

#start by importing .csv files
#import all files in folder
#change working directory
#setwd("data/")

#setwd("/Users/rana7082/Dropbox/global-env-change/")
#getwd()
file_list <- list.files("data/")  


numfiles <- length(file_list)


library(plyr)
dataset <- ldply(file_list, read.csv, header=TRUE, sep=",")







#then stack them all in large dataframe