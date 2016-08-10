#' Specify instructions for a framework-project
#' 
#' @description This function will be called inside the function
#'   'execute_instructions'. It is not meant to be called directly.
#' @param filename_in Name of the file.
#' @param basename_in Basename of the file.
#' @param filename_image Path to the image of the file.
#' @param filename_mtime mtime of the file.
#' @param filename_Rmd Filename of Rmd-files
#' @param instruction Specification of the instruction.
#' @param filename_dot filename with dot.
#' @author Frederik Sachser
#' @export
specify_instructions <-
  function(filename_in,
            basename_in,
            filename_image,
            filename_mtime,
            filename_Rmd,
            instruction,
            filename_dot)
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
      all_files <- list.files(path = '.cache/docs', full.names = TRUE)
      del_files <- all_files[grep(pattern = filename_dot, x = all_files)]
      unlink(del_files, recursive = TRUE) 
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
