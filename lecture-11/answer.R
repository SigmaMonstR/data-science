
library(XML)
library(RCurl)
library(stringr)

options(show.error.messages = FALSE)
baseurl <- "http://oai.crossref.org/OAIHandler?verb=ListSets"
xml.query <- xmlParse(getURL(baseurl))

# Lots of sets
sets <- xmlToList(xml.query)

# Get the name for each element in the list
sets[['ListSets']][15][['set']][['setName']]

sapply(sets[['ListSets']], function (x) { x[['setName']] })

as.character(sapply(sets[['ListSets']], function (x) { x[['setName']] }))


