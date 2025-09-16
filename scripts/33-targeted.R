# Restart R session
library(tidyverse)

# Smaller sample because data generation is now part of the process
G <- 200
X <- 500

# Can't translate the mutate()
crossing(g1 = 1:G, g2 = 1:G, x = 1:X) |>
  as_duckdb_tibble(prudence = "stingy") |>
  mutate(g3 = rnorm(n())) |>
  summarize(.by = c(g1, g2), m = mean(g3))

# The summarize() is guaranteed to be run by duckdb
# thanks to the prudence setting
crossing(g1 = 1:G, g2 = 1:G, x = 1:X) |>
  mutate(g3 = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(g3))

# paset0() not supported
crossing(g1 = 1:G, g2 = 1:G, x = 1:X) |>
  mutate(g3 = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(g3)) |>
  mutate(text = paste0("Mean: ", m)) |>
  collect()

# Use collect() to have the query handled by dplyr
crossing(g1 = 1:G, g2 = 1:G, x = 1:X) |>
  mutate(g3 = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(g3)) |>
  collect() |>
  mutate(text = paste0("Mean: ", m))

# Can do multiple pipeline steps
# Translation not supported
crossing(g1 = 1:G, g2 = 1:G, x = 1:X) |>
  mutate(g3 = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(g3)) |>
  mutate(.by = g1, sd = sd(m)) |>
  collect() |>
  mutate(text = paste0("Mean: ", m))

# Need to adapt the translation
crossing(g1 = 1:G, g2 = 1:G, x = 1:X) |>
  mutate(g3 = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(g3)) |>
  mutate(.by = g1, sd = sd(m, na.rm = TRUE)) |>
  collect() |>
  mutate(text = paste0("Mean: ", m))

# Caution: results coming back in random order!
