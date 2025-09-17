library(tidyverse)
library(duckplyr)

data <-
  duckdb_tibble(
    g = c(1, 1, 2),
    a = 1:3,
    b = 2:4,
    c = 3:5,
    .prudence = "stingy"
  )

# tidyr::pack()
packed <-
  data |>
  mutate(
    g,
    d = dd::struct_pack(a, b),
    e = dd::struct_pack(d, c),
    .keep = "unused"
  )

packed

packed |>
  pull(e) |>
  as_tibble()

# tidyr::nest()
nested <-
  packed |>
  summarize(.by = g, f = dd::list(e)) |>
  arrange(g)

nested

nested |>
  pull(f)

# tidyr::unnest()
roundtrip <-
  nested |>
  transmute(g, dd::unnest(f, recursive = TRUE)) |>
  arrange(g)

identical(collect(roundtrip), collect(data))

# Does not work yet
duckdb_tibble(h = list(data.frame(a = 1:2), data.frame(a = 3L)))
duckdb_tibble(h = vctrs::list_of(data.frame(a = 1:2), data.frame(a = 3L)))
