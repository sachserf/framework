compile_notebooks <-
  function(file_path,
           target_dir = 'cache/notebooks',
           figure_output = 'figure') {
    #### specify cache files and directories ####
    # no extension
    target_files_no_ext <- paste0(target_dir, '/',
                                 substr(
                                   basename(file_path),
                                   start = 1,
                                   stop = (nchar(basename(file_path)) -
                                             2)
                                 ))
    # add extensions
    target_Rmd <- paste0(target_files_no_ext, '.Rmd')
    # cache directory for figures
    target_figure <- file.path(dirname(target_Rmd), 'figure')[1]
    
    #### create directories in target ####
    # create dir figure in target
    if (dir.exists(target_figure) == FALSE) {
      dir.create(target_figure, recursive = TRUE)
    }
    
    #### stitch files ####
    for (i in seq_along(file_path)) {
      knitr::stitch_rmd(script = file_path[i],
                        output = target_Rmd[i],
                        envir = globalenv())
    }
    
    #### copy new 'stitched' figures to cache directory ####
    # check if there are new figures in base-directory
    if (dir.exists('figure') == TRUE) {
      file.copy(
        from = list.files('figure', full.names = TRUE),
        to = paste0(target_figure, '/', list.files('figure')),
        overwrite = TRUE
      )
      unlink('figure', recursive = TRUE)
    }
    # render Rmd files
    for (i in seq_along(target_Rmd)) {
      rmarkdown::render(input = target_Rmd[i])
    }
    # unlink Rmd files
    unlink(target_Rmd, recursive = TRUE)
    # cut n paste figures to different_location
    source_fig <-
      list.files(paste0(target_figure, '/', list.files('figure')), full.names = TRUE)
    target_fig <- paste0(figure_output, '/', basename(source_fig))
    if (length(source_fig) == 0) {
      unlink(target_figure, recursive = TRUE)
    } else {
      if (figure_output != 'figure') {
        if (dir.exists(figure_output) == FALSE) {
          dir.create(figure_output, recursive = TRUE)
        }
        
        if (length(source_fig) > 0) {
          file.copy(from = source_fig,
                    to = target_fig,
                    overwrite = TRUE)
        }
        unlink(dirname(source_fig), recursive = TRUE)
      }
    }
  }
