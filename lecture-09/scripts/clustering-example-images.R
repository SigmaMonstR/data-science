#######################
## IMAGE CLUSTERING ###
#######################

#Install
#install.packages("jpeg") 

#Directory
  setwd("/Users/jeff/Documents/Github/data-science/lecture-09/data")

#Library
  library(jpeg)
  library(raster)

#Palette
  palette(colorRampPalette(c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a'))(10))

########
##MOON##
########
#Read in grayscale
  img <- readJPEG("full_moon_grayscale_by_stardust4ever-d3c1jmw.jpg", native = TRUE)

#Multi
  par(mfrow=c(2,3))
  
#Original
  data <- matrix(as.vector(img), nrow = nrow(img), ncol = ncol(img), byrow = TRUE)

  par(mar=c(0,0,0,0))
  plot(raster(data), box=FALSE, xlim = c(0,1), ylim = c(0,1), 
       yaxt='n', ann=FALSE, xaxt='n', bty="n",asp = 1200/1600,legend = FALSE)
  text(0.8,0.9,"Original")

#K values
  for(i in 2:6){
    a <- kmeans(as.vector(img), i)
    data2 <- matrix(a$cluster, nrow = nrow(img), ncol = ncol(img), byrow = TRUE)
    plot(raster(data2), box=FALSE, xlim = c(0,1), ylim = c(0,1), asp = 1200/1600, 
         yaxt='n', ann=FALSE, xaxt='n', bty="n", frame.plot=FALSE, legend = FALSE)
    text(0.8,0.9,paste("k = ",i))
  }

  
#############
##CAMPBELLS##
##############
  #Read in grayscale
  img <- readJPEG("campbells.jpg", native = TRUE)
  
  #Multi
  par(mfrow=c(2,3))
  
  #Original
  data <- matrix(as.vector(img), nrow = nrow(img), ncol = ncol(img), byrow = TRUE)
  
  par(mar=c(0,0,0,0))
  plot(raster(data),xlim = c(0,1),ylim = c(0,1), box=FALSE, asp = 1/0.5827664,
       yaxt='n', ann=FALSE, xaxt='n', bty="n",legend = FALSE)
  text(0.8,0.9,"Original")
  
  #K values
  for(i in 2:6){
    a <- kmeans(as.vector(img), i)
    data2 <- matrix(a$cluster, nrow = nrow(img), ncol = ncol(img), byrow = TRUE)
    plot(raster(data2), box=FALSE, xlim = c(0,1), ylim = c(0,1), asp = 1/0.5827664, 
         yaxt='n', ann=FALSE, xaxt='n', bty="n", frame.plot=FALSE, legend = FALSE)
    text(0.8,0.9,paste("k = ",i))
  }
  
  
  
########
##NILE##
########
  #Read in grayscale
  img <- readJPEG("nile.jpg", native = TRUE)
  
  #Original
  data <- matrix(as.vector(img), nrow = nrow(img), ncol = ncol(img), byrow = TRUE)
  
  #K values
  set.seed(123)
  
  a <- kmeans(scale(as.vector(img)), 2)
  data2 <- matrix(a$cluster, nrow = nrow(img), ncol = ncol(img), byrow = TRUE)
  
  #Plot
  plot(raster(data2), box=FALSE, xlim = c(0,1), ylim = c(0,1), asp = 1200/1600, 
       yaxt='n', ann=FALSE, xaxt='n', bty="n", frame.plot=FALSE, legend = TRUE)
  text(0.8,0.9,paste("k = ",2))
  
  
########
##CROPS#
########
  #Read in grayscale
  img <- readJPEG("kansas_AST_2001175_lrg.jpg", native = TRUE)
  
  #Original
  data <- matrix(as.vector(img), nrow = nrow(img), ncol = ncol(img), byrow = TRUE)

  #K values 
    set.seed(123)
    a <- kmeans(as.vector(img), 3)
    data2 <- matrix(a$cluster, nrow = nrow(img), ncol = ncol(img), byrow = TRUE)

    
  #Plot (cluster 3 is the crops)
    sum(a$cluster == 3)/length(a$cluster)
    
    plot(raster(data2), box=FALSE, xlim = c(0,1), ylim = c(0,1), asp = 1200/1600, 
         yaxt='n', ann=FALSE, xaxt='n', bty="n", frame.plot=FALSE, legend = TRUE)
    
   