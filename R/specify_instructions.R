specify_instructions <-
  function (filename_in,
            basename_in,
            filename_image,
            filename_mtime,
            filename_Rmd,
            instruction)
  {
    if (instruction == "load") {
      load(filename_image, envir = .GlobalEnv)
    }
    else if (instruction == "source") {
      source(filename_in)
      x <- strftime(file.mtime(filename_in))
      saveRDS(object = x, file = filename_mtime)
      save(list = ls(.GlobalEnv), file = filename_image)
    } else if (instruction == "render") {
      rmarkdown::render(
        input = filename_in,
        envir = globalenv(),
        output_format = 'all',
        clean = FALSE
      )
      x <- strftime(file.mtime(filename_in))
      saveRDS(object = x, file = filename_mtime)
      save(list = ls(.GlobalEnv), file = filename_image)
    }
  }
