####################
## KMEANS 311 DATA##
####################

#Set directory
  setwd("/Users/jeff/Documents/Github/data-science/lecture-09/data")

#Load in pre-processed data
  load("nyc311.Rda")

#Check what's in the data
  dim(nyc311)
  colnames(nyc311)
  summary(nyc311)
  
#Custom Function to summarize 
  sumUp <- function(data, clusters, depth = 3, horizontal = FALSE){
    # Summarize cluster variables by most frequent 
    #
    # Args:
    #       data: input data
    #       clusters: vector of cluster labels
    #       depth: top 3 most frequent variables
    #       horizontal: control format of results. FALSE means one cluster per row.
    #
    # Returns:
    #       A data frame of k-number of centroids
    #
    
    #Calculate means, rotate such that features = rows
      overview <- aggregate(data, list(clusters), mean)
      overview <- as.data.frame(cbind(colnames(overview)[2:ncol(overview)], 
                                      t(overview[,2:ncol(overview)])))
      row.names(overview) <- 1:nrow(overview)
      overview[,1] <- gsub("count.","",as.character(overview[,1]))
      
    #Clean up values as numerics
      for(i in 2:ncol(overview)){
        overview[,i] <- round(as.numeric(as.character(overview[,i])),2)
      }
      
    #Get top X features
      depth.temp <- data.frame()
      for(i in 2:ncol(overview)){
        temp <- overview[order(-overview[,i]), ]
        temp <- paste("(",temp[,i], "): ", temp[,1], sep = "")
        temp <- as.data.frame(matrix(temp[1:depth], 
                                     nrow = 1, 
                                     ncol = depth))
        colnames(temp) <- paste0("Rank.", 1:depth)
        depth.temp <- rbind(depth.temp, temp)
      }
      depth.temp <- cbind(data.frame(table(clusters)), depth.temp)
      
    #Rotate?
      if(horizontal == TRUE){
        depth.temp <- t(depth.temp)
      }
      
    return(depth.temp)
  }
  
#What are the 10 most common 311 complaints?
  clusters <- rep(1, nrow(nyc311))
  sumUp(nyc311[,3:ncol(nyc311)], clusters, 10, horizontal = TRUE)
  
#Scale data to meet K-Means requirements
  nyc311.2 <- scale(nyc311[,c(3:ncol(nyc311))], scale = TRUE, center = TRUE)

#Calibrate k-means
#Find elbow
  master <- data.frame()
  
  for(i in seq(2,100,4)){
    print(i)
    new <- kmeans(nyc311.2, i)
    master <- rbind(master,
                    data.frame(k = i,
                               ss = new$betweenss))
  }
  plot(master) 
  
#Run K for "optimal"
  set.seed(20)
  cluster <- kmeans(nyc311.2, 10)$cluster

#Graph results
  #Set color palette
  palette(colorRampPalette(c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a'))(10))
  
  #Graph lat-lons with color coding by cluster
  op <- par(mar = rep(0, 4)) 
  plot(nyc311$lon, nyc311$lat, col = factor(cluster), pch = 15, cex = 0.16, 
       frame.plot=FALSE, yaxt='n', ann=FALSE, xaxt='n')
  legend(x="topleft", bty = "n", legend=levels(factor(cluster)), 
         cex = 1,  x.intersp=0, xjust=0, yjust=0, text.col=seq_along(levels(factor(cluster))))
  par(op)

#Results
  recap <- sumUp(nyc311[,3:ncol(nyc311)], cluster, 5)
