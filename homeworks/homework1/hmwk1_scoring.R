#Homework #1 Quantitative Scoring
#This code was used to score the quantitative portion of your homework
#The folder structure: A folder named "homework" that contains "answer_key.csv"
#and a folder named "input" that contains your homework
#Note that "answer_key.csv" contains three columns to match cases where MSA code was reported instead of MSA name

  #Set directory
  dir <- "<homework 1 folder>"
  
  answers <- read.csv(paste0(dir,"/answer_key.csv"))
  answers$msa.name <- as.character(answers$msa.name)
  scores <- data.frame()
  files <- list.files(paste0(dir,"/inputs/."))
  
  for(k in files){
    print(k)
    student <- read.csv(paste0(dir,"/inputs/",k))
    
    #Trim blank column
    print("Remove first column if blank")
    if(ncol(student)==3){
      student <- student[,2:3]
      print("Removed")
    }
    
    #Check if column names are accurate 
    print("Check column names")
    if(sum(c("msa","mean") %in% colnames(student))==2){
      columns <- 1
      colnames(student) <- c("msa","mean.s")
    } else {
      columns <- 0
      colnames(student) <- c("msa","mean.s")
    }
    student$msa <- trimws(as.character(student$msa))
    answers$msa.name <- trimws(as.character(answers$msa.name))
    
    #If msa column is accurate
    print("Merge columns")
    res1 <- merge(answers, student, by.x = "msa.name", by.y = "msa", all.x=T)
    res2 <- merge(answers, student, by.x = "msa.code", by.y = "msa", all.x=T)
    
    if(sum(!is.na(res1$mean.s)) > 1){
      print("Matched on names")
      rows <- sum(!is.na(res1$mean.s))/nrow(res1)
      res1 <- res1[res1$mean>0, ]
      mape <- mean(abs(res1$mean.s/res1$mean-1), na.rm = T)
      
    } else if(sum(!is.na(res2$mean.s)) > 1){
      print("Matched on numbers")
      rows <- sum(!is.na(res2$mean.s))/nrow(res2)
      res2 <- res1[res2$mean>0, ]
      mape <- mean(abs(res2$mean.s/res2$mean-1), na.rm = T)
      
    } 
    
    #Add student's score to scores data frame
    print("Append")
    scores <- rbind(scores,
                    data.frame(file = k,
                               mape = mape,
                               rows = rows, 
                               columns = columns,
                               mape_score = (1-mape)*4,
                               row_score = rows,
                               columns_score = columns
                               ))
  }
  
  #Round scores
    scores$total <- round(scores$mape_score + scores$row_score + scores$columns_score,1)
    
  #Extract student name
    scores$file <- gsub("Homework\\s+\\#1_[[:alnum:]]{3,6}_attempt_[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{2}_","",scores$file)
    scores$file <- gsub("-hmwk1\\.csv","",scores$file)
    
  #Write out file to root
    write.csv(scores,paste0(dir,"/scored_hmwk1.csv"),row.names=F)
    