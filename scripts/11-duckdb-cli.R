# Only this script uses the DuckDB CLI.
# Follow <https://duckdb.org/#quickinstall> or <https://duckdb.org/docs/installation/>

stopifnot(Sys.which("duckdb") != "")

system(r"(duckdb -c "SELECT COUNT(*) FROM 'personas.parquet';")")
