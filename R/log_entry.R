#' write a log entry
#' 
#' @description This function will add a log entry to the specified file.
#' @return A csv file containing current timestamp and nodename.
#' @note If the file does not exist it will be written.
#' @inheritParams project_framework
#' @seealso \code{\link{log_summary}}
#' @author Frederik Sachser
#' @export
log_entry <- function(log_filepath = "log.csv") {
  if (dir.exists(dirname(file.path(log_filepath))) == FALSE) {
    dir.create(path = dirname(file.path(log_filepath)), recursive = TRUE)
  }
  
  POSIX <- Sys.time()
  DATE <- strftime(POSIX, format = "%F")
  WEEKDAY <- strftime(POSIX, format = "%A")
  TIME <- strftime(POSIX, format = "%T")
  NODENAME <- Sys.info()["nodename"]
  POSIX <- as.character(POSIX)
  
  df <- data.frame(POSIX,
                   NODENAME,
                   DATE, 
                   WEEKDAY, 
                   TIME, 
                   row.names = NULL)
  if (file.exists(log_filepath)) {
    suppressWarnings(
      utils::write.table(
        x = df,
        file = log_filepath,
        append = TRUE,
        col.names = FALSE,
        row.names = FALSE
      )
    )
  } else {
    utils::write.table(
      x = df,
      file = log_filepath,
      append = FALSE,
      col.names = TRUE,
      row.names = FALSE
    )
  }
}