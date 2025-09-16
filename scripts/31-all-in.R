library(duckplyr)

# Fails due to long-standing problem with time zones
nycflights13::flights |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = origin, count = n()) |>
  mutate(frac = count / sum(count))

# Still fails due to a subtle incompatibility
nycflights13::flights |>
  select(-time_hour) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = origin, count = n()) |>
  mutate(frac = count / sum(count))

# Still fails for a weird reason
nycflights13::flights |>
  select(-time_hour) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = origin, count = n()) |>
  mutate(frac = count / sum(count, na.rm = TRUE))

# Succeeds
nycflights13::flights |>
  select(-time_hour) |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = origin, count = n()) |>
  mutate(overall = sum(count, na.rm = TRUE)) |>
  mutate(frac = count / overall)
