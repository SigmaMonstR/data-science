
#2d
set.seed(100)
x <- rnorm(4000,3,0.2)
y <- rnorm(4000,3,0.2)
xw <- runif(10000)*4
yw <- runif(10000)*4

data <- rbind(data.frame(x = x, y = y, colour = "green"), data.frame(x = xw,y = yw, colour = "grey"))
data$xr <- round(data$x,1)
data$yr <- round(data$y,1)
data$flag <- 1
data$flag[data$colour == "grey"] <- 0 
temp <- aggregate(data$flag, by = list(xr = data$xr, yr = data$yr), FUN = mean)
colnames(temp) <- c("xr", "yr", "mean")
data <- merge(data, temp, by = c("xr", "yr"))
data <- data[!(data$flag == 0 & data$mean > 0), ]


data$colour <- as.character(data$colour)

plot(data$x, data$y, col = data$colour, pch = 19, cex = 0.3)
  
  
x1 <- seq(-10, 10, length.out = 50)  
x2 <- x1  
df <- expand.grid(x1, x2)
zf <- function(x,y){x1^2 + x2^2}
z<-outer(x1, x2, zf)

kernel <- persp(x1, x2, z, col = "grey", theta = 30,  phi = -20, 
                ltheta = -120, shade = 1, border = NA, box = TRUE)

s = sample(1:prod(dim(z)), size=1000)
xx = x1[row(z)[s] ]
yy = x2[col(z)[s]]
zz = z[s] + 10

# depth calculation function (adapted from Duncan Murdoch at https://stat.ethz.ch/pipermail/r-help/2005-September/079241.html)
depth3d <- function(x,y,z, pmat, minsize=0.2, maxsize=2) {
  
  # determine depth of each point from xyz and transformation matrix pmat
  tr <- as.matrix(cbind(x, y, z, 1)) %*% kernel
  tr <- tr[,3]/tr[,4]
  
  # scale depth to point sizes between minsize and maxsize
  psize <- ((tr-min(tr) ) * (maxsize-minsize)) / (max(tr)-min(tr)) + minsize
  return(psize)
}

# determine distance to eye
psize = depth3d(xx,yy,zz,kernel,minsize=0.1, maxsize = 0.3)

mypoints <- trans3d(xx, yy, zz, pmat=kernel)

# plot in 2D space with pointsize related to distance
points(mypoints, pch=19, cex=psize, col=4)
points(mypoints, pch=19, cex=psize, col=4)
