
#Example data
setwd("/Users/jeff/Documents/Github/data-science/lecture-09/data")
data <- read.csv("WDI-2016.csv")

dropregions <- c('ARB', 'CEB', 'CSS', 'EAP', 'EAR', 'EAS', 'UMC','ECA', 'ECS','SAS', 'EMU','EUU', 'FCS', 'HIC', 'HPC', 'IBD', 'IBT', 'IDA','INX', 'IDB', 'IDX', 'LAC', 'LCN', 'LDC', 'LIC', 'LMC', 'LMY', 'LTE', 'MEA', 'MIC', 'MNA', 'NAC', 'OED', 'OSS', 'PRE', 'PSS', 'PST', 'SSA', 'SSF', 'SST', 'TEA', 'TEC', 'TLA', 'TMN', 'TSA', 'TSS', 'WLD')

data2 <- data[!(data$Country.Code %in% dropregions), ]
data2 <- data2[, c(1,2,3,4,55)]


#Create indicators list
indicators <- data2[!duplicated(data2[,c(3:4)]),c(3,4)]

#Create wide data
data2 <- data2[, c(2,4,5)]
data3 <- reshape(data2, direction = "wide",
                  idvar = "Country.Code",
                  timevar = "Indicator.Code")

#Drop 
data4 <- data3
tablist <- data.frame()
for(k in ncol(data4):2){
  tablist <- rbind(tablist,
                   data.frame(var = k,
                              count = sum(is.na(data4[,k]))/nrow(data4)))
}


#KNN Example
  keeplist <- tablist[tablist$count < 0.1, 1]
  data4 <- data4[,c(1,keeplist)]
  
  #
  #stand
  stand.vec <- function(vec, options = 1){
    if(options == 1){
      #mean-center, sd standard
      vec <- (vec - mean(vec, na.rm = T))/sd(vec, na.rm = T)
      
    } else if(options == 2){
      #range standardization
      vec <- (vec - min(vec, na.rm = T))/(max(vec, na.rm = T) - min(vec, na.rm = T))
    }
    return(vec)
  }
  
  for(k in 2:ncol(data4)){
    data4[,k] <- stand.vec(data4[,k], 1)
  }
  
    #library(VIM)
    data4 <- kNN(data4, k=3)
  
  
  
  dim(data4)
  
  master <- data.frame()
  for(i in 1:182){
    cl <- kmeans(data4[,2:ncol(data4)], centers = i)
    master <- rbind(master,data.frame(k = i, totss = cl$betweenss/cl$totss))
  }
  
  
  library("flexclust")
  data("Nclus")
  
  set.seed(1)
  dat <- as.data.frame(Nclus)
  ind <- sample(nrow(dat), 50)
  
  dat[["train"]] <- TRUE
  dat[["train"]][ind] <- FALSE
  
  cl1 = kcca(dat[dat[["train"]]==TRUE, 1:2], k=5, kccaFamily("kmeans"))
  cl1    
  
  
  pred_train <- predict(cl1)
  pred_test <- predict(cl1, newdata=dat[dat[["train"]]==FALSE, 1:2])
  
  image(cl1)
  points(data4[,c(2,10)], col=pred_train, pch=19, cex=0.3)
  points(data4[,c(2,10)], col=pred_train, pch=22, bg="orange")
  
  points(dat[dat[["train"]]==TRUE, 1:2], col=pred_train, pch=19, cex=0.3)
  points(dat[dat[["train"]]==FALSE, 1:2], col=pred_test, pch=22, bg="orange")

  
#PCA
  
  pcs <- prcomp(data4[,2:ncol(data4)]) 
  print(pcs)
  
  #Scree plot
  plot(pcs, type = "l")
  
  #Importance
  summary(pcs)
  