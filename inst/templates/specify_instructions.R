#' Specify instructions!
#'
#' @description This function is not meant to be called directly by the user. It
#'   is integrated into the function 'execute_instructions'.
#' @param target_dir_docs For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param target_dir_figure For further information and examples run the
#'   function 'instructions' and open the file 'df_source_files.rds' within the
#'   cache directory.
#' @param source_dir For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param filename For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param image_cache For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param instruction For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param docs_out For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param filename_noxt For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param basename_noxt For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param temp_docs_out For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param figure_source For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param figure_out For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param use_spin For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param file_ext For further information and examples run the function
#'   'instructions' and open the file 'df_source_files.rds' within the cache
#'   directory.
#' @param knitr_cache knitr_cache Logical. If you want to use the package
#'   'knitr' to cache chunks of a file you should additionally specify
#'   knitr_cache = TRUE.
#' @note This function is part of a family of functions each of which end with
#'   '_instructions'. The order to call these functions is:
#'   'prepare_instructions', 'implement_instructions', 'check_instructions',
#'   'delete_deprecated_instructions', 'execute_instructions' and optionally
#'   'output_instructions'. There is a wrapper for these functions called
#'   'instructions'.
#' @seealso \code{\link{prepare_instructions}},
#'   \code{\link{implement_instructions}}, \code{\link{check_instructions}},
#'   \code{\link{instructions}}, \code{\link{execute_instructions}},
#'   \code{\link{output_instructions}}
#' @author Frederik Sachser
#' @export
specify_instructions <-
  function(target_dir_docs,
           target_dir_figure,
           source_dir,
           filename,
           image_cache,
           instruction,
           docs_out,
           filename_noxt,
           basename_noxt,
           temp_docs_out,
           figure_source,
           figure_out,
           use_spin,
           file_ext,
           knitr_cache)
  {
    # deprecated source_files
    files_source_dir <- list.files(source_dir, full.names = TRUE, recursive = TRUE)
    filename_dot <- paste0(filename_noxt, ".")
    source_docs <-
      files_source_dir[grep(pattern = filename_dot,
                            x = files_source_dir,
                            fixed = TRUE)]
    source_docs_fig <- c(source_docs, figure_source)
    delsource <-
      source_docs_fig[-which(source_docs_fig == filename)]

    # deprecated rendered_docs
    depr_docs_out <- paste0(docs_out, "_", basename_noxt, ".")
    if (is.null(target_dir_docs) == FALSE) {
      output_docs <- list.files(target_dir_docs, full.names = TRUE)
      deldocs <-
        output_docs[grep(pattern = depr_docs_out,
                         x = output_docs,
                         fixed = TRUE)]
      # deprecated temp_docs
      deltemp <- temp_docs_out
    }

    # deprecated rendered figures
    if (is.null(target_dir_figure) == FALSE) {
      output_figs <- list.files(target_dir_figure, full.names = TRUE)
      delfig <-
        output_figs[grep(pattern = figure_out, x = output_figs)]
    }

    # vector of all deprecated files
    if (is.null(target_dir_figure) == FALSE &
        is.null(target_dir_docs) == FALSE) {
      delete_deprecated_files <-
        c(delsource, deldocs, delfig, deltemp)
    } else if (is.null(target_dir_figure) == FALSE &
               is.null(target_dir_docs) == TRUE) {
      delete_deprecated_files <-
        c(delsource, delfig)
    } else if (is.null(target_dir_figure) == TRUE &
               is.null(target_dir_docs) == FALSE) {
      delete_deprecated_files <-
        c(delsource, deldocs, deltemp)
    } else {
      delete_deprecated_files <- delsource
    }


    # delete rendered files if R-file should not be spinned
#    if (file_ext == "R" & use_spin == FALSE) {
#      unlink(delete_deprecated_files, recursive = TRUE)
#    }

    if (instruction != "nothing") {
      # specify instruction "load"
      if (instruction == "load") {
        load(image_cache, envir = .GlobalEnv)
      }
      else {
        # delete deprecated files
        if (knitr_cache == FALSE) {
          unlink(x = delete_deprecated_files, recursive = TRUE)
        }

        # specify instruction "source"
        if (instruction == "source") {
          dir.create(path = figure_source, showWarnings = FALSE, recursive = TRUE)
          grDevices::pdf(file.path(figure_source, paste0("all_plots.pdf")))
          cat("\n#############################################\n#############################################\n", filename, "\n#############################################\n#############################################\n")
#          con <- file("meta/temp.log")
#          sink(con, append = TRUE)
#          sink(con, append = TRUE, type = "message")
#          cat("Warnings/Messages of:\n", filename, "\n\n")
          source(filename)
          grDevices::dev.off()
#          sink()
#          sink(type = "message")
#          file.rename("meta/temp.log", file.path("meta/", paste0(basename_noxt, ".log")))
          save(list = ls(.GlobalEnv), file = image_cache)
        }
        # specify instruction "render"
        else if (instruction == "render") {
          cat("\n#############################################\n#############################################\n", filename, "\n#############################################\n#############################################\n")
#          con <- file("meta/temp.log")
#          sink(con, append = TRUE)
#          sink(con, append = TRUE, type = "message")
#          cat("Warnings/Messages of:\n", filename, "\n\n")
          rmarkdown::render(
            input = filename,
            envir = globalenv(),
            output_format = "all",
            clean = FALSE,
            knit_root_dir = prj_toplvl,
            quiet = TRUE
          )
          save(list = ls(.GlobalEnv), file = image_cache)
#          sink()
#          sink(type = "message")
#          file.rename("meta/temp.log", file.path("meta/", paste0(basename_noxt, ".log")))
        }
        # specify instruction "knit"
        else if (instruction == "knit") {
          cat("\n#############################################\n#############################################\n", filename, "\n#############################################\n#############################################\n")
 #         con <- file("meta/temp.log")
#          sink(con, append = TRUE)
#          sink(con, append = TRUE, type = "message")
#          cat("Warnings/Messages of:\n", filename, "\n\n")
          knitr::knit2pdf(input = filename,
                          envir = globalenv(),
                          quiet = TRUE,
                          output = file.path(prj_toplvl, paste0(basename_noxt, ".tex")))
#          sink()
#          sink(type = "message")
#          file.rename("meta/temp.log", file.path("meta/", paste0(basename_noxt, ".log")))
          dir.create(figure_source, showWarnings = FALSE)
          file.copy(from = "figure", to = dirname(figure_source), recursive = TRUE)
          unlink(file.path("figure"), recursive = TRUE)
          file.rename(from = file.path(prj_toplvl, paste0(basename_noxt, ".tex")), to = file.path(prj_toplvl, paste0(filename_noxt, ".tex")))
          file.rename(from = file.path(prj_toplvl, paste0(basename_noxt, ".log")), to = file.path(prj_toplvl, paste0(filename_noxt, ".log")))
          file.rename(from = file.path(prj_toplvl, paste0(basename_noxt, ".aux")), to = file.path(prj_toplvl, paste0(filename_noxt, ".aux")))
          file.rename(from = file.path(prj_toplvl, paste0(basename_noxt, ".pdf")), to = file.path(prj_toplvl, paste0(filename_noxt, ".pdf")))
          file.rename(from = file.path(dirname(figure_source), paste0("figure")), to = figure_source)
          save(list = ls(.GlobalEnv), file = image_cache)
        }

      }
    }
  }


