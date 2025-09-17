library(duckplyr)


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

personas
personas |> glimpse()


# ALTREP data frame -------------------------------------------------------------------

personas |>
  explain()


# Queries -----------------------------------------------------------------------------

personas_count <-
  personas |>
  count(sex, education_level)

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

# Works because data is small
personas_count$education_level

# Works, but slow
personas |>
  collect()
















# Safety net: Local operation
personas <- read_parquet_duckdb("personas.parquet")
