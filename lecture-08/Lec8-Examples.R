#############
##LECTURE 8##
#############

############
##CONTENTS##
############
#1. GLM
#2. SVM
#3. Decision Tree recap
#4. Random Forests recap
#5. KNN

##
#Set your working drive
  setwd("/Users/jeff/Documents/Github/data-science/lecture-08")

#Libraries required
  #install.packages(c("e1071" ))

#Load data 
  health <- read.csv("data/lecture8.csv")
  str(health)
  

#Randomly subset data into train and test
  set.seed(100)
  rand <- runif(nrow(health)) 
  rand <- rand > 0.5
  

#Create train test sets
  train <- health[rand == T, ]
  test <- health[rand == F, ]
  scores <- data.frame()
  
#Load F1 Score
  #F1 score
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
  
##################
##GLM Logistic  ##
##################  
  
  #Estimate model
  glm.fit <- glm(coverage ~ age + cit, data = train, family = binomial())
  summary(glm.fit)
  exp(glm.fit$coefficients)
  
  #Refine
  glm.fit <- glm(coverage ~ ., data = train, family = binomial())
  summary(glm.fit)
  
  #predict scores
  pred.glm.train <- predict(glm.fit, train, type = "response")
  pred.glm.test <- predict(glm.fit, test, type = "response")
  summary(pred.glm.train)
  
  #plotROC
  library(plotROC)
  library(ggplot2)
  
  #Set up ROC inputs
  input.glm <- rbind(data.frame(model = "train", d = train$coverage, m = pred.glm.train), 
                     data.frame(model = "test", d = test$coverage,  m = pred.glm.test))
  scores <- rbind(scores, data.frame(model = "GLM", d = test$coverage,  m = pred.glm.test >= 0.5))
  
  #Graph all three ROCs
  roc.glm <- ggplot(input.glm, aes(d = d, model = model, m = m, colour = model)) + 
    geom_roc(show.legend = TRUE) + style_roc()  + ggtitle("ROC: GLM")
  
  #AUC
  calc_auc(roc.glm)[,2:3]
  
  #Mean F1
  pred.labels <- pred.glm.test > 0.5
  pred.labels[pred.labels==TRUE ] <- "No Coverage"
  pred.labels[pred.labels==FALSE ] <- "Coverage"
  
  meanf1(test$coverage, pred.labels)
  
##################
##SUPPORT VECTORS##
##################  
  #Load rpart libraries
    library(e1071)
  
  #TRAIN MODEL
  #Fit SVM  under default assumptions -- cost = 1, gamma = 0.055
    svm.rbf.fit <- svm(coverage ~ age + cit, data=train, kernel = "radial", 
                       cost = 1, gamma = 0.05555)
  
  #Tools to review output
    print(svm.rbf.fit)
    
  #Calibrate SVMs
    pred.test <- svm(coverage ~ ., data = train, kernel = "radial", cost = 1, gamma = 8)
    print(pred.test)
    
  #Predict
    pred.rbf <- predict(pred.test, test)
    scores <- rbind(scores, data.frame(model = "SVM", d = test$coverage,  m = pred.rbf))
    
  #examine result
    table(pred.rbf)
    
  ##RBF
    meanf1(test$coverage, pred.rbf)
    
    
##################
##DECISION TREES##
##################  
    library(rpart)
    
    fit.opt <- rpart(coverage ~ ., 
                     method = "class", data = train, cp = 1.0885e-03)
    
    pred.default.test <- predict(fit.opt, test, type='prob')[,2]
    scores <- rbind(scores, data.frame(model = "Decision Tree", d = test$coverage,  m = pred.default.test >=0.5))
    
##################
##RANDOM FORESTS##
##################  
    
    library(randomForest)
    fit.rf <- randomForest(coverage ~ age + wage + cit + mar + educ + race, data = train)
    fit.tune <- tuneRF(train[,-1], train$coverage, ntreeTry = 500, 
                       mtryStart = 1, stepFactor = 2, 
                       improve = 0.001, trace = TRUE, plot = TRUE)
    tune.param <- fit.tune[fit.tune[, 2] == min(fit.tune[, 2]), 1]
    pred.rf.test <- predict(fit.rf, test, type='prob')[,2]
    scores <- rbind(scores, 
                    data.frame(model = "rf", d = test$coverage,  m = pred.rf.test >=.5))
    scores$m[scores$m == "TRUE"] <- "No Coverage"
    scores$m[scores$m == "FALSE"] <- "Coverage"

##################
## KNNs CLASS  ##
##################  
    library(class)
    age <- round(health$age / 10) * 10
    age <- factor(age)
    
    #Wage
    wage <- round(health$wage / 20000) * 20000
    wage[wage > 200000] <- 200000
    wage <- factor(wage)
    
    #Convert data into binary
    cit <- as.data.frame(model.matrix(~ health$cit - 1)[, 2])
    mar <- as.data.frame(model.matrix(~ health$mar - 1)[,1:4])
    educ <- as.data.frame(model.matrix(~ health$mar - 1)[,1:4])
    race <- as.data.frame(model.matrix(~ health$race - 1)[,1:7])
    wage <- as.data.frame(model.matrix(~ wage - 1)[,2:11])
    age <- as.data.frame(model.matrix(~ age - 1)[,2:8])
    
    #Combine all the newly transformed data
    knn.data <- as.data.frame(cbind(coverage = as.character(health$coverage), 
                                    wage, age, cit, educ, mar, race))
    
    #Train-Test 
    rand <- runif(nrow(knn.data)) 
    rand <- rand > 0.5
    
    #Create x-matrix. Use "-1" in the column argument to keep everything except column 1
    xtrain <- knn.data[rand == T, -1]
    xtest <- knn.data[rand == F, -1]
    
    #Create y-matrix
    ytrain <- knn.data[rand == T, 1]
    ytest <- knn.data[rand == F, 1]
    
    #Run model
    pred <- knn(xtrain, xtest, cl = ytrain, k = 30, prob = TRUE) 
    
    #Extract probabilities
    test.prob <- attr(pred, "prob")
    
    #TPR 
    pred.class <- test.prob
    pred.class[test.prob >= mean(test.prob)] <- "Coverage"
    pred.class[test.prob < mean(test.prob)] <- "No Coverage"
    
    scores <- rbind(scores, data.frame(model = "KNN", d = ytest,  m = pred.class))
    
    
##Comparison
    for(z in unique(scores$model)){
      print(paste(z, ": ",  meanf1(scores[scores$model==z,"d"], scores[scores$model==z,"m"])))
    }
   