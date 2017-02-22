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
    sink(session_info_filepath)
    print(Sys.time())
    print(Sys.info()["user"])
    print(utils::sessionInfo(package = NULL))
    sink()
}

