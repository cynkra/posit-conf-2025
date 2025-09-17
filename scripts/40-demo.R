library(tidyverse)

idx <- duckplyr::duckdb_tibble(id = 1:1e4)


idx |>
  mutate(x = dd::random()) |>
  ggplot(aes(x)) +
  theme_void(ink = "blue", paper = "black") +
  geom_histogram()
