#  Wordclouds
#  It helps to clean the text first, before importing because some of the R functions
#  do not eiminate things like 's or 're 'll

install.packages("wordcloud")
install.packages("RColorBrewer") # color palettes
install.packages("SnowballC") # for text stemming
install.packages("tm")
#  Load the libraries
library(RColorBrewer)
library(SnowballC)
library(wordcloud)
library(NLP)
library(tm)
#set working directory
getwd()
setwd("/home/jose/R/data/github/WordCloud-Trumps-Tulsa-Speech")
# Import the text file.  You have to do it interactively.
text <- readLines(file.choose("/home/jose/R/data/github/WordCloud-Trumps-Tulsa-Speech"))
#  Then select the file from the directory to load it into RStudio

# Load the data as a Corpus
docs <- Corpus(VectorSource(text))
# Inspect (take a look at) the contents of "docs"
inspect(docs)
# Warning:  The file displays in the Console and it is LAF

# Text transformation
# Transformation is performed using tm_map() function to replace, 
# for example, special characters from the text.
# Replacing “/”, “@” and “|” with space:
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
#  class(toSpace)
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Clean the text

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("donald", "trump"))
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

#   Step 4 : Build a term-document matrix
#   Document matrix is a table containing the frequency of the words. 
#   Column names are words and row names are documents. 
#   The function TermDocumentMatrix() from text mining package 
#   can be used as follow :

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

class(d)
#   Step 5 : Generate the Word cloud

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


