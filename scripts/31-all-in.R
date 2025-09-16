library(duckplyr)

# Alternative to "prudence" setting
Sys.setenv(DUCKPLYR_FORCE = TRUE)


# Challenges --------------------------------------------------------------------------

G <- 200
N <- 5000

# Can't translate the mutate()
crossing(g1 = 1:G, g2 = 1:G, id = 1:N) |>
  mutate(x = rnorm(n())) |>
  summarize(.by = c(g1, g2), m = mean(x))

# Fails due to long-standing problem with time zones
nycflights13::flights |>
  summarize(.by = origin, count = n()) |>
  mutate(frac = count / sum(count))

# Can't even use select() with the error
flights_reduced <- nycflights13::flights[-19]

# Still fails due to a subtle incompatibility
flights_reduced |>
  summarize(.by = origin, count = n()) |>
  mutate(frac = count / sum(count))

# Still fails for a weird reason
flights_reduced |>
  as_duckdb_tibble(prudence = "stingy") |>
  summarize(.by = origin, count = n()) |>
  mutate(frac = count / sum(count, na.rm = TRUE))


# Success, finally! -------------------------------------------------------------------

flights_reduced |>
  summarize(.by = origin, count = n()) |>
  mutate(overall = sum(count, na.rm = TRUE)) |>
  mutate(frac = count / overall)

# Restore
Sys.setenv(DUCKPLYR_FORCE = FALSE)
