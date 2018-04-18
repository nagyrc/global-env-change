#Global Env Change Research at CU Boulder
#R. Chelsea Nagy


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



