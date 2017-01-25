install.packages("twitteR")
install.packages("RCurl")
install.packages("tm")
install.packages("wordcloud")
install.packages("Rstem")

download.file("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz", "sentiment.tar.gz")
install.packages("sentiment.tar.gz", repos=NULL, type="source")


library(twitteR)
library(RCurl)
library(tm)
library(wordcloud)
library(Rstem)
library(sentiment)

### setting up twitter
consumer.key <- "nJALSVfTl92F3FD82FdFIHcbU"
consumer.secret <- "xNYemJQWg65AfhS47Ht0lQzS3KEWqPMsSttJxk12PKfl8Gbvjm"
access.token <- "53921526-5YuIAnqa4BjlFOuxrGsJu6uvzAfCmMJw3vopQ999w"
access.secret <- "66K5bmJvViXMfv8pgM0hWsWjKR8TNsalYmnPVI17ulWGx"


### Authorizing
setup_twitter_oauth(consumer.key, consumer.secret, access.token, access.secret)


classify_polarity("okay", algorithm = "bayes", verbose = FALSE)

classify_emotion("wow !!", algorithm = "bayes", verbose = FALSE)

# Search tweets with '#datamining'
dmhash_tweets = searchTwitter("#datamining")

dmhash_tweets

# search a maximum of 20 tweets in french
dm20fr_tweets = searchTwitter("#datamining", lang="fr", n=20)

dm20fr_tweets

# search a maximum of 10 tweets in german
dm10de_tweets = searchTwitter("#datamining", lang="de", n=10)

dm10de_tweets

# search tweets containing "data mining"
dm1_tweets = searchTwitter("data mining")

dm1_tweets

# search tweets between two dates (you will have to change the dates!)
dm2_tweets = searchTwitter("data mining", since='2012-05-12', until='2012-05-17')

dm2_tweets

# search tweets around a given radius of 5 miles of latitude/longitude
dm3_tweets = searchTwitter("data mining", geocode="37.857253,-122.270558,5mi")

dm3_tweets

# tweets from @weather
my_tweets = userTimeline("aamir218")

my_tweets







tweets <- searchTwitter("DDCA", n = 500, lang = "en" , resultType = "recent")

tweets_df = twListToDF(tweets)

head(tweets_df)

write.csv(tweets_df,"twitter_extract.csv")

class(tweets)
typeof(tweets)

tweet_text <- sapply(tweets, function(x) x$getText())

typeof(tweet_text)

str(tweet_text)

tweet_corpus = Corpus(VectorSource(tweet_text))

tweet_corpus

inspect(tweet_corpus[10])

### Cleaning

### removing punctuation
tweet_clean <- tm_map(tweet_corpus, removePunctuation)

### converting to lower case
tweet_clean <- tm_map(tweet_clean, content_transformer(tolower))

### removing stopwords
tweet_clean <- tm_map(tweet_clean, removeWords, stopwords("english"))

### removing numbers
tweet_clean <- tm_map(tweet_clean, removeNumbers)

### removing whitespace
tweet_clean <- tm_map(tweet_clean, stripWhitespace)

### removing obvious words
tweet_clean <- tm_map(tweet_clean, removeWords, c("DDCA"))

### creating a wordcloud
wordcloud(tweet_clean)

wordcloud(tweet_clean, random.order = F)

wordcloud(tweet_clean, random.order = F, scale = c(6, 0.5))

wordcloud(tweet_clean, random.order = F, col = rainbow(50))
