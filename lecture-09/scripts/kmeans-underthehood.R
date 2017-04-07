########################
## KMEANS HOW IT WORKS##
########################

#####1
#For simplicity, the `randomMat()` function below follows the traditional *Forgy* method,
#selected $k$ number of points at random from the sample.

randomMat <- function(x, k){
  # Initializes k-means by calculating the random centroids
  #
  # Args:
  #       x: input data frame -- all read numbers
  #       k: number of centroids
  #
  # Returns:
  #       A data frame of k-number of centroids
  #
  
  #Randomly select k records
  rand <- rank(runif(nrow(x)))[1:k]
  mat <- cbind(cluster = 1:k,  x[rand,])
  
  #Format output table
  mat <- as.data.frame(mat)
  colnames(mat) <- c("cluster", paste0("v",1:ncol(x)))
  return(mat)
}

#####2
#The assignment step involves calculating the distance between each point and centroid, 
#then assigning all points to their respective closest centroid. 

  assignCentroid <- function(x, xref){
    # Assigns each point to a centroid based on distance
    #
    # Args:
    #       x: input data frame
    #       xref: data frame of centroids (from randomMat or updateCentroid)
    #
    # Returns:
    #       A vector of centroid assignments
    #
    
    #Set up placeholder matrix of distances
    out <-  as.data.frame(matrix(NA, ncol = ncol(xref)-1, nrow =nrow(x)))
    
    #Loop through each centroid in xref 
    for(j in 1:nrow(xref)){
      vec <- vector(length = nrow(x))
      
      #Loop through each row to calculate distance components
      for(i in 1:ncol(x)){
        vec <- vec + (x[,i] - xref[j, i+1])^2
      }
      out[,j] <- sqrt(vec)
    }
    
    #Assign cluster based on minimum distance in each row
    out$cluster <- NA
    for(i in 1:nrow(out)){
      out$cluster[i] <- match(min(out[i, 1:nrow(xref)]), out[i, 1:nrow(xref)])
    }
    out <- out$cluster
    return(out)
  }

#####3 Update
  updateCentroid <- function(x, k = 3){
    #
    # Recalculates centroid coordinates for 
    #
    # Args:
    #       x: input data frame -- all read numbers
    #       k: number of centroids
    #
    # Returns:
    #       A data frame of k-number of updated centroids
    #
    temp <- aggregate(x[,1:(ncol(x)-1)], by = list(cluster = x[,ncol(x)]), FUN = mean)
    
    return(temp)
  }


###PUT into practice
#To illustate this, we will randomly generate six clusters of data in two-dimensional space. 
  #Each of these simulated clusters contain $n$ records and a standard deviation $sd = 10$. 
  #The mean coordinates are used to place the clusters at such a distance that is 
  #sufficiently far to distinguish each cluster.

#Parameters
  sd <- 10
  n <- 300

#Generate data (6 clusters)
  df <- rbind(data.frame(x = rnorm(n,-50,sd), y = rnorm(n,10,sd)),
              data.frame(x = rnorm(n,10,sd), y = rnorm(n,20,sd)),
              data.frame(x = rnorm(n,50,sd), y = rnorm(n,-60,sd)),
              data.frame(x = rnorm(n,70,sd), y = rnorm(n,-20,sd)),
              data.frame(x = rnorm(n,90,sd), y = rnorm(n,10,sd)),
              data.frame(x = rnorm(n,-10,sd), y = rnorm(n,75,sd)))

#Graph clusters
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n', 
       frame.plot=FALSE, pch = 19, cex = 0.2, asp = 1)
  text(-50,-50,"Simulated Points")

#Set k
  k <- 6

#INITIALIZE CENTROIDS
  ref.file <- randomMat(df, k)

#PLOT INITIAL
#Set up graph to place two graphs side by side

#Plot initial graph
  op <- par(mar = rep(0, 4))
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n', 
       frame.plot=FALSE, pch = 19, cex = 0.2, asp = 1)
  text(-50,-50,"Iter = 0")
  points(ref.file$v1, ref.file$v2, col = "white", pch = 19, cex = 2.1)
  points(ref.file$v1, ref.file$v2, col = ref.file$cluster, pch = 19, cex = 2)
  par(op)

#ASSIGN FIRST CENTROID
  df2 <- df
  df2$out <- assignCentroid(df, ref.file)

#plot
  op <- par(mar = rep(0, 4)) 
  plot(df2$x, df2$y, yaxt='n', ann=FALSE, xaxt='n',  col = df2$out, 
       frame.plot=FALSE, pch = 19, cex = 0.2, asp = 1)
  text(-50,-50, "Iter = 1")
  points(ref.file$v1, ref.file$v2, col = "black", pch = 19, cex = 2.2)
  points(ref.file$v1, ref.file$v2, col = ref.file$cluster, pch = 19, cex = 2)
  par(op)



#Iterations
  #Flag for controlling while loop. 0 if convergence not reached
    done <- 0
  
  #Count of number of records that have reached convergence. 10 is random seed
    prior <- 10
  
  #Counter of number of iterations
    counter <- 2

  #While loop to automate the run
  while(done == 0){
    #ASSIGN centroid
      df2$out <- assignCentroid(df, updateCentroid(df2))
      
    #UPDATE centroid
      ref.file <- updateCentroid(df2, k)
      
    #PLOT result
      op <- par(mar = rep(0, 4))
      plot(df2$x, df2$y, yaxt='n', ann=FALSE, xaxt='n',  col = df2$out, 
      frame.plot=FALSE, pch = 19, cex = 0.2, asp = 1)
      text(-50,-50, paste0("Iter = ",counter))
      points(ref.file[,2], ref.file[,3], col = "black", pch = 19, cex = 2.2)
      points(ref.file[,2], ref.file[,3], col = ref.file[,1], pch = 19, cex = 2)
      par(op)
    
    #CHECK CHANGES IN ASSIGNMENTS
      if(sum(prior == df2$out) == nrow(df2)){
      done <- 1
      } else {
      prior <- df2$out
      counter <- counter + 1
      }
  }

