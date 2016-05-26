render_Rmd <-
  function (source_dir = 'in/Rmd',
            target_dir = 'out/auto/reports'
            , ...)
  {
    # list all files if input is directory
    source_files <-
      list.files(
        path = source_dir,
        pattern = ".Rmd",
        recursive = TRUE,
        full.names = TRUE,
        ignore.case = TRUE
      )
    # kick out Rmd-files with preceding '_'
    no_ <-
      source_files[-grep(pattern = '_',
                         x = substr(basename(source_files),
                                    start = 1,
                                    stop = 1))]
    if (length(no_) != 0) {
      source_files <-
        source_files[-grep(pattern = "_",
                           x = substr(
                             basename(source_files),
                             start = 1,
                             stop = 1
                           ))]
    }
    # render
    lapply(
      X = source_files,
      FUN = rmarkdown::render,
      ...
    )
    
    # delete and create target dir
    if (dir.exists(target_dir) == TRUE) {
      unlink(target_dir, recursive = TRUE)
    }
    dir.create(target_dir, recursive = TRUE)
    
    # prepare names to copy html files
    no_ext <-
      substr(x = source_files,
             start = 1,
             stop = nchar(source_files) - 3)
    html_names_source <- paste0(no_ext, 'html')
    html_names_target <-
      paste0(target_dir, '/', basename(html_names_source))
    
    # cut and paste html files
    file.rename(from = html_names_source, to = html_names_target)
  }
