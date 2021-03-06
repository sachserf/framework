#' Summarize what has been done!
#'
#' @description This function reads information from your cache and prints the
#'   filenames as well as related instructions. Therefore you can track the
#'   executed instructions. The information corresponds to the point in time
#'   when you run the function 'execute_instructions'.
#' @inheritParams project_framework
#' @author Frederik Sachser
#' @export
summary_instructions <- function(cache_dir) {

  # reload df_source_files
  df_source_files <-
    readRDS(file = file.path(cache_dir, "df_source_files.rds"))

  message('\nSummary of executed instructions:\n')

  # print output
  print(data.frame(
    filename = df_source_files$filename_noxt,
    ext = df_source_files$file_ext,
    instruction = df_source_files$instruction
  ))

  ftl <- which(df_source_files$instruction == 'load')

  message(
    '\nProcessed ',
    nrow(df_source_files) - ifelse(length(ftl) > 0, ftl, 0),
    '/',
    nrow(df_source_files),
    ' files @WD:'
  )
  writeLines(getwd(), '\n', con = stdout())
}
