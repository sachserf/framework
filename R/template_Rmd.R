#' Create a template Rmd-file
#' 
#' @param file Character. Specify the path to save the new file. Use relative
#'   file paths and specify the file extension; e.g.
#'   'in/src/new_dir/myfile.Rmd'.
#' @param Author Character. Optionally customize the name of the Author (used
#'   for the YAML header). Default is the effective user of the system info.
#' @param Date Character. Optionally customize the date (used for the YAML
#'   header). Default is the current Date (format YYYY-MM-DD).
#' @note Missing directories will be created recursively.
#' @note It is not possible to overwrite existing files.
#' @note Other YAML header options will be choosen automatically. Edit the
#'   resulting file to customize the YAML header.
#' @author Frederik Sachser
#' @export
template_Rmd <-
  function(file,
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
      stop("File exists.")
    }
    else {
      cat("---\ntitle: '", header, "'\nauthor: '",Author, "'\ndate: '",Date, "'\noutput: \n  html_notebook: \n    number_sections: yes\n    toc: yes\n    toc_float: yes\n    theme: united\n    highlight: tango\n---\n\n```{r setup, include=FALSE}\n# additional pdf-output of figures\nknitr::opts_chunk$set(dev = c('png', 'pdf'), dpi = 100) # first value should be suitable for output format (e.g.: html=png, docx=jpeg, pdf=pdf)  \n```\n\n# Note\n\nThis file was created by calling the function 'template_Rmd'.\n\n",
          file = file,
          sep = ""
      )
    }
  }
