dput_function <-
  function(pkg_fun,
           target_dir,
           substitute_framework = FALSE) {
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
      # substitute framework:: with local_fun$
      if (substitute_framework == TRUE) {
        thefun <-
          gsub(pattern = 'framework::',
               replacement = 'local_fun$',
               x = thefun)
      }
      # include function_call and overwrite file
      cat(function_call, thefun, sep = '\n', file = filename)
    }
  }