####################################
##      NASA MODIS NDVI DATA     ### 
##          Preparation          ###
####################################

# Notes: 
# Format data from NASA -- 0.25 degree data for the month of February 2016
# Link: https://neo.sci.gsfc.nasa.gov/view.php?datasetId=MOD13A2_M_NDVI

#NDVI Processing: Cleaning the NDVI data
# Feb 2016: https://neo.sci.gsfc.nasa.gov/servlet/RenderData?si=1706147&cs=rgb&format=CSV&width=1440&height=720

#Libraries
  library(doParallel)
  library(foreach)

#Set directory
  dir <- "/Users/jeff/Google Drive/Text Book/base-data/nasa-modis"
  setwd(dir)

#Download data -- comes as matrix -- 720 x 1441
#Convert from wide to long
  df <- read.csv("https://neo.sci.gsfc.nasa.gov/servlet/RenderData?si=1706147&cs=rgb&format=SS.CSV&width=1440&height=720")
  dim(df)
  
  cl <- makeCluster(3)
  registerDoParallel(cl)
  ndvi <- foreach(k = 2:ncol(df), .combine = rbind) %dopar% {
    temp <- df[,c(1,k)]
    temp$lon <- colnames(temp)[2]
    colnames(temp) <- c("lat","ndvi","lon")
    temp <- temp[,c(1,3,2)]
    return(temp)
  }

#Clean headers
  ndvi$lon <- gsub("X\\.","-",ndvi$lon)
  ndvi$lon <- gsub("X","",ndvi$lon)
  ndvi$lon <- as.numeric(ndvi$lon)
  
#Saveout
  write.csv(ndvi,"ready/ndvi_sample_201606.csv",row.names = FALSE)
  save(ndvi, file = "ready/ndvi_sample_201606.Rda")
