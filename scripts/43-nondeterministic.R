library(tidyverse)

idx <- duckplyr::duckdb_tibble(id = 1:1e4)

duckplyr::db_exec("LOAD stochastic")

data <-
  idx |>
  mutate(
    x = dd::random(),
    y = dd::dist_normal_sample(0, 1),
  )

data

# Every preview shows a different result
data

# Pinned after collecting
identical(
  collect(data),
  collect(data)
)

# Derived data will keep the pin
data2 <-
  data |>
  mutate(
    z = dd::dist_beta_sample(10, 0.3),
  )

data2

# Only the z column fluctuates
data2

# Collecting pins the data again
identical(
  collect(data),
  collect(data)
)
