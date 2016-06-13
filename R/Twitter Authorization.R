library(streamR)
library(twitteR)
library(ROAuth)

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

save(my_oauth, consumer_secret, consumer_key, access_token, access_secret, file = "oauth.Rdata")
