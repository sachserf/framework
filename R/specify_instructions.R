#' Specify instructions for a framework-project
#' 
#' @description This function will be called inside the function 
#'   'execute_instructions'. It is not meant to be called directly. It is used
#'   to specify further processing for predefined instructions.
#' @param filename_in Path to input files (.R or .Rmd)
#' @param basename_in Basename of the file without extension.
#' @param filename_image Path to the image of the file (The resulting file of
#'   'save.image()')
#' @param filename_mtime Path to an RDS-file containing information about the
#'   mtime of the input-file ('filename_in').
#' @param filename_Rmd Path to temporary Rmd_files (cache).
#' @param instruction Specification of the instruction. These predefined values
#'   (nothing, load, source, render) will be used to specify the instruction.
#' @param filename_dot Path to a temporary files (cache) ending with a dot (no
#'   extension)
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
