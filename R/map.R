library(streamR)
library(twitteR)
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

#Vector of Artists
artists <- scrapeTop50Artists()

tweets.df <- data.frame()
for (artist in artists) {
  filterStream(file.name = paste(artist, ".json", sep = ""), track = artist, locations = c(-125, 25, -66, 50), oauth = my_oauth, timeout = 120)
  temp.df <- parseTweets(paste(artist, ".json", sep = ""), verbose = FALSE)
  temp.df$Artist <- artist
  tweets.df <- rbind(tweets.df, temp.df)
}

library(ggplot2)
library(grid)
map.data <- map_data("state")
points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat), Artist = as.factor(tweets.df$Artist))
points <- points[points$y > 25,]
points <- points[points$x < -65,]
map <- ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.1) + expand_limits(x = map.data$long, y = map.data$lat) + geom_point(data = points, aes(x=x, y=y, color = Artist), size =2, alpha = 1/2)

png('map.png', width = 1000, height = 600)
map
dev.off()

tweet("Where are America's favorite artists most talked about??", mediaPath = "map.png")
