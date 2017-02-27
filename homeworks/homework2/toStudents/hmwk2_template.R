#################
## Homework #2 ##
#################
#Name: 

#Use this script to get the data
  temp <- tempfile()
  download.file("https://github.com/SigmaMonstR/rudy.js/raw/master/temp.Rda", temp, mode="wb")
  load(temp)

#Utilities to help you
  mape <- function(yhat, y){
    #yhat = your prediction
    #y = original value
    #Note that code will ignore any missing values
    return(100*mean(abs(yhat/y - 1), na.rm=T))
  }
  
#Write your code and annotation below
#Note: Do not delete records with missing values (particularly in emp),
#As those records are ones you'll predict
  
  
  
  
  
#Your final submission should contain a dataframe labeled ("myPredictions")
