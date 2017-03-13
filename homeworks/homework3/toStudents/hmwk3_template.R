#################
## Homework #3 ##
#################
#Name: 

#Use this script to get the data
  temp <- tempfile()
  download.file("https://github.com/GeorgetownMcCourt/data-science/raw/master/homeworks/homework3/toStudents/homework3_data.Rda", temp, mode="wb")
  load(temp)

#Mean
  meanf1 <- function(actual, predicted){
    #Mean F1 score function
    #actual = a vector of actual labels
    #predicted = predicted labels
    
    classes <- unique(actual)
    results <- data.frame()
    for(k in classes){
      results <- rbind(results, 
                       data.frame(class.name = k,
                                  weight = sum(actual == k)/length(actual),
                                  precision = sum(predicted == k & actual == k)/sum(predicted == k), 
                                  recall = sum(predicted == k & actual == k)/sum(actual == k)))
    }
    results$score <- results$weight * 2 * (results$precision * results$recall) / (results$precision + results$recall) 
    return(sum(results$score))
  }
  
#Write your code and annotation below
#As those records are ones you'll predict
  
  
  
  
  
#Your final submission should contain a dataframe labeled ("myPredictions")
