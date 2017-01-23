
#Lecture 2- Codealong

setwd("/Users/jeff/Documents/Github/data-science/lecture-02/data")


####How many planned applause breaks in 2010 versus 2016?

#2010
#read in lines from the text
  speech10 <- readLines("sotu_2010.txt")

#remove any blank lines
  speech10 <- speech10[speech10!=""]

#get string position of each Applause (returns positive values if matched)
  ind <- regexpr("Applause", speech10)
  sum(attr(ind,"match.length")>1)

#2016
  speech16 <- readLines("sotu_2016.txt")
  speech16 <- speech16[speech16!=""]
  ind <- regexpr("Applause", speech16)
  sum(attr(ind,"match.length")>1)


####Which words were more important in each year?

#2010
#Clean up and standardize values
  clean10 <- gsub("[[:punct:]]","",speech10)
  clean10 <- gsub("[[:digit:]]","",clean10)
  clean10 <- gsub("[^[:graph:]]"," ",clean10)

#convert into bag of words
  bag10 <- strsplit(clean10," ")
  bag10 <- tolower(trimws(unlist(bag10)))

#Count the number of times a word shows up
  counts10 <- aggregate(bag10, by=list(bag10), FUN=length)
  colnames(counts10) <- c("word","freq")
  counts10$len <- nchar(as.character(counts10$word))
  counts10 <- counts10[counts10$len>2,]
  counts10 <- counts10[order(-counts10$freq),]
  head(counts10, 10)

#2016
  clean16 <- gsub("[[:punct:]]","",speech16)
  clean16 <- gsub("[[:digit:]]","",clean16)
  clean16 <- gsub("[^[:graph:]]"," ",clean16)

  bag16 <- strsplit(clean16," ")
  bag16 <- tolower(trimws(unlist(bag16)))
  
  counts16 <- aggregate(bag16, by=list(bag16), FUN=length)
  colnames(counts16) <- c("word","freq")
  counts16$len <- nchar(as.character(counts16$word))
  counts16 <- counts16[counts16$len>2,]
  counts16 <- counts16[order(-counts16$freq),]
  head(counts16,10)

#Remove stopwords
  
  library(rvest)
  #Get stopwords
  stop1 <- read_html("http://www.lextek.com/manuals/onix/stopwords1.html")
  
  stopwords <- stop1 %>% 
    html_nodes("pre") %>%
    html_text() 
  
  stoplist <- unlist(strsplit(stopwords,"\n"))
  stoplist <- stoplist[stoplist!="" & nchar(stoplist)>1]
  stoplist <- stoplist[4:length(stoplist)]
  
#Remove stopwrods
  counts10 <- counts10[!(counts10$word %in% stoplist),]
  counts16 <- counts16[!(counts16$word %in% stoplist),]
  
  head(counts10,10)
  head(counts16,10)

##TFIDF - Term Frequency Inverse Document Frequency
  #TF =  (# of times term t appears in a document) / (Total number of terms in the document).
  #IDF = exp(# of documents / # documents with term t in it) 
  
  master <- merge(counts10, counts16, by = "word", all.x=T, all.y = T)
  colnames(master) <- c("word", "freq10", "len10", "freq16","len16")
  master[is.na(master)]<-0
  
  
  master$tf10 <- master$freq10/sum(master$freq10) 
  master$tf16 <- master$freq16/sum(master$freq16) 
  master$docs_term <- (master$freq10 > 0) + (master$freq16 > 0)
  master$idf <- exp(2/master$docs_term)
  master$tfidf10 <- master$tf10 * master$idf
  master$tfidf16 <- master$tf16 * master$idf
  
  master <- master[,c(1,2,4,10,11)]
  
  
  library(wordcloud)
  set.seed(123)
  par(mfrow=c(2,2))
  master <- master[order(-master$tfidf10),]
  wordcloud(master$word[2:100], master$tfidf10[2:100], rot.per = 0)
  
  master <- master[order(-master$tfidf16),]
  wordcloud(master$word[2:100], master$tfidf16[2:100], rot.per = 0)
  
  
