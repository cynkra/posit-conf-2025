library(tidyverse)
#library(duckplyr)
#
#
#

G <- 200
N <- 5000

data <-
  crossing(g1 = 1:G, g2 = 1:G, id = 1:N) |>
  mutate(x = rnorm(n()))

data |>
  #  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(x)) |>
  #  collect() |>
  system.time()
