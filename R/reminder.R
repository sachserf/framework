#' Print a reminder and summary to the console
#' 
#' @description The function will print a summary of the instructions and remind
#'   you to use git.
#' @author Frederik Sachser
#' @export
reminder <-
  function()
  {
    print(data.frame(
      script = readRDS(".cache/df_cache.rds")$basename_in,
      instruction = readRDS(".cache/df_cache.rds")$instruction
    ))
    cat("\nDon´t forget to add & commit snapshots and pull & push your git repository.")
  }
