#' dsfrrgrddddsgh
#' 
#' @description aswgarsg swegddd
#' @author Frederik Sachser
#' @export
session_info <- 
function (file = "session_info.txt") 
{
    if (dir.exists(dirname(file)) == FALSE) {
        dir.create(dirname(file), recursive = TRUE)
    }
    sink(file)
    print(Sys.time())
    print(sessionInfo())
    sink()
}
