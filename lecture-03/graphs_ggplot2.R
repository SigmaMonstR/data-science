setwd("/Users/jeff/Documents/Github/data-science/lecture-03/example_data")
files <- list.files()

library(ggplot2)
library(gridExtra)
options(digits.secs=6)
for(i in files){
  temp <- read.csv(i, )
  temp$accel <- sqrt(temp$user_acc_x.G.^2 + temp$user_acc_y.G.^2 + temp$user_acc_z.G.^2)
  temp <- temp[!is.na(temp$accel) & temp$accel!="",]
  print(nrow(temp))
  temp <- temp[(nrow(temp)-8000):nrow(temp),]
  
 
  temp<-temp[order(temp$timestamp.unix.),]
  graph <- ggplot(temp, aes(x=timestamp.unix., y=accel)) + 
          geom_line(alpha = 0.6, colour="navy",size = 0.2) + 
          xlab("Time") + ylab("m^2/s") + geom_smooth()+
           coord_cartesian(ylim = c(0, 1)) 
  assign(gsub(".csv","",i),graph)
  assign
}

grid.arrange( walking, `exercise`,`easyjet landing berlin`, ncol=1)
