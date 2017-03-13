library(randomForest)
colnames(health)


train <- cbind(ytrain, xtrain)
colnames(train) <- c("y",paste0("v",seq(1,ncol(train)-1,1)))
fit <- rpart(ytrain ~ ., method="class", data = train)
#RF
fit <- tuneRF(train[,-1], train$y, ntreeTry=200,
               stepFactor=1.5,improve=0.01, trace=TRUE, plot=TRUE)
best.m <- fit[fit[, 2] == min(fit[, 2]), 1]

set.seed(71)
fit <-randomForest(y ~ ., data = train, mtry=best.m, importance=TRUE,ntree=200)
print(rf)

#Accuracy
test <- cbind(ytest, xtest)
colnames(test) <- c("y",paste0("v",seq(1,ncol(test)-1,1)))
tree.pred <- predict(fit, test, type='prob')


pred.obj <- prediction(tree.pred[,2], test[,1])
pred.knn <- performance(pred.obj, "tpr", "fpr")
perf <- performance(pred.obj, "auc")
plot(pred.knn, avg= "threshold", colorize=T, lwd=3, main="Voilà, a ROC curve!")
abline(a = 0, b = 1)
