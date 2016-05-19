specify_instructions <-
  function(filename_in,
           basename_in,
           filename_image,
           filename_mtime,
           filename_Rmd,
           instruction) {
    # load
    if (instruction == 'load') {
      load(filename_image, envir = .GlobalEnv)
      # source
    } else if (instruction == 'source') {
      source(filename_in)
      x <- strftime(file.mtime(filename_in))
      saveRDS(object = x, file = filename_mtime)
      save(list = ls(.GlobalEnv), file = filename_image)
      # spin
    } else if (instruction == 'spin') {
      knitr::spin(hair = filename_in, envir = globalenv(), precious = TRUE)
      x <- strftime(file.mtime(filename_in))
      saveRDS(object = x, file = filename_mtime)
      save(list = ls(.GlobalEnv), file = filename_image)
      # rename figures
      if (dir.exists('figure') == TRUE) {
        script_names <-
          gsub(pattern = '.R',
               replacement = '',
               x = basename_in)
        dir.create(file.path('figure', script_names))
        figures_path <- list.files(
          path = 'figure',
          pattern = '.png',
          full.names = TRUE,
          recursive = FALSE
        )
        fig_path_basename_dir <-
          file.path('figure', script_names, basename(figures_path))
        file.rename(from = figures_path, to = fig_path_basename_dir)
      }
    }
  }
