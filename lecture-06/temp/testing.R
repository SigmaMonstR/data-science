##Example
#Scenario: Let's say you want to characterize the activities of staff in 
#an office that has field activities to understand how their working conditions 
#are like. To do so, you want to characterize the percent of time doing different 
#activities. 
#
#
#1) Feature extraction
#2) 

###
window <- 100

df <- read.csv("~/Downloads/test.csv")

df$avg <- NA
df$max <- NA
df$min <- NA
df$sd <- NA

for(k in window:nrow(df)){
  df$avg[k] <- mean(df$accel[(k-window):k])
  df$max[k] <- max(df$accel[(k-window):k])
  df$min[k] <- min(df$accel[(k-window):k])
  df$sd[k] <- sd(df$accel[(k-window):k])
}

df <- df[(window+1):nrow(df),]
plot(df$max)
points(df$Run)

##Split data
  df$rand <- runif(nrow(df))
  train <- df[df$rand<=0.7,]
  test <- df[df$rand>0.7,]



# grow tree 
  test_vars <- c("Run","Walk","Stand", "Descend.Stairs")
  results <-data.frame()
  
  for(j in test_vars){
    fit <- rpart(as.formula(paste(j," ~  avg + max + min + sd",sep="")), method="class", data=train)
    fit.pruned <- prune(fit, cp = 0.01)
    #printcp(fit) # display the results 
    #plotcp(fit) # visualize cross-validation results 
    #summary(fit) # detailed summary of splits
    
    #Score
      comparison <- data.frame(y = test[[j]], pred = predict(fit.pruned,newdata = test, type="class"))
      results <- rbind(results, data.frame(var = j, comparison))
    #Performance
      conf.matrix <- table(comparison)
      rownames(conf.matrix) <- paste("Actual", rownames(conf.matrix), sep = ":")
      colnames(conf.matrix) <- paste("Pred", colnames(conf.matrix), sep = ":")
      
    
    print(j)
    #print(fit)
    print(conf.matrix)
    print((conf.matrix[1,1]+conf.matrix[2,2])/nrow(test))
  }
 
  
