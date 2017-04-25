#AWS Exercise
#Install
  install.packages(c("foreach","doParallel","dplyr", "xml2","httr"))
  install.packages("aws.s3", repos = c("cloudyr" = "http://cloudyr.github.io/drat"))

#Access keys
access <- "aws access key here"
secret <- "aws access secret"

#Load libraries
  library(aws.s3)
  library(foreach)
  library(doParallel)
  library(dplyr)

#Set S3
  Sys.setenv("AWS_ACCESS_KEY_ID" = access,
             "AWS_SECRET_ACCESS_KEY" = secret)
  