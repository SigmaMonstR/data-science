##################
## PREP 311 DATA##
##################
  
#Set working directory
  setwd("/Users/jeff/Documents/Github/data-science/lecture-09/data")

#Read in data 
  df <- read.csv("311_Service_Requests_from_2016.csv")
  
#Round Lat/Lon to 3-digits
  df$lat <-round(df$Latitude,3)
  df$lon <-round(df$Longitude,3)

#Clean the Complaint Types
  df$type <- gsub(" ", ".",tolower(df$Complaint.Type))
  
#Drop any missing coordinates
  df <- df[!is.na(df$lat), ]
  
#Aggregate up
  df2 <- aggregate(df[,"lat"], 
                   by = list(lat = df$lat, lon = df$lon, type = df$type), 
                   FUN = length)
  
#Reshape wide
  df3 <- reshape(df2, 
                 timevar = "type",
                 idvar = c("lat","lon"),
                 direction = "wide")

#Keep complaint types with more than n = 100
  for(k in ncol(df3):3 ){
    if(sum(df3[,k], na.rm=T) < 100){
      df3[,k] <- NULL
    } else {
      df3[,k][is.na(df3[,k])] <- 0
    }
    
  }
  dim(df3)

#Row standardize 
  sums <- rowSums(df3[, 3:ncol(df3)])
  for(k in 3:ncol(df3)){
    df3[,k] <- df3[,k]/sums
  }
  
#Drop missing records
  nyc311 <- df3[!is.na(df3[,3]) & !is.nan(df3[,3]),]
  colnames(nyc311) <- gsub("x.","", colnames(nyc311))
  rm(df, df2, df3)

#Save
  save(nyc311, file = "nyc311.Rda")
