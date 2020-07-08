# 1. Load Library ----
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(gapminder)) install.packages("gapminder")

library(tidyverse)
library(gapminder)

# 2. Save Clean Data -----
write_csv(gapminder, "data/gapminder.csv")
