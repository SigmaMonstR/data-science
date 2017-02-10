#NDVI Processing: Cleaning the NDVI data
#https://neo.sci.gsfc.nasa.gov/view.php?datasetId=MOD13A2_M_NDVI
  setwd("/Users/jeff/Documents/Github/data-science/lecture-05/dataset")

  df <- read.csv("MOD13A2_M_NDVI_2016-06-01_rgb_1440x720.SS.CSV")

  master <- data.frame()
  for(k in 2:ncol(df)){
    temp <- df[,c(1,k)]
    temp$lon <- colnames(temp)[2]
    colnames(temp) <- c("lat","ndvi","lon")
    temp <- temp[,c(1,3,2)]
    
    master <- rbind(master, temp)
    print(k)
  }

  
  master$lon <- gsub("X\\.","-",master$lon)
  master$lon <- gsub("X","",master$lon)
  master$lon <- as.numeric(master$lon)
  
  write.csv(master,"ndvi_sample_201606.csv",row.names = FALSE)
