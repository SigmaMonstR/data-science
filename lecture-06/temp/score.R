df1 <- read.csv("~/Downloads/worksample 1.csv")
df2 <- read.csv("~/Downloads/worksample2.csv")

worksample <- rbind(df1, df2)
worksample <- worksample[!is.na(worksample[,1]),]
worksample$accel <- sqrt(worksample$user_acc_x.G.^2 + worksample$user_acc_y.G.^2 + worksample$user_acc_z.G.^2 )
plot(worksample$accel, type="l")


worksample$avg <- NA
worksample$max <- NA
worksample$min <- NA
worksample$sd <- NA


for(k in window:nrow(worksample)){
  worksample$avg[k] <- mean(worksample$accel[(k-window):k])
  worksample$max[k] <- max(worksample$accel[(k-window):k])
  worksample$min[k] <- min(worksample$accel[(k-window):k])
  worksample$sd[k] <- sd(worksample$accel[(k-window):k])
  print(k)
}