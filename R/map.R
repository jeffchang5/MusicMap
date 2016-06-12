brary(streamR)
library(twitteR)

#Access Keys
consumer_key <- "u1pHQbqCtdrUnXaltsaQBbVnv"
consumer_secret <- "Nq43c5BjqRysNwjOVqT8gCrgbtk0Hmy8GispuHQxSkunLGxc2q"
access_token <- "741997171508154368-zrcDDA9LZI9sybPz5vULQnJ8KlwVGdq"
access_secret <- "0G6mAnoqpibllUDcejmEFFv7NMS8HPTZoczHurg9FThAw"
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

#Setup streamR Connection
my_oauth <- OAuthFactory$new(consumerKey = consumer_key, consumerSecret = consumer_secret, requestURL = requestURL, accessURL = accessURL, authURL = authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

#Setup TwitteR Connection
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

#Vector of Artists
artists <- c("drake", "rihanna", "bieber")

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
points <- data.frame(x = as.numeric(tweets.df$lon), y = as.numeric(tweets.df$lat), artist = as.factor(tweets.df$artist))
points <- points[points$y > 25,]
points <- points[points$x < -65,]
map <- ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "white", color = "grey20", size = 0.1) + expand_limits(x = map.data$long, y = map.data$lat) + geom_point(data = points, aes(x=x, y=y, color = Artist), size =1, alpha = 1/4)

png('map3.png', width = 1000, height = 600)
map
dev.off()

tweet("Who are America's most talked about artists??", mediaPath = "map.jpg")
