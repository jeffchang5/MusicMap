
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
  require('plyr')
  ## Spotify finds a list of featured music list
  if (exists("spotify_token")) {
    spotify_list <- GET(spotify.playlist.url[[1]],
                        add_headers("Authorization" = paste('Bearer', spotify_token)))
    musicList <<- content(spotify_list)
    #$tracks$items[[96]]$track$artists[[2]]$name
    list_of_artists <<- vector()
    for (title in musicList$tracks$items) {
      list_of_artists <- append(list_of_artists, title$track$artists[[1]]$name)
    }
    return(count(list_of_artists))

  }
  else stop("There isn't a Spotify token stored in the environment!")
}

