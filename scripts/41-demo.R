library(tidyverse)

duckplyr::db_exec("LOAD stochastic")

data <-
  duckplyr::duckdb_tibble(id = 1:1e6) |>
  mutate(x = dd$dist_normal_sample(0, 1))

data
