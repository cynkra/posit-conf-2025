tbl <- duckplyr::read_parquet_duckdb(
  "personas.parquet")
tbl |> dplyr::count()
