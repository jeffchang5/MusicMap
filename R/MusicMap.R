spotify_auth <- 'https://accounts.spotify.com/api/token'

library('httr')
# Spotify requires the base64 representation of our client and secret key


key <- paste0('Basic ', base64(paste0(spotify.client_key, ':', spotify.secret_key)))

connectToSpotify <- function() {
  spotify_post <- POST(spotify.url, add_headers(Authorization = key))
  print(key)
  print(content(spotify_post, "text"))

}
getMusicList <- function() {

}
connectToSpotify()
