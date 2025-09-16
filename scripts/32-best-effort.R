# Restart R session if needed
stopifnot(!("duckplyr" %in% loadedNamespaces()))
stopifnot(Sys.getenv("DUCKPLYR_FORCE") == "")

library(tidyverse)

G <- 200
X <- 5000

data <-
  crossing(g1 = 1:G, g2 = 1:G, x = 1:X) |>
  mutate(g3 = rnorm(n()))

# Slow with dplyr
data |>
  summarize(.by = c(g1, g2), m = mean(g3)) |>
  system.time()

library(duckplyr)

# Fast with duckplyr, using multiple cores
# collect() needed for a fair measurement
data |>
  summarize(.by = c(g1, g2), m = mean(g3)) |>
  collect() |>
  system.time()

# Time for planning the query much shorter
data |>
  summarize(.by = c(g1, g2), m = mean(g3)) |>
  system.time()
