# 1. Load Library ----
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(spotifyr)) install.packages("spotifyr")

library(spotifyr)
library(tidyverse)

# 2. Setup the Environment ----
Sys.setenv(SPOTIFY_CLIENT_ID = '7d346be008894f3ebbc1a5a949253301')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '51ebaee3f6934b7f89d3e96d0999def3')

access_token <- get_spotify_access_token()

# 3. Getting spotify ID for the artist/band you want ----
artist <- readline(prompt="Artist/Band name? ")
artist_spotifyID <- get_artist_audio_features(artist)$artist_id[1]

# 4. Getting artist albums data available on spotify and saving it on the albums variable -----
albums <- get_artist_albums(artist_spotifyID, include_groups = c("album"), 
                            limit=50, market = "ID", offset = 0,
                            authorization = access_token,
                            include_meta_info = FALSE) %>%
  #line below adds an id column called "num" to identify each row of data
  mutate(num = row_number()) %>%
  #line below is used to select the albums you are interested, use the num
  #column to filter, if you want all albums just delete or comment the line 
  #filter(num %in% c(22,20,18,15,14,12,11,8,6,3)) %>%
  #line below selects some columns from all the data that the API returns,
  #if you want different columns just add their name
  select(id, name, release_date, total_tracks)

# 5. Getting tracks from each album and saving it on the tracks variable -----
tracks <- albums$id %>%
  #line below applies a function to get all tracks from each album
  #saved on the albums variable
  map_dfr(~ get_album_tracks(.x, limit = 30, offset = 0, market = NULL,
                             authorization = access_token,
                             include_meta_info = FALSE)) %>%
  #line below selects some columns from all the tracks in album data that
  #the API returns, if you want different columns just add their name
  select(id, track_number, name, duration_ms)

# 6. Getting track info for each track collected by the previous code section and saving it in the tracks_info variable -----
tracks_info <- tracks$id %>%
  #line below applies a function to get the info from each track
  #saved on the tracks variable
  map_dfr(~ get_tracks(.x, market = NULL, authorization = access_token)) %>%
  #line below selects some columns from all the columns that
  #the API returns, if you want different columns just add their name
  select(id, name, popularity, album.id, album.name, album.total_tracks)

# 7. Getting track audio features for each track collected by the previous code section and saving it in the tracks_audio_features variable ----
track_audio_features <- tracks$id %>%
  map_dfr(~ get_track_audio_features(.x, authorization = access_token)) %>%
  select(-c(type,uri,track_href,analysis_url))

# 8. Join the Data

data <- tracks_info %>%
  left_join(tracks, by = c("id", "name")) %>%
  left_join(track_audio_features, by = c("id")) %>%
  select(-duration_ms.y) %>%
  rename(duration_ms = duration_ms.x)

# 9. Save the data
file <- stringr::str_replace(artist, " ", "")
write_csv(data, paste0("data/",tolower(file), ".csv"))
