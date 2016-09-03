#' Create a template R-file
#' 
#' @param file Character. Specify the path to save the new file. Use relative
#'   file paths and specify the file extension; e.g. 'in/src/new_dir/myfile.R'.
#' @param Author Character. Optionally customize the name of the Author (used
#'   for the YAML header). Default is the effective user of the system info.
#' @param Date Character. Optionally customize the date (used for the YAML
#'   header). Default is the current Date (format YYYY-MM-DD).
#' @note Missing directories will be created recursively.
#' @note It is not possible to overwrite existing files.
#' @note The file contains a YAML header and Roxygen comment prefixes. It is
#'   possible to source these file as well as to spin it (using knitr).
#' @note Other YAML header options will be choosen automatically. Edit the
#'   resulting file to customize the YAML header.
#' @author Frederik Sachser
#' @export
template_R <-
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
             stop = nchar(basename(file)) - 2)
    if (file.exists(file) == TRUE) {
      warning("File exists.")
    }
    else {
      cat("#' ---\n#' title: '", header, "'\n#' author: '",Author, "'\n#' date: '",Date, "'\n#' output: \n#'  html_document: \n#'    number_sections: yes\n#'    toc: yes\n#'    toc_float: yes\n#'    theme: cosmo\n#'    highlight: textmate\n#' ---\n\n#+ setup, include=FALSE\nknitr::opts_chunk$set(dev = c('png', 'pdf'), dpi = 100) # first 'dev'-value should be suitable for output format specifies in YAML metadata (e.g.: html_document and word_document: png or jpeg, pdf_document: pdf) \n\n\n#' # Note\n#' This file was created by calling the function 'template_R'.\n#+ chunk_label\n\n",
          file = file,
          sep = ""
      )
    }
  }
