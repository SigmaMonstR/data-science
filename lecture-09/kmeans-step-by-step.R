#################################
#Kmeans Algorithm: Step by Step #
#################################

#Note that these examples are meant to be illustrative of a 2-dimensional clustering example to provide context

###########
#FUNCTIONS#
###########

#Create Initial Random Assignments
randomMat <- function(x, k){
  #Set matrix: Col1 = cluster ID, all others are random values
  mat <- as.data.frame(matrix(NA, ncol = ncol(x)+1, nrow =k))
  
  #Label clusters
  mat[,1] <- 1:k
  
  #Draw random value for each variable 
  for(i in 1:ncol(x)){
    mat[,i+1] <- rnorm(k, mean(x[,i]), sd(x[,i]))
  }
  
  #Prep output
  mat <- as.data.frame(mat)
  colnames(mat) <- c("cluster", paste0("v",1:ncol(x)))
  return(mat)
}

#Calculate new centroid
updateCentroid <- function(x, clust = 3){
  
  temp <-  as.data.frame(matrix(NA, ncol = ncol(x), nrow = max(x[,clust])))
  temp[,1] <- 1:max(x[,clust])
  for(i in 1:(ncol(x)-1)){
    a <- aggregate(x[,i], by = list(cluster  = x[,clust]), FUN = mean)
    temp[, i+1] <- a[,2]
  }
  
  return(temp)
}

#Assign Centroids 
assignCentroid <- function(x, xref){
  #Set up placeholder
  out <-  as.data.frame(matrix(NA, ncol = ncol(xref)-1, nrow =nrow(x)))
  
  #Loop through each centroid in reference
  for(j in 1:nrow(xref)){
    vec <- vector(length = nrow(x))
    
    #Loop through each row to calculate distance components
    for(i in 1:ncol(x)){
      vec <- vec + (x[,i] - xref[j, i+1])^2
    }
    
    #Save out
    out[,j] <- vec
  }
  
  #Match cluster
  out$cluster <- NA
  for(i in 1:nrow(out)){
    out$cluster[i] <- match(min(out[i, 1:nrow(xref)]), out[i, 1:nrow(xref)])
  }
  
  out <- out$cluster
  
  return(out)
}


#######
#TEST #
#######  
  
  #Parameters
  sd <- 5
  n <- 200
  k <- 8
  
  #Generate data
  df <- rbind(data.frame(x = rnorm(n,-30,sd), y = rnorm(n,10,sd)),
              data.frame(x = rnorm(n,10,sd), y = rnorm(n,20,sd)),
              data.frame(x = rnorm(n,20,sd), y = rnorm(n,50,sd)),
              data.frame(x = rnorm(n,20,sd), y = rnorm(n,-60,sd)),
              data.frame(x = rnorm(n,60,sd), y = rnorm(n,-20,sd)),
              data.frame(x = rnorm(n,0,sd), y = rnorm(n,-30,sd)),
              data.frame(x = rnorm(n,40,sd), y = rnorm(n,10,sd)),
              data.frame(x = rnorm(n,-10,sd), y = rnorm(n,75,sd)))
  
  #Set Clusters
  
  #Base Graph
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n', 
       frame.plot=FALSE, pch = 19, cex = 0.5)
  text(-30,-50, "Iter = 0")
  
  #Initialization
  
  ref.file <- randomMat(df, k)
  df2 <- df
  df2$out <- assignCentroid(df, ref.file)
  
  #Random Centroids
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n', 
       frame.plot=FALSE, pch = 19, cex = 0.5)
    text(-30,-50, "Iter = 0")
    points(ref.file$v1, ref.file$v2, col = "white", pch = 19, cex = 2.1)
    points(ref.file$v1, ref.file$v2, col = ref.file$cluster, pch = 19, cex = 2)
  
  
  #Graph: First Assignments
  library(ggplot2)
  plot(df2$x, df2$y, yaxt='n', ann=FALSE, xaxt='n',  col = df2$out, 
       frame.plot=FALSE, pch = 19, cex = 0.5)
    text(-30,-50, "Iter = 1")
    points(ref.file$v1, ref.file$v2, col = "black", pch = 19, cex = 2.2)
    points(ref.file$v1, ref.file$v2, col = ref.file$cluster, pch = 19, cex = 2)
  
  
  #Iterations
  done <- 0
  prior <- 10
  counter <- 2
  
  while(done == 0){
    #Calculate assignments #2
    df2$out <- assignCentroid(df, updateCentroid(df2))
    
    #Find centroid
    ref.file <- cbind(aggregate(df2$x, by = list(cluster = df2$out), FUN = mean),
                      aggregate(df2$y, by = list(cluster = df2$out), FUN = mean)[,2])
    
    #Plot graph
    plot(df2$x, df2$y, yaxt='n', ann=FALSE, xaxt='n',  col = df2$out, 
         frame.plot=FALSE, pch = 19, cex = 0.5)
    text(-30,-50, paste0("Iter = ",counter))
    points(ref.file[,2], ref.file[,3], col = "black", pch = 19, cex = 2.2)
    points(ref.file[,2], ref.file[,3], col = ref.file[,1], pch = 19, cex = 2)
    
    
    
    if(sum(prior == df2$out) == nrow(df2)){
      done <- 1
    } else {
      prior <- df2$out
      counter <- counter + 1
    }
    print(counter)
  }
  
