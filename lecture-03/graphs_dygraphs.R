setwd("/Users/jeff/Documents/Github/data-science/lecture-03/example_data")
files <- list.files()


install.packages("dygraphs")
library(dygraphs)

for(i in files){
  temp <- read.csv(i)
  temp$accel <- sqrt(temp$user_acc_x.G.^2 + temp$user_acc_y.G.^2 + temp$user_acc_z.G.^2)
  temp <- temp[!is.na(temp$accel) & temp$accel!="",]
  print(nrow(temp))
  temp <- temp[(nrow(temp)-10000):nrow(temp),]
  
  temp$timestamp.unix. <- round(temp$timestamp.unix./0.25,0)*0.25
  temp <- temp[,c("timestamp.unix.","accel")]
  temp_val <- aggregate(x = temp$accel, by=list(temp$timestamp.unix.), FUN=mean, na.rm=TRUE)
  colnames(temp_val) <- c("time","accel")
  temp_val$time <- temp_val$time - min(temp_val$time)
  
  temp_val <- temp_val[order(temp_val$time),]
  temp_val[,1] <- as.POSIXct(as.numeric(as.character(temp_val[,1])),origin="1970-01-01")
  
  xts_temp <- xts(temp_val[,2], order.by=temp_val[,1])
  assign(gsub(".csv","",i),xts_temp)
}


dygraph(exercise, main = "", group = "other")
dygraph(`easyjet landing berlin`, main = "", group = "other")
dygraph(walking, main = "", group = "other") %>% dyRangeSelector()



