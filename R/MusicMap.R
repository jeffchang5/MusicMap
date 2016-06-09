
  #####################################
  ## Spotify requires the base64
  ## representation of our client
  ## and secret key
  #####################################

# Important: References API Keys that weren't pushed to Github.

#####################################
## Gets the Spotify auth token
#####################################

getSpotifyToken <- function() {
  require(httr)
  #####################################
  ## Looks for keys in a subdirectory
  #####################################

  source('./R/keys/spotify.R')
  #####################################
  ## Looks for keys in a subdirectory
  #####################################


  key <- paste0('Basic ', base64(paste0(spotify.client_key, ':', spotify.secret_key)))
  spotify_post <- POST(spotify.auth.url,
                       body = list(grant_type = 'client_credentials'),
                       encoding = 'UTF-8',
                       encode = 'form',
                       add_headers("Authorization" = key))
  spotify_token <<- content(spotify_post)$access_token



}
getMusicList <- function() {

  if (exists("spotify_token")) {
    spotify_list <- GET(spotify.playlist.url,
                        add_headers("Authorization" = paste('Bearer', spotify_token)))
    print(content(spotify_list))
  }
  else stop("There isn't a Spotify token stored in the environment!")
}

