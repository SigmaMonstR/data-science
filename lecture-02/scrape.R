#Go over HTML structure

#Easy way to learn how to structure data is to create it

#Creating a dataset from CNN website

#Scraping Data from HTML
  library(rvest)
  sotu <- read_html("http://www.cnn.com/2011/POLITICS/01/25/state.union.facts/index.html")
  
  rating <- sotu %>% 
    html_nodes("p") %>%
    html_text() 

#Regex
#http://regexr.com/  
  start_pos <- grep("Obama:",rating)
  rating <- rating[start_pos:length(rating)]
  rating <- rating[grep("^--.*applause interruptions",rating)]
  
  day <- substr(rating,4,regexpr(": ",rating)-1)
  speech_length <- substr(rating,regexpr(":",rating)+2,regexpr(" minutes",rating)-1)
  
  pos_app <- regexpr("\\d{2,3} applause", rating)
  applause <- substr(rating,pos_app, pos_app+2)
  
  data <- data.frame(day, speech_length, applause)
  
  
#Stopwords
  stop1 <- read_html("http://www.lextek.com/manuals/onix/stopwords1.html")
  
  stopwords <- stop1 %>% 
    html_nodes("pre") %>%
    html_text() 
  stoplist <- unlist(strsplit(stopwords,"\n"))
  stoplist <- stoplist[stoplist!="" & nchar(stoplist)>1]
  stoplist <- stoplist[4:length(stoplist)]

#
  vals2 <- vals[!(vals$x %in% stoplist),]
  