library(twitteR)
library(streamR)
library(ROAuth)
library(maps)

#Access Keys
consumer_key <- "g5XBJgR4QJYutMp4UIQyMLlor"
consumer_secret <- "4yPcnlvL28x9P6LizZ9Spu6aKZQv3ooh0oCielWBbMILFohhGD"
access_token <- "741997171508154368-VeGhryW3k3wqtjp2xw4rkYDUhCMhoIu"
access_secret <- "2c3Btxpy4ohf4AiXOVfOepaJN8lMheotEDxsdYX6gh7r9"
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

#Setup streamR Connection
my_oauth <- OAuthFactory$new(consumerKey = consumer_key, consumerSecret = consumer_secret, requestURL = requestURL, accessURL = accessURL, authURL = authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

#Setup TwitteR Connection
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#Call scrateTop50Artists() to generate vector of top 3 artists in America
artists <- scrapeTop50Artists()

#Create a dataframe of tweets in the United States regarding each of the top three artists
tweets.df <- data.frame()
for (artist in artists) {
  filterStream(file.name = paste(artist, ".json", sep = ""), track = artist, locations = c(-125, 25, -66, 50), oauth = my_oauth, timeout = 120)
  temp.df <- parseTweets(paste(artist, ".json", sep = ""), verbose = FALSE)
  temp.df$Artist <- artist
  tweets.df <- rbind(tweets.df, temp.df)
}

# Map the tweets based on geographic location and artist
library(ggplot2)
library(grid)
map.data <- map_data("state")
points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat), Artist = as.factor(tweets.df$Artist))
points <- points[points$y > 25,]
points <- points[points$x < -65,]
map <- ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.1) + expand_limits(x = map.data$long, y = map.data$lat) + geom_point(data = points, aes(x=x, y=y, color = Artist), size =2, alpha = 1/2)

# Export the plot as a png file
png('map.png', width = 1000, height = 600)
map
dev.off()

# Tweet the map to the Music Map (@tedorour) account
captions <- c("Who are America's most talked about artists??", "Hey America! Where are your favorite artists the most popular?", "Check out this heat map of America's most listened to artists!", "Where are people talking about the most popular of Billboard Top 100's artists?", "#music", "Truth:", "Data meets Music:", "Who's hot this week?", "Which of America's favorite artists are most talked about in your area?", "Who's hot?", "Who's America listening to today?", "Tweet about your favorite artists to see them featured on our map!", "Who are people listening to in your area?", "Where in America is your favorite artist being talked about?", "What city loves your favorite artist?")
tweet(sample(captions, 1), mediaPath = "map.png")
