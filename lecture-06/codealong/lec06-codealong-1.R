
##########################
##LECTURE 6: KNN Example##
##########################
  
#Load in data
  dir <- "/Users/jeff/Documents/Github/data-science/lecture-06/data"
  setwd(dir)
  df <- read.csv("ndvi_sample_201606.csv")
  
#Take a look at the imagery
  library(ggplot2)
  ggplot(df, aes(x=lon, y=lat)) +
    geom_raster(aes(fill = ndvi)) +
    ggtitle("NDVI: October 2016") + 
    scale_fill_gradientn(limits = c(-1,1), colours = rev(terrain.colors(10)))
  
  
#Cut down file to US
  #Subset image to Western US near the Rocky Mountains
  us_west <- df[df$lat < 45 & df$lat > 35 &  df$lon > -119 & df$lon < -107,]
  
  #Randomly selection a 30% sample
  set.seed(32)
  sampled <- us_west[runif(nrow(us_west)) < 0.3 & us_west$ndvi != 99999,]
  
#KNN regression function
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
  
#Optimization code
  knn.opt <- function(x_train, y_train, x_test, y_test, max, step){
    
    #create log placehodler
    log <- data.frame()
    
    for(i in seq(1, max, step)){
      #Run KNN for value i
      yhat <- knn.mean(x_train, y_train, x_test, i)
      
      #Calculate RMSE
      rmse <- round(sqrt(mean((yhat  - y_test)^2, na.rm=T)), 3)
      
      #Add result to log
      log <- rbind(log, data.frame(k = i, rmse = rmse))
    }
    
    #sort log
    log <- log[order(log$rmse),]
    
    #return log
    return(log)
  }
  
#SET UP TRAIN/TEST
  #Set up data
  set.seed(123)
  rand <- runif(nrow(sampled))
  
  #training set
  xtrain <- as.matrix(sampled[rand < 0.7, c(1,2)])
  ytrain <- sampled[rand < 0.7, 3]
  
  #test set
  xtest <- as.matrix(sampled[rand >= 0.7, c(1,2)]) 
  ytest <- sampled[rand >= 0.7, 3]
  
#Optimize KNN at one k increments
  logs <- knn.opt(xtrain, ytrain, xtest, ytest, nrow(xtest), 1)
  
  #Plot results
  ggplot(logs, aes(x = k, y = rmse)) +
    geom_line() + geom_point() + ggtitle("RMSE vs. K-Nearest Neighbors")
  
#Comparisons
  #Original
  full <- ggplot(us_west, aes(x=lon, y=lat)) +
    geom_raster(aes(fill = ndvi)) +
    ggtitle("Original NASA Tile") +
    scale_fill_gradientn(limits = c(-1,1), colours = rev(terrain.colors(10)))
  
  
  #30% sample
  sampled <- ggplot(sampled, aes(x=lon, y=lat)) +
    geom_raster(aes(fill = ndvi)) +
    ggtitle("Sample: 30%") +
    scale_fill_gradientn(limits = c(-1,1), colours = rev(terrain.colors(10)))   
  
  #Set new test set
  xtest <- as.matrix(us_west[, c(1,2)]) 
  
  #Test k for four different values
  for(k in c(1, 4, 10, 100)){
    yhat <- knn.mean(xtrain,ytrain,xtest, k)
    pred <- data.frame(xtest, ndvi = yhat)
    rmse <- round(sqrt(mean((yhat  - us_west$ndvi)^2, na.rm=T)), 3)
    
    g <- ggplot(pred, aes(x=lon, y=lat)) +
      geom_raster(aes(fill = ndvi)) +
      ggtitle(paste0("kNN (k =",k,", RMSE = ", rmse,")")) +
      scale_fill_gradientn(limits = c(-1,1), colours = rev(terrain.colors(10)))
    
    assign(paste0("k",k), g)
  }
  
  #Graphs plotted
  library(gridExtra) 
  grid.arrange(full, sampled, k1, k4, k10, k100, ncol=2)
  