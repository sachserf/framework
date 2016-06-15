template_R <-
  function (file,
            Author = Sys.info()["effective_user"],
            Date = "`r Sys.Date()`")
  {
    if (dir.exists(paths = dirname(file)) == FALSE) {
      dir.create(path = dirname(file), recursive = TRUE)
    }
    header <-
      substr(x = basename(file),
             start = 1,
             stop = nchar(basename(file)) - 2)
    if (file.exists(file) == TRUE) {
      warning("File exists.")
    }
    else {
      cat("#' ---\n#' title: '", header, "'\n#' author: '",Author, "'\n#' date: '",Date, "'\n#' output: \n#'  html_notebook: \n#'    number_sections: yes\n#'    toc: yes\n#'    toc_float: yes\n#'    theme: united\n#'    highlight: tango\n#' ---\n\n#+ setup, include=FALSE\nknitr::opts_chunk$set(dev = c('png', 'pdf'), dpi = 100)\n\n\n#' # Note\n\n#' This file was created by calling the function 'template_R'.\n\n#+ chunk_label\n\n",
          file = file,
          sep = ""
      )
    }
  }
