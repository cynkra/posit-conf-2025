library(duckplyr)


# Download ----------------------------------------------------------------------------

# See scripts/10-personas-download.R

# Direct access over internet ---------------------------------------------------------

db_exec("INSTALL httpfs")

# Requires HuggingFace token for reading stored in ~/.cache/huggingface/token
db_exec(
  "CREATE OR REPLACE SECRET hf_token (
  TYPE huggingface,
  PROVIDER credential_chain
)"
)

personas <- read_parquet_duckdb(
  "hf://datasets/nvidia/Nemotron-Personas/*/*.parquet"
)

# Fallback to local file
if (FALSE) {
  personas <- read_parquet_duckdb("personas.parquet")
}

personas
personas |> glimpse()


# ALTREP data frame -------------------------------------------------------------------

personas |>
  class()

personas |>
  purrr::map_chr(class)

personas |>
  explain()


# Queries -----------------------------------------------------------------------------

personas_count <-
  personas |>
  count(sex, education_level)

personas_count |>
  explain()

personas_count


# Handover ----------------------------------------------------------------------------

library(ggplot2)
personas_count |>
  ggplot(aes(education_level, n)) +
  geom_col(aes(fill = sex), position = "dodge")


# Prudence ----------------------------------------------------------------------------

personas |>
  ggplot(aes(education_level)) +
  geom_bar(aes(fill = sex), position = "dodge")

personas$age
personas[1:3, ]

# Works, just takes a long time:
if (FALSE) {
  personas |>
    collect()
}

# Works because data is small
personas_count$education_level


# Local copy --------------------------------------------------------------------------

personas_local <- read_parquet_duckdb("personas.parquet")
personas_local

# Iterate fast using a local copy, then change back to remote access
# without changing any other code
