#NDVI Processing
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

#national
#mast_us <- master[master$lat < 49.384358 & master$lat > 24.396308 &  master$lon > -124.848974 & master$lon < -66.885444,]

mast_us <- master[master$lat < 45 & master$lat > 35 &  master$lon > -119 & master$lon < -107,]

#Sample
  set.seed(32)
  df <- mast_us[runif(nrow(mast_us)) < 0.3 & mast_us$ndvi!=99999,]

#KNN 

  knn.mean <- function(x_train, y_train, x_test, k){
    
    #Set vector of length of test set
      output <-  vector(length = nrow(x_test))
    
    #Loop through each row of the test set
      for(i in 1:nrow(x_test)){
        
        #extract coords for the ith row
          cent <- x_test[i,]
        
        #Set vector length
          dist <- vector(length = nrow(x_train))
        
        #Calculate distance by looping through inputs
          for(j in 1:ncol(x_train)){
            dist <- dist + (x_train[, j] - cent[j])^2
          }
          dist <- sqrt(dist)
        
        #Calculate rank on ascending distance, sort by rank
          df <- data.frame(id = 1:nrow(x_train),rank = rank(dist))
          df <- df[order(df$rank),]
        
        #Calculate mean of obs in positions 1:k, store as i-th value in output
          output[i] <- mean(y_train[df[1:k,1]], na.rm=T)
          
      }
    
    return(output)
  }
  
#Optimize
  knn.opt <- function(x_train, y_train, x_test, max, increments){
    log <- data.frame()
    for(i in seq(1, max, increments)){
      yhat <- knn.mean(x_train, y_train, x_test, i)
      rmse <- round(mean(sqrt((yhat  - mast_us$ndvi)^2), na.rm=T),3)
      log <- rbind(log, data.frame(k = i,
                              rmse = rmse))
      
    }
    log <- log[order(log$rmse),]
    return(log)
  }

  library(ggplot2)
  library(gridExtra) 
  
  #Set up data
  set.seed(123)
  rand <- runif(nrow(df))
  
  #training set
  xtrain <- as.matrix(df[rand < 0.7, c(1,2)])
  ytrain <- df[rand < 0.7, c(3)]
  
  #test set
  xtest <- as.matrix(mast_us[, c(1,2)]) 
  
  #opt
  logs <- knn.opt(xtrain, ytrain, xtest, nrow(xtest),10)
  opt1 <- ggplot(logs, aes(x = k, y = rmse)) +
          geom_line() + geom_point() + ggtitle("RMSE vs. K-Nearest Neighbors")

#graphing
  

  full <- ggplot(mast_us, aes(x=lon, y=lat)) +
            geom_raster(aes(fill = ndvi)) +
            ggtitle("Original NASA Tile") +
            scale_fill_gradientn(limits = c(-1,1), colours = rev(terrain.colors(10)))
  sampled <- ggplot(df, aes(x=lon, y=lat)) +
            geom_raster(aes(fill = ndvi)) +
            ggtitle("Sample: 30%") +
            scale_fill_gradientn(limits = c(-1,1), colours = rev(terrain.colors(10)))   
  
  
  for(k in c(1, 3, 10, 100)){
    yhat <- knn.mean(xtrain,ytrain,xtest, k)
    pred <- data.frame(xtest, ndvi = yhat)
    rmse <- round(mean(sqrt((yhat  - mast_us$ndvi)^2), na.rm=T),3)
    
    g <- ggplot(pred, aes(x=lon, y=lat)) +
      geom_raster(aes(fill = ndvi)) +
      ggtitle(paste0("kNN (k =",k,", RMSE = ", rmse,")")) +
      scale_fill_gradientn(limits = c(-1,1), colours = rev(terrain.colors(10)))
    assign(paste0("k",k), g)
  }
 
  
  grid.arrange(full, sampled,  ncol=2)
  grid.arrange(full, sampled, k1, k3, k10, k100, ncol=3)
  