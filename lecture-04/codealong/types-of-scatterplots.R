#Examples of scatter plots

library(ggplot2)
datagen <- function(n,p_list){
  x1    <- rnorm(n, 1, 1)        # fixed given data
  df <- data.frame(x1)
  for(p in p_list){
    theta <- acos(p)             # corresponding angle
    x2    <- rnorm(n, 2, 0.5)      # new random data
    X     <- cbind(x1, x2)         # matrix
    cent  <- scale(X, center=TRUE, scale=FALSE)   # centered columns (mean 0)
    
    Id   <- diag(n)                               # identity matrix
    Q    <- qr.Q(qr(cent[ , 1, drop=FALSE]))      # QR-decomposition, just matrix Q
    P    <- tcrossprod(Q)          # = Q Q'       # projection onto space defined by x1
    x2o  <- (Id-P) %*% cent[ , 2]                 # x2ctr made orthogonal to x1ctr
    Xc2  <- cbind(cent[ , 1], x2o)                # bind to matrix
    Y    <- Xc2 %*% diag(1/sqrt(colSums(Xc2^2)))  # scale columns to length 1
    
    x <- Y[ , 2] + (1 / tan(theta)) * Y[ , 1]     # final new vector
    cor(x1, x)  
    df <- cbind(df,x)
  }
  colnames(df)<- c("x",paste0("x",p_list))
  return(df)
}



df <- datagen(500,c(0.1,0.5,0.7,0.9))
colnames(df)<-c("y","x1","x2","x3","x4")

##Scatter plot
p = ggplot(df,aes(x=x4,y=y))  +
  xlab("x4") +
  ylab("y")
p1 = p + geom_point() + ggtitle("scatter")
p2 = p + geom_point(alpha = 0.1, colour="navy") +
  theme_bw() + ggtitle("scatter (alpha = 0.1)")

##Hexbin
p3 = p +
  stat_bin_hex(colour="white", na.rm=TRUE,alpha=0.9) +
  scale_fill_gradientn(colours=c("lightgrey","navy"), name = "Frequency", na.value=NA) + 
  guides(fill=FALSE) + ggtitle("hexbin")

#Scatter by Group
p4  = ggplot(df,aes(x=x4,y=y,colour=as.factor(round(x2*10,1)*20)))+
      ggtitle("scatter by group") + theme(legend.position="none") +
      geom_point(alpha = 0.3)

p5  = p + ggtitle("contour")+ 
      geom_density2d() + 
      theme_bw()

p6 = ggplot(df, aes(x=x4, y=y)) + ggtitle("scatter + regression line")+
    geom_point(shape=1,alpha = 0.6, colour="navy") + 
    geom_smooth()     
grid.arrange(p1,p2,p3,p4,p5,p6, ncol=3)
 