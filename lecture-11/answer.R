
library(jsonlite)
library(ggplot2)


baseurl <- "https://projects.propublica.org/nonprofits/api/v1/search.json?order=revenue&sort_order=desc&q=policy"
pages <- list()
for(i in 0:10){
  mydata <- fromJSON(paste0(baseurl, "&page=", i), flatten=TRUE)
  message("Retrieving page ", i)
  pages[[i+1]] <- mydata$filings
}

#combine all into one
filings <- rbind.pages(pages)

#check output
nrow(filings)

revenue <- filings$organization.revenue_amount

df <- data.frame(revenue=revenue[revenue < 10000000])

ggplot(df, aes(x=revenue)) + geom_histogram()
ggsave("answer.png")
