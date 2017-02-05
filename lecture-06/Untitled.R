df<- read.csv("~/Downloads/Seattle_Real_Time_Fire_911_Calls.csv")

library(plyr)
df$Type <- as.character(df$Type)
df$Datetime <- as.character(df$Datetime)
df <- df[2:nrow(df),]



df$Datetime <- gsub("[ ][+]0{4}","", df$Datetime)
df$Datetime <-  as.POSIXct(df$Datetime,format = "%m/%d/%Y %I:%M:%S %p")
df$Date <- as.Date(format(df$Datetime, "%m/%d/%Y" ),"%m/%d/%Y")
df <- df[df$Type=="Aid Response",]

events <- count(df,c('Type'))

df_count <- count(df,c('Date'))
df_count <- df_count[order(df_count$Date),]
df_count$month <- format(df_count$Date, "%m")
df_count$weekday <- weekdays(df_count$Date)
df_count$id <- 1:nrow(df_count)


train <- df_count[ df_count$id<2000 & df_count$freq<500,]
test  <- df_count[df_count$freq <500 & df_count$freq > 0  & df_count$id>2000 ,] 

fit <- lm(log(freq) ~ id + factor(month) factor(weekday), data=train)
summary(fit)
y_hat <- predict.lm(fit,test)

plot(train$id,log(train$freq), col="grey")
lines(train$id,log(train$freq), col="black")
lines(test$id, y_hat, col="red")

plot(test$id,log(test$freq), col="grey")
lines(test$id,test$freq, col="black")
lines(test$id, y_hat, col="red")


test$smoothed <- NA
for(k in 1:2:nrow(df_count)){
  
}
library(ggplot2)
ggplot(df_count, aes(x=Date, y=freq)) + 
  geom_line(alpha = 0.6, colour="navy",size = 0.2) + 
  xlab("Time") + ylab("incidents") + geom_smooth()+
  coord_cartesian(ylim = c(0, 500)) 


