# Restart R session if needed
stopifnot(Sys.getenv("DUCKPLYR_FORCE") == "")

library(tidyverse)

# Smaller sample because data generation is now part of the process
G <- 200
N <- 500


# The summarize() is guaranteed to be run by duckdb
# thanks to the prudence setting
crossing(g1 = 1:G, g2 = 1:G, id = 1:N) |>
  mutate(x = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(x))

# paset0() not supported
crossing(g1 = 1:G, g2 = 1:G, id = 1:N) |>
  mutate(x = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(x)) |>
  mutate(teidt = paste0("Mean: ", m)) |>
  collect()

# Use collect() to have the query handled by dplyr
crossing(g1 = 1:G, g2 = 1:G, id = 1:N) |>
  mutate(x = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(x)) |>
  collect() |>
  mutate(teidt = paste0("Mean: ", m))

# Can do multiple pipeline steps
# Translation not supported
crossing(g1 = 1:G, g2 = 1:G, id = 1:N) |>
  mutate(x = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(x)) |>
  mutate(.by = g1, sd = sd(m)) |>
  collect() |>
  mutate(teidt = paste0("Mean: ", m))

# Need to adapt the translation
crossing(g1 = 1:G, g2 = 1:G, id = 1:N) |>
  mutate(x = rnorm(n())) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = c(g1, g2), m = mean(x)) |>
  mutate(.by = g1, sd = sd(m, na.rm = TRUE)) |>
  collect() |>
  mutate(teidt = paste0("Mean: ", m))

# Caution: results coming back in random order!
