#' Set working directory to top level
#'
#' @description This function will determine the path of the executing script and set the working directory to the specified parent directory.
#' @param toplevel Character. File path to a parent directory of the current file (e.g. the top level of a project).
#' @note The name of your project should be unique (avoid parent directories with identical names).
#' @note The function is a wrapper for framework::curfp
#' @seealso \url{http://stackoverflow.com/a/36777602/7613841}, \url{http://stackoverflow.com/a/32016824/2292993}, \url{http://stackoverflow.com/a/35842176/2292993}, \url{http://stackoverflow.com/a/15373917/7613841}, \url{http://stackoverflow.com/a/1815743/7613841}, \url{http://stackoverflow.com/a/1816487/7613841}, \code{\link{curfp}}
#' @author Frederik Sachser, Jerry T, aprstar, Richie Cotton, steamer25, Suppressingfire, hadley
#' @export
setwd2toplevel <- function(toplevel) {
  current_file_path <- rstudioapi::getActiveProject()
  if (is.null(current_file_path)) {
    current_file_path <- curfp()
  }
  # change wd to top level
  fp_split <-
    unlist(strsplit(
      x = file.path(current_file_path),
      split = .Platform$file.sep
    ))
  if (length(which(fp_split == toplevel)) > 0) {
    project_directory <-
      file.path(paste(fp_split[1:max(which(fp_split == toplevel))], collapse = .Platform$file.sep))
  } else {
    return(message('Cannot set working directory.'))
  }
  if (dir.exists(project_directory) == FALSE) {
    stop('Check typo of the top level directory')
  }
  setwd(project_directory)
}
