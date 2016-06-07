specify_instructions <- 
  function (filename_in, basename_in, filename_image, filename_mtime, 
            filename_Rmd, instruction) 
  {
    if (instruction == "load") {
      load(filename_image, envir = .GlobalEnv)
    }
    else if (instruction == "source") {
      source(filename_in)
      x <- strftime(file.mtime(filename_in))
      saveRDS(object = x, file = filename_mtime)
      save(list = ls(.GlobalEnv), file = filename_image)
      #    }
      #    else if (instruction == "spin") {
      #        knitr::spin(hair = filename_in, envir = globalenv(), 
      #            precious = TRUE)
      #        x <- strftime(file.mtime(filename_in))
      #        saveRDS(object = x, file = filename_mtime)
      #        save(list = ls(.GlobalEnv), file = filename_image)
      #        if (dir.exists("figure") == TRUE) {
      #            script_names <- gsub(pattern = ".R", replacement = "", 
      #                x = basename_in)
      #            dir.create(file.path("figure", script_names))
      # start
      # figures_path <- list.files(path = "figure", pattern = ".png", 
      #     full.names = TRUE, recursive = FALSE)
      #            figures_path <- list.files(path = "figure", #pattern = ".png", 
      #                                       full.names = TRUE, recursive = TRUE)
      # stop
      #            fig_path_basename_dir <- file.path("figure", script_names, 
      #                basename(figures_path))
      #            file.rename(from = figures_path, to = fig_path_basename_dir)
      #        }
      # start
    } else if (instruction == "render") {
      rmarkdown::render(input = filename_in, envir = globalenv(), output_format = 'all', clean = FALSE)
      x <- strftime(file.mtime(filename_in))
      saveRDS(object = x, file = filename_mtime)
      save(list = ls(.GlobalEnv), file = filename_image)
      
      # delete deprecated cache_figures
      #    figure_dir <- paste0(basename_in, '_files')
      #    figure_dir_cache <- file.path('.cache', figure_dir)
      #    unlink(figure_dir_cache, recursive = TRUE)
      
      #    cache_files <- list.files(path = '.cache/docs', full.names = TRUE, recursive = TRUE)
      #    pdf_files <- paste0(basename_in, '.pdf')
      #    html_files <- paste0(basename_in, '.html')
      #    nb_files <- paste0(basename_in, '.nb.html')
      #    del_deprecated_cache_files <- cache_files[cache_files %in% c(pdf_files, html_files, nb_files)]
      #    unlink(del_deprecated_cache_files, recursive = TRUE)
    }
  }
