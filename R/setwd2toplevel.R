#' Set working directory to top level
#'
#' @description This function will determine the path of the executing script and set the working directory to the specified parent directory.
#' @param toplevel Character. File path to a parent directory of the current file (e.g. the top level of a project).
#' @inheritParams project_framework
#' @note The name of your project should be unique (avoid parent directories with identical names).
#' @seealso \url{http://stackoverflow.com/a/36777602/7613841}, \url{http://stackoverflow.com/a/32016824/2292993}, \url{http://stackoverflow.com/a/35842176/2292993}, \url{http://stackoverflow.com/a/15373917/7613841}, \url{http://stackoverflow.com/a/1815743/7613841}, \url{http://stackoverflow.com/a/1816487/7613841}
#' @author Frederik Sachser, Jerry T, aprstar, Richie Cotton, steamer25, Suppressingfire, hadley
#' @export
setwd2toplevel <- function(toplevel) {
  # http://stackoverflow.com/a/36777602/7613841
  # http://stackoverflow.com/a/32016824/2292993
  cmdArgs <- commandArgs(trailingOnly = FALSE)
  needle <- '--file='
  match <- grep(needle, cmdArgs)
  if (length(match) > 0) {
    # Rscript via command line
    current_file_path <-
      normalizePath(sub(needle, '', cmdArgs[match]))
  } else {
    ls_vars = ls(sys.frames()[[1]])
    if ('fileName' %in% ls_vars) {
      # Source'd via RStudio
      current_file_path <- normalizePath(sys.frames()[[1]]$fileName)
    } else {
      if (!is.null(sys.frames()[[1]]$ofile)) {
        # Source'd via R console
        current_file_path <- normalizePath(sys.frames()[[1]]$ofile)
      } else {
        # RStudio Run Selection
        # http://stackoverflow.com/a/35842176/2292993
        current_file_path <-
          normalizePath(rstudioapi::getActiveDocumentContext()$path)
        if (current_file_path == '') {
          return(message('No Active Document. Skip setwd()'))
        }
      }
    }
  }
  # change wd to top level
  if (grepl(pattern = '\\\\', x = current_file_path)) {
    fp_split <-
      unlist(strsplit(x = file.path(current_file_path), split = '\\\\'))
    project_directory <-
      file.path(paste(fp_split[1:max(which(fp_split == toplevel))], collapse = '\\'))
  } else {
    fp_split <-
      unlist(strsplit(x = file.path(current_file_path), split = '/'))
    project_directory <-
      file.path(paste(fp_split[1:max(which(fp_split == toplevel))], collapse = '/'))
  }
  if (dir.exists(project_directory) == FALSE) {
    stop('Check typo of the top level directory')
  }
  setwd(project_directory)
}