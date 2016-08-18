#' Print a reminder and summary to the console
#' 
#' @description The function will print a summary of the instructions.
#' @author Frederik Sachser
#' @export
summary_instructions <-
  function()
  {
    cat("\n--------------------------------------------\nSummary of executed instructions:\n\n")
    print(data.frame(
      script = readRDS(".cache/df_cache.rds")$basename_in,
      instruction = readRDS(".cache/df_cache.rds")$instruction
    ))
    cat("\n--------------------------------------------\n")
  }
