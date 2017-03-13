#############
##LECTURE 7##
#############

#Set your working drive
  setwd("/Users/jeff/Documents/Github/data-science/lecture-07")

#Libraries required
  #install.packages(c("rpart","rpart.plot", "devtools", "gridExtra", "randomForest" ))
  #devtools::install_github("sachsmc/plotROC")

#Load data 
  health <- read.csv("data/lecture7.csv")
  str(health)

#Randomly subset data into train and test
  set.seed(100)
  rand <- runif(nrow(health)) 
  rand <- rand > 0.5

#Create train test sets
  train <- health[rand == T, ]
  test <- health[rand == F, ]

##################
##DECISION TREES##
##################  
  #Load rpart libraries
    library(rpart)
    library(rpart.plot)
    library(ggplot2)
    library(gridExtra)
    library(plotROC)
  
  #TRAIN MODEL
  #Fit decision tree under default assumptions -- cp = 0
    fit <- rpart(coverage ~ age + wage + cit + mar + educ + race, 
                 method = "class", data = train)
  
  #Tools to review output
    printcp(fit)
  
  #Use rpart.plot 
    rpart.plot(fit, shadow.col="gray", nn=TRUE)
  
  #cp = 0
    fit.0 <- rpart(coverage ~ age + wage + cit + mar + educ + race, 
                   method = "class", data = train, cp = 0)
    
  #Examine printcp to find optimal cp value
    printcp(fit.0)
  
  #Refit with optimal
    fit.opt <- rpart(coverage ~ age + wage + cit + mar + educ + race, 
                     method = "class", data = train, cp = 0.0010281)
    
    rpart.plot(fit.opt, shadow.col="gray", nn=TRUE)
  
  #Determine which variable had the greatest influence
    fit.opt$variable.importance
  
    
  #CALCULATE TEST ACCURACY
  #Predict values for train set
    pred.opt.train <- predict(fit.opt, train, type='prob')[,2]
    pred.0.train <- predict(fit.0, train, type='prob')[,2]
    pred.default.train <- predict(fit, train, type='prob')[,2]
  
  #Predict values for test set
    pred.opt.test <- predict(fit.opt, test, type='prob')[,2]
    pred.0.test <- predict(fit.0, test, type='prob')[,2]
    pred.default.test <- predict(fit, test, type='prob')[,2]
  
  #Set up ROC inputs
    input.test <- rbind(data.frame(model = "optimal", d = test$coverage, m = pred.opt.test), 
                        data.frame(model = "CP = 0", d = test$coverage,  m = pred.0.test),
                        data.frame(model = "default", d = test$coverage,  m = pred.default.test))
    input.train <- rbind(data.frame(model = "optimal", d = train$coverage,  m = pred.opt.train), 
                         data.frame(model = "CP = 0", d = train$coverage,  m = pred.0.train),
                         data.frame(model = "default", d =  train$coverage,  m = pred.default.train))
    
  
  #Graph all three ROCs
    roc.test <- ggplot(input.test, aes(d = d, model = model, m = m, colour = model)) + 
      geom_roc(show.legend = TRUE) + style_roc()  + ggtitle("Test")
    roc.train <- ggplot(input.train, aes(d = d, model = model, m = m, colour = model)) + 
      geom_roc(show.legend = TRUE) + style_roc()  +ggtitle("Train")
  
  #Plot
    grid.arrange(roc.train, roc.test, ncol = 2)
    
##################
##RANDOM FORESTS##
##################  
  
  #Load randomForest library
  library(randomForest)
  
  #Run Random Forest
  fit.rf <- randomForest(coverage ~ age + wage + cit + mar + educ + race, data = train)
  
  #Check OOB error
  fit.rf
  
  #Check tree decay
  plot(fit.rf)
  
  #Search for most optimal number of input features
  fit.tune <- tuneRF(train[,-1], train$coverage, ntreeTry = 500, 
                     mtryStart = 1, stepFactor = 2, 
                     improve = 0.001, trace = TRUE, plot = TRUE)
  fit.tune
  tune.param <- fit.tune[fit.tune[, 2] == min(fit.tune[, 2]), 1]
  
  
  #Predict values for train set
  pred.rf.train <- predict(fit.rf, train, type='prob')[,2]
  
  #Predict values for test set
  pred.rf.test <- predict(fit.rf, test, type='prob')[,2]
  
  
  #Set up ROC inputs
  input.rf <- rbind(data.frame(model = "train", d = train$coverage, m = pred.rf.train), 
                    data.frame(model = "test", d = test$coverage,  m = pred.rf.test))
  
  #Graph all three ROCs
  roc.rf <- ggplot(input.rf, aes(d = d, model = model, m = m, colour = model)) + 
    geom_roc(show.legend = TRUE) + style_roc()  +ggtitle("Train")
  
  #AUC
  calc_auc(roc.rf)

  