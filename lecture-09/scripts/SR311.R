library(sqldf)
setwd("/Users/jeff/Documents/Github/data-science/lecture-09/data")
df <- read.csv("311_Service_Requests_from_2010_to_Present.csv")
df$lat <-round(df$Latitude,3)
df$lon <-round(df$Longitude,3)
df$type <- gsub(" ", ".",tolower(df$Complaint.Type))
df <- df[!is.na(df$lat), ]

df2 <- sqldf("SELECT lat, lon, type, COUNT(lat) count
              FROM df
              GROUP BY lat, lon, type")
df3 <- reshape(df2, 
               timevar = "type",
               idvar = c("lat","lon"),
               direction = "wide")
dim(df3)
for(k in ncol(df3):3 ){
  if(sum(df3[,k], na.rm=T) < 500){
    df3[,k] <- NULL
  } else {
    df3[,k][is.na(df3[,k])] <- 0
  }
  
}
dim(df3)
sums <- rowSums(df3[, 3:ncol(df3)])
for(k in 3:ncol(df3)){
  df3[,k] <- df3[,k]/sums
}
df3 <- df3[!is.na(df3[,3]) & !is.nan(df3[,3]),]

df4 <- scale(df3[,c(3:ncol(df3))], scale = TRUE, center = TRUE)


#master
master <- data.frame()

for(i in 2:100){
  new <- kmeans(df4, i)
  master <- rbind(master,
                  data.frame(k = i,
                             ss = new$betweenss))
}
plot(master)
cluster <- kmeans(df4, 12)$cluster

plot(df3$lon, df3$lat, col = factor(cluster), pch = 19, cex = 0.04, , yaxt='n', ann=FALSE, xaxt='n')

kmeansChar <- function(data, clusters, depth = 3){
  
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
    colnames(temp) <- paste0("Var.", 1:depth)
    depth.temp <- rbind(depth.temp, temp)
  }
  depth.temp <- cbind(data.frame(table(cluster)), depth.temp)
  
  return(depth.temp)
  
}


res <- kmeansChar(df3[,3:ncol(df3)], cluster, 5)
