#' Print a reminder and summary to the console
#' 
#' @description The function will print a summary of the instructions and remind
#'   you to use git.
#' @author Frederik Sachser
#' @export
reminder <-
  function()
  {
    cat("\n--------------------------------------------\nSummary of executed instructions:\n\n")
    print(data.frame(
      script = readRDS(".cache/df_cache.rds")$basename_in,
      instruction = readRDS(".cache/df_cache.rds")$instruction
    ))
    cat("\nProject executed without errors.\nDo not forget to use git consistently.\n--------------------------------------------\n")
  }
