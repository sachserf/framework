template_Rmd <-
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
             stop = nchar(basename(file)) - 4)
    if (file.exists(file) == TRUE) {
      warning("File exists.")
    }
    else {
      cat("---\ntitle: '", header, "'\nauthor: '",Author, "'\ndate: '",Date, "'\noutput: \n  html_notebook: \n    number_sections: yes\n    toc: yes\n    toc_float: yes\n    theme: united\n    highlight: tango\n---\n\n```{r setup, include=FALSE}\n# additional pdf-output of figures\nknitr::opts_chunk$set(dev = c('png', 'pdf'), dpi = 100) # first value should be suitable for output format (e.g.: html=png, docx=jpeg, pdf=pdf)  \n```\n\n# Note\n\nThis file was created by calling the function 'template_Rmd'.\n\n",
          file = file,
          sep = ""
      )
    }
  }
