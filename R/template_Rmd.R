template_Rmd <-
  function (file, Author = Sys.info()['effective_user'], Date = '`r Sys.Date()`')
  {
    if (dir.exists(paths = dirname(file)) == FALSE) {
      dir.create(path = dirname(file), recursive = TRUE)
    }
    split_elements <- strsplit(file, split = "/")
    last_element <- lapply(split_elements, `[[`, 3)
    header <-
      substr(x = last_element,
             start = 1,
             stop = nchar(last_element) -
               4)
    nr_subdir <-
      nchar(file) - nchar(gsub(
        pattern = "/",
        replacement = "",
        x = file
      ))
    paste_nr_subdir <- paste(rep("..", nr_subdir), collapse = "/")
    if (file.exists(file) == TRUE) {
      warning("File exists.")
    }
    else {
      cat(
        "---\ntitle: '",
        header,
        "'\nauthor: '",
        Author,
        "'\ndate: '",
        Date,
        "'\noutput: \n  html_document: \n    number_sections: yes\n    toc: yes\n    toc_float: yes\n    theme: united\n    highlight: tango\n---\n    \n```{r setup, include=FALSE}\n# set knitr options\nknitr::opts_knit$set(root.dir  = '",
        paste_nr_subdir,
        "')\n  \n# set chunk options\nknitr::opts_chunk$set(echo = FALSE, fig.path = '",
        paste_nr_subdir,
        "/out/auto/figure/",header,"/')\n```\n    \n```{r source_make, include=FALSE}\n# read make.R\nmakefile <- readLines('make.R') \n# exclude some lines from make.R\nmake_trimmed <- makefile[grep('## PREAMBLE ##', makefile) : grep('## SUPPLEMENT ##', makefile) - 1]\n# choose option use_cache = TRUE\nmake_trimmed <- gsub(pattern = 'use_cache = FALSE', replacement = 'use_cache = TRUE', x = make_trimmed)\n# write new file 'ghost_file.R'\ncat(make_trimmed, sep = '\n', file = 'ghost_file.R') \n# source 'ghost_file.R'\nsource(file = 'ghost_file.R', chdir = TRUE)\n# delete 'ghost_file.R'\nunlink('ghost_file.R', recursive = TRUE)\n# clean workspace\nrm(makefile, make_trimmed)\n```\n\n# Note\n\nThis file was created by calling the function 'template_Rmd'.\n\n",
        file = file,
        sep = ""
      )
    }
  }
