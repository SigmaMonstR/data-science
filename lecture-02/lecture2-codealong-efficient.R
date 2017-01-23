
#Lecture 2- Codealong

setwd("/Users/jeff/Documents/Github/data-science/lecture-02/data")


####How many planned applause breaks in 2010 versus 2016?

master <- data.frame()
years <- seq(2010,2016,1)

for(k in years){
  temp <- readLines(paste0("sotu_",k,".txt"))
  temp <- temp[temp!=""]
  
  
  temp <- gsub("[[:punct:]]","",temp)
  temp <- gsub("[[:digit:]]","",temp)
  temp <- gsub("[^[:graph:]]"," ",temp)
  
  #convert into bag of words
  bag <- strsplit(temp," ")
  bag <- tolower(trimws(unlist(bag)))
  
  #Count the number of times a word shows up
  counts <- aggregate(bag, by=list(bag), FUN=length)
  colnames(counts) <- c("word","freq")
  counts$year <- k
  master <- rbind(master,counts)
}

  master <- master[nchar(master$word) > 2,]

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
  master <- master[!(master$word %in% stoplist),]
  wide <- reshape(master, 
                  timevar = "year",
                  idvar = "word",
                  direction = "wide")
  wide[is.na(wide)] <- 0

##TFIDF - Term Frequency Inverse Document Frequency
#TF =  (# of times term t appears in a document) / (Total number of terms in the document).
#IDF = exp(# of documents / # documents with term t in it) 
    
    wide$tf <- 0
  for(k in years){
    wide[[paste0("freq.",k)]] <- wide[[paste0("freq.",k)]]/sum(wide[[paste0("freq.",k)]])
    wide$tf <- wide$tf + (wide[[paste0("freq.",k)]] > 0)*1
  }
    set.seed(80)
    par(mfrow=c(2,4))
    for(k in years){
      wide[[paste0("freq.",k)]] <- wide[[paste0("freq.",k)]] * exp(length(years)/wide$tf)
      wide <- wide[order(-wide[[paste0("freq.",k)]]),]
      wordcloud(wide$word[2:100], wide[[paste0("freq.",k)]][2:100], max.words = 50, rot.per = 0)
    }
    

master <- master[,c(1,2,4,10,11)]


library(wordcloud)
set.seed(50)

temp <- wide[wide$tf == 7,]
temp$sum <- rowSums(temp[,2:8])
wordcloud(temp$word, temp$sum , rot.per = 0, max.words = 100)


