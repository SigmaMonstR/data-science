library(scales)
sd <- 12
n <- 1000
seed <- 100
algo <- "Forgy" #

#Generate data (6 clusters)
  set.seed(seed)
  df <- rbind(data.frame(x = rnorm(n,-50,sd), y = rnorm(n,10,sd)),
              data.frame(x = rnorm(n,10,sd), y = rnorm(n,20,sd)),
              data.frame(x = rnorm(n,10,sd), y = rnorm(n,-60,sd)),
              data.frame(x = rnorm(n,70,sd), y = rnorm(n,-20,sd)),
              data.frame(x = rnorm(n,90,sd), y = rnorm(n,30,sd)),
              data.frame(x = rnorm(n,-10,sd), y = rnorm(n,75,sd)))
  df$cluster <- rep(1:6, rep(n,6))
  cent <- aggregate(df[,1:2], by = list(cluster = df$cluster), mean)
  
#Graphs
par(mfrow=c(2,3))

#Graph data
  op <- par(mar = rep(0, 4)) 
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n',  col = alpha("orange",0.1), 
       frame.plot=FALSE, pch = 19, cex = 0.5, asp = 1)
  text(-50,-50,"Simulated clusters")

#Ideal
  op <- par(mar = rep(0, 4)) 
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n',  col = alpha("orange",0.05), 
       frame.plot=FALSE, pch = 19, cex = 0.5, asp = 1)
  text(-50,-50,"Ideal Outcome")
  points(cent[,2], cent[,3], col = alpha("purple",1), pch = 19, cex = 1.5)
  par(op)
  
#Forgy
  set.seed(100)
  cl <- kmeans(df, 6, algorithm = "Hartigan-Wong")
  op <- par(mar = rep(0, 4)) 
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n',  col = alpha("orange",0.05), 
       frame.plot=FALSE, pch = 19, cex = 0.5, asp = 1)
  text(-50,-50,"Forgy (R = 500)")
  
  for(i in 1:500){
    cl <- kmeans(df, 6,  algorithm = "Forgy")
    cent <- cbind(cl$centers, 1:6)
    points(cent[,1], cent[,2], col = alpha("purple",1/150), pch = 19, cex = 1.5)
    par(op)
  }


#Hartigan-Wong
  set.seed(100)
  cl <- kmeans(df, 6, algorithm = "Hartigan-Wong")
  op <- par(mar = rep(0, 4)) 
  plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n',  col = alpha("orange",0.05), 
       frame.plot=FALSE, pch = 19, cex = 0.5, asp = 1)
  text(-50,-50,"Hartigan-Wong (R = 500)")
  
  for(i in 1:500){
    cl <- kmeans(df, 6, algorithm = "Hartigan-Wong")
    cent <- cbind(cl$centers, 1:6)
    points(cent[,1], cent[,2], col = alpha("purple",1/150), pch = 19, cex = 1.5)
    par(op)
  }
  

#MacQueen
set.seed(100)
op <- par(mar = rep(0, 4)) 
plot(df$x, df$y, yaxt='n', ann=FALSE, xaxt='n',  col = alpha("orange",0.05), 
     frame.plot=FALSE, pch = 19, cex = 0.5, asp = 1)
text(-50,-50,"MacQueen (R = 500)")

for(i in 1:500){
  cl <- kmeans(df, 6, algorithm = "MacQueen")
  cent <- cbind(cl$centers, 1:6)
  points(cent[,1], cent[,2], col = alpha("purple",1/150), pch = 19, cex = 1.5)
  par(op)
}
  

  