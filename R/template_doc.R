#' Create a template script-file
#'
#' @description This function will create an R or Rmd-file (depending on the
#'   file extension of the input) including some predefined lines. By using this
#'   template for Rmd-files within a framework-project it is straightforward to
#'   save all plots you will specify within the script as pdf and png version
#'   (using rmarkdown::render). The function is designed to save some time
#'   writing the same input again and again (e.g. Author, date and other
#'   things).
#' @param file Character. Specify the path to save the new file. Use relative 
#'   file paths and specify the file extension; e.g. 
#'   'in/src/new_dir/myfile.Rmd'. or 'in/in/src/new_dir/myfile.R'. If the
#'   extension is neither .R nor .Rmd (e.g. no extension) an .Rmd-extension will
#'   be added by default.
#' @param Author Character. Optionally customize the name of the Author (used
#'   for the YAML header). Default is the effective user of the system info.
#' @param Date Character. Optionally customize the date (used for the YAML
#'   header). Default is the current Date (format YYYY-MM-DD).
#' @param open Logical. If TRUE the file will be opened (via `file.edit``).
#' @param doctype Character. Specify file extension for different output formats of Rmd-files (pdf, html, docx). Currently only html-output is available for R-scripts. Doctype will be ignored if file ends with '.R'.
#' @note Missing directories will be created recursively.
#' @note It is not possible to overwrite existing files.
#' @note Other YAML header options will be choosen automatically. Edit the
#'   resulting file to customize the YAML header.
#' @author Frederik Sachser
#' @export
template_doc <-
  function(file,
           Author = Sys.info()["effective_user"],
           Date = "`r Sys.Date()`",
           open = TRUE,
           doctype = "html")
  {
    if (dir.exists(paths = dirname(file)) == FALSE) {
      dir.create(path = dirname(file), recursive = TRUE)
    }
    
    # check file extension
    if (tolower(substr(
      x = basename(file),
      start = nchar(basename(file)) - 3,
      stop = nchar(basename(file))
    )) == ".rmd") {
      fileext <- ".Rmd"
    } else if (toupper(substr(
      x = basename(file),
      start = nchar(basename(file)) - 1,
      stop = nchar(basename(file))
    )) == ".R") {
      fileext = ".R"
    } else {
      print("File extension is neither .Rmd nor .R: using .Rmd per default")
      fileext = "no_R_nor_RMD"
    }
    
    # assign filename and title from filename
    if (fileext == ".Rmd") {
      header <-
        substr(x = file,
               start = 1,
               stop = nchar(file) - 4)
      file <- paste0(header, ".Rmd")
    } else if (fileext == ".R") {
      header <-
        substr(x = file,
               start = 1,
               stop = nchar(file) - 2)
      file <- paste0(header, ".R")
    } else {
      header <- file
      file <- paste0(file, ".Rmd")
    }
    header <- basename(header)
  
    # count number of subdirs from top level to file
    source_dir <- dirname(file)
    
    nr_subdir <- nchar(source_dir) - nchar(gsub(pattern = "/", 
                                                replacement = "", x = source_dir))
    nr_subdir <- nr_subdir + 1
    paste_nr_subdir <- paste(rep("..", nr_subdir), collapse = "/")
    
    # check if file exists
    if (file.exists(file) == TRUE) {
      stop("File exists. Choose different file path.")
    }
    
    # write file
    else if (fileext == ".R") {
      cat(
        "#' ---\n#' title: '",
        header,
        "'\n#' author: '",
        Author,
        "'\n#' date: '",
        Date, 
        "'\n#' output: \n#'  html_document:\n#'    theme: journal\n#'    highlight: tango\n#'    df_print: kable\n#'    fig_caption: yes\n#'    number_sections: yes\n#'    collapsed: yes\n#'    code_folding: hide\n#'    toc: yes\n#'    toc_float: yes\n#'    toc_depth: 5\n#' #    keep_md: yes\n#'---\n\n#+ setup_", header, ", include=FALSE\n# set knitr chunk options\n   # pdf AND png output of figures\n      # first 'dev'-value should be suitable for output format specified in YAML metadata (html+word = raster graphics, pdf = vector graphics)\n          # for raster graphics: optionally adjust dpi\nknitr::opts_chunk$set(dev = c('png', 'pdf'), \n                      dpi = 100)\n\n# set knitr package options\n    # set working directory to top level of the current project (this option only changes the behaviour of the code chunks --> the working directory for markdown will be the same as this document)\nknitr::opts_knit$set(root.dir = normalizePath('", paste_nr_subdir, "')) \n\n#' # Note\n#' This file was created by calling the function 'framework::template_doc'.\n#+ chunk_label\n\n",
        file = file,
        sep = ""
      )
    }
    else {
      
      if (doctype == "html") {
      cat(
        "---\ntitle: '",
        header,
        "'\nauthor: '",
        Author,
        "'\ndate: '",
        Date, 
        "'\noutput: \n  html_document:\n    theme: journal\n    highlight: tango\n    df_print: kable\n    fig_caption: yes\n    number_sections: yes\n    collapsed: yes\n    code_folding: hide\n    toc: yes\n    toc_float: yes\n    toc_depth: 5\n#    keep_md: yes\n# bibliography: path2.bib\nlink-citations: yes\n# csl: path2.csl # https://github.com/citation-style-language/styles\n---\n\n```{r setup_", header, ", include=FALSE}\n# set knitr chunk options\n   # pdf AND png output of figures\n      # first 'dev'-value should be suitable for output format specified in YAML metadata (html+word = raster graphics, pdf = vector graphics)\n          # for raster graphics: optionally adjust dpi\nknitr::opts_chunk$set(dev = c('png', 'pdf'), \n                      dpi = 100)\n\n# set knitr package options\n    # set working directory to top level of the current project (this option only changes the behaviour of the code chunks --> the working directory for markdown will be the same as this document)\nknitr::opts_knit$set(root.dir = normalizePath('", paste_nr_subdir, "'))\n``` \n\n# Note\nThis file was created by calling the function 'framework::template_doc'.\n\n",
        file = file,
        sep = ""
      )
      } else if (doctype == "pdf")  {
        cat(
          "---\ntitle: '",
          header,
          "'\nauthor: '",
          Author,
          "'\ndate: '",
          Date, 
          "'\noutput: \n  pdf_document:\n    highlight: tango\n    df_print: kable\n    fig_caption: yes\n    number_sections: yes\n    toc: yes\n    toc_depth: 5\n#    keep_tex: yes\n    latex_engine: xelatex\nmainfont: 'Arial'\nlinkcolor: 'blue'\nurlcolor: 'blue'\ncitecolor: 'blue'\nfontsize: 12pt\ngeometry: margin=1in\nclassoption: oneside\ntoc: yes\nlot: yes\nlof: yes\n# bibliography: path2.bib\nlink-citations: yes\n# csl: path2.csl # https://github.com/citation-style-language/styles\n---\n\n```{r setup_", header, ", include=FALSE}\n# set knitr chunk options\n   # pdf AND png output of figures\n      # first 'dev'-value should be suitable for output format specified in YAML metadata (html+word = raster graphics, pdf = vector graphics)\n          # for raster graphics: optionally adjust dpi\nknitr::opts_chunk$set(dev = c('png', 'pdf'), \n                      dpi = 100)\n\n# set knitr package options\n    # set working directory to top level of the current project (this option only changes the behaviour of the code chunks --> the working directory for markdown will be the same as this document)\nknitr::opts_knit$set(root.dir = normalizePath('", paste_nr_subdir, "'))\n``` \n\n# Note\nThis file was created by calling the function 'framework::template_doc'.\n\n",
          file = file,
          sep = ""
        )
      } else if (doctype == "docx") {
        cat(
          "---\ntitle: '",
          header,
          "'\nauthor: '",
          Author,
          "'\ndate: '",
          Date, 
          "'\noutput: \n  word_document:\n    highlight: tango\n    df_print: kable\n    fig_caption: yes\n    toc: yes\n    keep_md: yes\n# bibliography: path2.bib\nlink-citations: yes\n# csl: path2.csl # https://github.com/citation-style-language/styles\n---\n\n```{r setup_", header, ", include=FALSE}\n# set knitr chunk options\n   # pdf AND png output of figures\n      # first 'dev'-value should be suitable for output format specified in YAML metadata (html+word = raster graphics, pdf = vector graphics)\n          # for raster graphics: optionally adjust dpi\nknitr::opts_chunk$set(dev = c('png', 'pdf'), \n                      dpi = 100)\n\n# set knitr package options\n    # set working directory to top level of the current project (this option only changes the behaviour of the code chunks --> the working directory for markdown will be the same as this document)\nknitr::opts_knit$set(root.dir = normalizePath('", paste_nr_subdir, "'))\n``` \n\n# Note\nThis file was created by calling the function 'framework::template_doc'.\n\n",
          file = file,
          sep = ""
        )
        }
    }
    
    ############################################################################
    
    
    
    if (open == TRUE) {
      utils::file.edit(file)
    }
  }
