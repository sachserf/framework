#' Check and correct instructions
#'
#' @description This function will check and potentially correct your
#'   instructions (e.g. if you want to load a file from cache the image of the
#'   file should exist).
#' @inheritParams project_framework
#' @param path_snapshot_source_dir Character. File path for the snapshot of the source directory.
#' @param path_snapshot_data_dir Character. File path for the snapshot of the data directory.
#' @param df_source_files Object of class data.frame (i.e. output of the function framework::implement_instructions).
#' @note This function was not designed to be run separately. Use framework::instructions() instead.
#' @seealso \code{\link{prepare_instructions}},
#'   \code{\link{implement_instructions}}, \code{\link{instructions}},
#'   \code{\link{instructions}}, \code{\link{execute_instructions}},
#'   \code{\link{output_instructions}}, \code{\link{delete_deprecated_instructions}}
#' @author Frederik Sachser
#' @export
check_instructions <-
  function(source_files,
            cache_dir,
            source_dir,
            data_dir,
            target_dir_figure,
            target_dir_docs,
           path_snapshot_source_dir,
           path_snapshot_data_dir,
           df_source_files)
  {


    # Check if source dir is part of target_dirs
    if (grepl(
      pattern = paste(cache_dir, target_dir_figure,
                      sep = "|"),
      x = source_dir
    ) == TRUE & is.null(target_dir_figure) == FALSE) {
      stop(
        "Source_dir should neither be equal nor a subdirectory of target directories and/or cache directory! Change paths and retry."
      )
    }
    if (grepl(
      pattern = paste(cache_dir, target_dir_docs,
                      sep = "|"),
      x = source_dir
    ) == TRUE & is.null(target_dir_docs) == FALSE) {
      stop(
        "Source_dir should neither be equal nor a subdirectory of target directories and/or cache directory! Change paths and retry."
      )
    }

    # check snapshot of data-dir

    # if snapshot is missing: do not use cache
    if (file.exists(path_snapshot_data_dir) == FALSE) {
      df_source_files$use_cache_qualified <- FALSE
    } else {
      if (is.null(data_dir) == FALSE & length(list.files(data_dir)) > 0) {
        # check file changes
        # specify changed files
        snapshot_data_dir <- readRDS(file = path_snapshot_data_dir)
        snapshot_data_dir$path <- data_dir
        changed_files <- utils::changedFiles(snapshot_data_dir,
                                             md5sum = TRUE)$changed
        if (length(changed_files) > 0) {
          df_source_files$use_cache_qualified <- FALSE
          message("Cache will be ignored because files in data_dir have changed.")
        }
      }
    }

    # check snapshot of source-dir

    # if snapshot is missing: do not use cache
    if (file.exists(path_snapshot_source_dir) == FALSE) {
      df_source_files$use_cache_qualified <- FALSE
    } else {
      df_source_files$use_cache_qualified <- TRUE
      # check file changes
      # specify changed files
      snapshot_source_dir <-
        readRDS(file = path_snapshot_source_dir)
      snapshot_source_dir$path <- source_dir

      changed_files <- utils::changedFiles(snapshot_source_dir,
                                           md5sum = TRUE)$changed

      changed_files <- file.path(source_dir, changed_files)
      # specify changed files within source_files
      changed_files_index <- source_files %in% changed_files
      # if there are files that did not change - use cache
      if (any(changed_files_index == TRUE)) {
        df_source_files$use_cache_qualified[which(changed_files_index ==
                                                    TRUE)] <- FALSE
      }
    }

    # check image

    # make sure not to use the cache if image of the file is missing
    image_exists <- file.exists(df_source_files$image_cache)
    if (any(image_exists == FALSE)) {
      df_source_files$use_cache_qualified[which(image_exists ==
                                                  FALSE)] <- FALSE
    }

    # check cache-files
    # make sure not to use the cache if rendered files from last session are missing
    if (is.null(target_dir_docs) == FALSE) {
      nofile_index <- paste0(df_source_files$row_names, "_", df_source_files$basename_noxt) %in% tools::file_path_sans_ext(list.files(target_dir_docs, recursive = TRUE))
      df_source_files$use_cache_qualified[which(nofile_index == FALSE & df_source_files$instruction_no_cache == "render")] <- FALSE
    }

    # make sure not to use the cache if required files in cache are missing
    #cache_docs <- sapply(lapply(X = df_source_files$docs_cache,
    #                            FUN = list.files),
    #                     length)
    #if (any(cache_docs == 0)) {
    #  df_source_files$use_cache_qualified[which(cache_docs ==
    #                                              0 &&
    #                                              df_source_files$file_ext != "R")] <- FALSE
    #}

    # check order of source-files

    # check if order of df_cache has changed
    if (file.exists(file.path(cache_dir, "df_source_files.rds"))) {
      df_source_files_old <-
        readRDS(file.path(cache_dir, "df_source_files.rds"))
      df_source_files_both <-
        merge(
          x = df_source_files,
          y = df_source_files_old[,
                                  c("filename", "row_names", "instruction_no_cache")],
          by = "filename",
          all.x = TRUE
        )
      df_source_files_both <-
        df_source_files_both[order(df_source_files_both$row_names.x), ]
      df_source_files_both$pos_match <-
        as.numeric(df_source_files_both$row_names.x) -
        as.numeric(df_source_files_both$row_names.y)
      df_source_files$use_cache_qualified[which(df_source_files_both$pos_match !=
                                                  0)] <- FALSE
      df_source_files$order_change <- FALSE
      df_source_files$order_change[which(df_source_files_both$pos_match !=
                                           0)] <- TRUE
      df_source_files$use_cache_qualified[which(df_source_files_both$pos_match !=
                                                  0)] <- FALSE
      # make sure not to use cache if instruction changed
      df_source_files$instruction_equal <-
        ifelse(
          df_source_files_both$instruction_no_cache.x ==
            df_source_files_both$instruction_no_cache.y,
          TRUE,
          FALSE
        )
      if (any(which(df_source_files$instruction_equal == FALSE) >
              0)) {
        df_source_files$use_cache_qualified[which(
          df_source_files$instruction_equal ==
            FALSE & df_source_files$instruction_no_cache !=
            "source"
        )] <- FALSE
      }
    }
    else {
      df_source_files$use_cache_qualified <- FALSE
    }

    # check existence of (rendered) files (if output should not be copied)
    if (is.null(target_dir_docs) == TRUE) {
      for (i in 1:nrow(df_source_files)) {
        files_source_dir <- list.files(source_dir, full.names = TRUE, recursive = TRUE)
        filename_dot <-
          paste0(df_source_files$filename_noxt[i], ".")
        source_docs <-
          files_source_dir[grep(pattern = filename_dot,
                                x = files_source_dir,
                                fixed = TRUE)]
        render_docs <-
          source_docs[-which(source_docs == df_source_files$filename[i])]
        if (length(render_docs) == 0 & df_source_files$instruction_no_cache[i] != "source") {
          df_source_files$use_cache_qualified[i] <- FALSE
        }
      }
    }

    # hier weiter
    # # check existence of (rendered) files (if output should not be copied)
    # if (is.null(target_dir_figure) == TRUE) {
    #   for (i in 1:nrow(df_source_files)) {
    #     dir.create(df_source_files$figure_source[i], recursive = TRUE, showWarnings = FALSE)
    #     list.files(df_source_files$figure_source[i])
    #
    #     # files_source_dir <-
    #     #   tools::file_path_sans_ext(list.files(source_dir, full.names = TRUE, recursive = TRUE))
    #     # dirname <-
    #     #   paste0(df_source_files$figure_source[1])
    #     # source_docs <-
    #     #   files_source_dir[grep(pattern = dirname,
    #     #                         x = files_source_dir,
    #     #                         fixed = TRUE)]
    #     # render_docs <-
    #     #   source_docs[-which(source_docs == df_source_files$filename[i])]
    #     if (length(render_docs) == 0 & df_source_files$instruction_no_cache[i] != "source") {
    #       df_source_files$use_cache_qualified[i] <- FALSE
    #     }
    #   }
    # }

    # do not use cache if subsequent files are going to be processed
    if (length(which(df_source_files$use_cache_qualified == FALSE)) >
        0) {
      df_source_files$use_cache_qualified[min(which(df_source_files$use_cache_qualified ==
                                                      FALSE)):nrow(df_source_files)] <-
        FALSE
    }

    # add final instructions
    df_source_files$instruction <-
      df_source_files$instruction_no_cache

    # edit instruction according to use-cache
    if (any(df_source_files$use_cache_input == TRUE)) {
      # do not use cache if subsequent files are not in cache_index
      if (any(df_source_files$use_cache_input) == FALSE) {
        df_source_files$use_cache_qualified[min(which(df_source_files$use_cache_input ==
                                                        FALSE)):nrow(df_source_files)] <-
          FALSE
      }
      use_cache_index <- which(
        df_source_files$use_cache_input ==
          TRUE & df_source_files$use_cache_qualified == TRUE
      )
      df_source_files$instruction[use_cache_index] <- "nothing"
    }


    # delete deprecated files in cache
    #    deprecated_cache <-
    #      dirname(df_source_files$docs_cache[df_source_files$instruction !=
    #                                           "nothing"])
    #    if (length(deprecated_cache) > 0) {
    #      lapply(X = deprecated_cache,
    #             FUN = unlink,
    #             recursive = TRUE)
    #    }

    # make sure the most recent file in cache will be loaded
    if (any(df_source_files$instruction == "nothing")) {
      df_source_files$instruction[max(which(df_source_files$instruction ==
                                              "nothing"))] <- "load"
    }

    # make sure all subsequent files of rendered files will be rendered as well
    if (any(df_source_files$instruction == "render")) {
      df_source_files$instruction[min(which(df_source_files$instruction ==
                                              "render")):nrow(df_source_files)] <-
        df_source_files$instruction_no_cache[min(which(df_source_files$instruction ==
                                                         "render")):nrow(df_source_files)]
    }

    # overwrite df_source_files_temp.rds
    saveRDS(object = df_source_files,
            file = file.path(cache_dir,
                             "df_source_files_temp.rds"))
      return(df_source_files)
#    assign("df_source_files", df_source_files, pos = sys.frame())
  }
