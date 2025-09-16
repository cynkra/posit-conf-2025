tbl <- duckdb::tbl_file(
  path = "personas.parquet")
tbl |> dplyr::count()
