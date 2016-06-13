library(twitteR)
library(streamR)
library(ROAuth)
library(maps)

# Scrapes the top 100 artists from billboard.com
scrapeTop50Artists <- function() {
  require('rvest')
  top_artists <- read_html('http://www.billboard.com/charts/artist-100') %>%
    html_nodes('article > div.chart-row__primary > div.chart-row__main-display > div.chart-row__container > div > h2')%>%
    html_text()
  return(top_artists[1:3])
}

#Call scrateTop50Artists() to generate vector of top 3 artists in America
artists <- scrapeTop50Artists()

load("~/Desktop/MusicMap/oauth.Rdata")

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

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
# Tweet the map to the Music Map (@tedorour) account
captions <- c("Who are America's most talked about artists??", "Hey America! Where are your favorite artists the most popular?", "Check out this heat map of America's most listened to artists!", "Where are people talking about the most popular of Billboard Top 100's artists?", "#music", "Truth:", "Data meets Music:", "Who's hot this week?", "Which of America's favorite artists are most talked about in your area?", "Who's hot?", "Who's America listening to today?", "Tweet about your favorite artists to see them featured on our map!", "Who are people listening to in your area?", "Where in America is your favorite artist being talked about?", "What city loves your favorite artist?")
tweet(sample(captions, 1), mediaPath = "map.png")

quit(save="no")
