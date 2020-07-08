# 1. Load Library ----
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(janitor)) install.packages("janitor")

library(tidyverse)
library(readxl)
library(janitor)

# 2. Import Dataset ----
catvsdog <- read_xlsx("data_raw/catsvdogs.xlsx") %>%
  clean_names()

# 3. Save Clean Data ----
write_csv(catvsdog, "data/catvsdog.csv")
