# 1. Load Library ----
if(!require(tidyverse)) install.packages("tidyverse")

library(tidyverse)

# 2. Import Dataset ----
maroon5 <- read_csv("data_raw/maroon5.csv") %>%
  mutate(artist = "Maroon 5")
jasonmraz <- read_csv("data_raw/jasonmraz.csv") %>%
  mutate(artist = "Jason Mraz")
queen <- read_csv("data_raw/queen.csv") %>%
  mutate(artist = "Queen")
westlife <- read_csv("data_raw/westlife.csv") %>%
  mutate(artist = "Westlife")

# 3. join Dataset ----
spotify <- bind_rows(maroon5, jasonmraz, queen, westlife)

# 4. Save Clean Data ----
write_csv(spotify, "data/spotify.csv")