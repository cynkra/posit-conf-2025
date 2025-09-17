writeLines(
  con = ".Rprofile",
  c(
    r"(
message("Using project-local library in ./.library")
dir.create("./.library", showWarnings = FALSE)
.libPaths("./.library")
)"
  )
)
