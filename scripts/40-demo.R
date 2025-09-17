library(tidyverse)



data <-
  duckplyr::duckdb_tibble(id = 1:1e6, .prudence = "stingy") |>
  mutate(x = dd::random())

data
