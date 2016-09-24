#' Dput a function
#' 
#' @description Choose a function of an installed R-package and save it to the 
#'   specified target.
#' @param pkg_fun Character. Name of a package and function separated by '::'. E.g. 
#'   framework::summary_instructions. Do not use quotation marks.
#' @param target_dir Character. Specify the file path, where you want to write 
#'   the file.
#' @param rm_pattern Character. Choose any pattern that should be removed. E.g. 
#'   'framework::' to exclude the name of the package framework.
#' @author Frederik Sachser
#' @export
dput_function <-
  function(pkg_fun,
           target_dir,
           rm_pattern = FALSE) {
    if (dir.exists(target_dir) == FALSE) {
      dir.create(target_dir, recursive = TRUE)
    }
    # extract name info
    function_name <- paste(substitute(pkg_fun))[3]
    function_call <- paste0(function_name, ' <- ')
    filename <- paste0(target_dir, '/', function_name, '.R')
    # check if file exists
    if (file.exists(filename) == TRUE) {
      warning('filename of function already exists.')
    } else {
      # write file
      dput(x = pkg_fun, file = filename)
      # read file
      thefun <- readLines(filename)
      # rm pattern 
      if (rm_pattern != FALSE) {
        thefun <-
          gsub(pattern = rm_pattern,
               replacement = '',
               x = thefun)
      }
      # include function_call and overwrite file
      cat(function_call, thefun, sep = '\n', file = filename)
    }
  }