library(tidyverse)

idx <- duckplyr::duckdb_tibble(id = 1:1e4)

duckplyr::db_exec("INSTALL stochastic")

duckplyr::db_exec("LOAD stochastic")

idx |>
  mutate(x = dd::dist_normal_sample(0, 1)) |>
  ggplot(aes(x)) +
  theme_void(ink = "blue", paper = "black") +
  geom_histogram()
