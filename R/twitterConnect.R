createTwitterStream <- function() {
  require('streamR')
  filterStream(file.name = "tweets.txt", track = "justinbieber")

}
