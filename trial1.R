library(twitteR)
library(RCurl)
library(tm)
#library(wordcloud)
library(Rstem)
library(sentiment)
library(plyr)
library(dplyr)
library(Rserve)
#library(RSclient)
#install.packages("RSclient")


### setting up twitter
consumer.key <- "nJALSVfTl92F3FD82FdFIHcbU"
consumer.secret <- "xNYemJQWg65AfhS47Ht0lQzS3KEWqPMsSttJxk12PKfl8Gbvjm"
access.token <- "53921526-5YuIAnqa4BjlFOuxrGsJu6uvzAfCmMJw3vopQ999w"
access.secret <- "66K5bmJvViXMfv8pgM0hWsWjKR8TNsalYmnPVI17ulWGx"


### Authorizing
setup_twitter_oauth(consumer.key, consumer.secret, access.token, access.secret)


tweets <- searchTwitter("shahrukh", n = 500, lang = "en" , resultType = "recent")

tweets_df = twListToDF(tweets)

dim(tweets_df)

#names(tweets_df)

tweets_df$text

tweets_df$created

tweets_text <-as.data.frame(tweets_df$text)

tweets_text

#tweet_text <- sapply(tweets, function(x) x$getText())

# remove retweet entities
#tweets_text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets_text)

# remove at people
#tweets_text = gsub("@\\w+", "", tweets_text)

# remove html links
#tweets_text = gsub("http\\w+", "", tweets_text)


tweets_corpus = Corpus(VectorSource(tweets_text))

#names(tweets_corpus)

###Further Cleaning

### removing punctuation
tweets_clean <- tm_map(tweets_corpus, removePunctuation)

### removing whitespace
tweets_clean <- tm_map(tweets_clean, stripWhitespace)

### converting to lower case
tweets_clean <- tm_map(tweets_clean, content_transformer(tolower))

### removing stopwords
tweets_clean <- tm_map(tweets_clean, removeWords, stopwords("english"))

### removing numbers
tweets_clean <- tm_map(tweets_clean, removeNumbers)

### removing obvious words
tweets_clean <- tm_map(tweets_clean, removeWords, c("rt","RT","Via","VIA","@"))

tweets_clean

t_df<-data.frame(text=unlist(sapply(tweets_clean, `[`, "content")), 
                      stringsAsFactors=F)

t_df = tbl_df(t_df) 

#tweets_df$isRetweet

t_df$creation_time = tweets_df$created
#t_df$user = tweets_df$screenName
t_df$isRetweet = tweets_df$isRetweet
t_df$retweet_count = tweets_df$retweetCount
t_df$favoite_count = tweets_df$favoriteCount
t_df$user = tweets_df$screenName
glimpse(t_df)

write.csv(t_df,"twitter_extract.csv")

dim(t_df)

run.Rserve()

### removing obvious words
#tweet_clean <- tm_map(tweet_clean, removeWords, c("DDCA"))

### creating a wordcloud
wordcloud(tweet_clean)

wordcloud(tweet_clean, random.order = F)

wordcloud(tweet_clean, random.order = F, scale = c(6, 0.5))

wordcloud(tweet_clean, random.order = F, col = rainbow(50))


