#' summary_instructions
#' @description summary_instructions
#' @export
summary_instructions <- function(cache_dir) {
  # reload df_source_files
  df_source_files <-
    readRDS(file = file.path(cache_dir, "df_source_files.rds"))
  # print output
  cat("\n--------------------------------------------\n\nSummary of executed instructions:\n\n")
  print(data.frame(
    filename = df_source_files$filename,
    instruction = df_source_files$instruction
  ))
  cat("\n--------------------------------------------\n")
}
