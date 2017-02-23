#' Write a file with current session info
#' 
#' @description The function writes the current timestamp and session info to a
#'   file.
#' @param session_info_filepath Character. File path to the target.
#' @note Directories will be created recursively.
#' @author Frederik Sachser
#' @export
session_info <-
  function(session_info_filepath = "meta/session_info.txt")
  {
    if (dir.exists(dirname(session_info_filepath)) == FALSE) {
      dir.create(dirname(session_info_filepath), recursive = TRUE)
    }
    cat("#### Sys.time ####\n", append = FALSE, file = session_info_filepath)
    sink(session_info_filepath, append = TRUE)
    print(Sys.time())
    sink()
    
    cat("\n\n#### Sys.info ####\n", append = TRUE, file = session_info_filepath)
    sink(session_info_filepath, append = TRUE)
    print(Sys.info()["user"])
    sink()
    
    cat("\n\n#### sessionInfo ####\n", append = TRUE, file = session_info_filepath)
    sink(session_info_filepath, append = TRUE)
    print(utils::sessionInfo(package = NULL))
    sink()
  }
