# 2.1.1

(X <- data.frame(id=c(1,1,2,2), t=c(1,2,1,2), income=c(50,55,101,123), vote=c(8,7,4,3)))

(wide <- reshape(X, idvar="id", timevar="t", direction="wide"))
(long <- reshape(wide, idvar="id", timevar="t", direction="long"))

names(long)[names(long) == "income.1"] <- "income"



aggregate(iris[c("Sepal.Length")], by=list(iris$Species), FUN=function(x) {return(x[35])})