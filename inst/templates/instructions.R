#' Wrap your instructions!
#'
#' @description This function is the heart of the package 'framework'. It is a
#'   wrapper for the following functions: 'prepare_instructions',
#'   'implement_instructions', 'check_instructions',
#'   'delete_deprecated_instructions', 'execute_instructions' and
#'   'output_instructions'.
#' @inheritParams project_framework
#' @seealso \code{\link{prepare_instructions}},
#'   \code{\link{implement_instructions}}, \code{\link{check_instructions}},
#'   \code{\link{delete_deprecated_instructions}},
#'   \code{\link{execute_instructions}}, \code{\link{output_instructions}}
#' @author Frederik Sachser
#' @export
instructions <-
  function(source_files,
            spin_index,
            cache_index,
            cache_dir,
            source_dir,
            data_dir,
            target_dir_figure,
            target_dir_docs,
            rename_figure,
            rename_docs,
            knitr_cache)
  {
    list2env(prepare_instructions(
      source_files,
      spin_index,
      cache_index,
      cache_dir,
      source_dir,
      data_dir,
      target_dir_figure,
      target_dir_docs,
      rename_figure,
      rename_docs,
      knitr_cache
    ), envir = environment())
    df_source_files <- implement_instructions(source_files,
                           spin_index,
                           cache_index,
                           cache_dir,
                           source_dir,
                           target_dir_figure,
                           target_dir_docs)
    df_source_files <- check_instructions(source_files,
                       cache_dir,
                       source_dir,
                       data_dir,
                       target_dir_figure,
                       target_dir_docs,
                       path_snapshot_source_dir,
                       path_snapshot_data_dir,
                       df_source_files)

    delete_deprecated_instructions(source_files,
                                   cache_dir,
                                   data_dir,
                                   df_source_files)
    # hier weiter:
    execute_instructions(cache_dir,
                         source_dir,
                         data_dir,
                         target_dir_figure,
                         target_dir_docs,
                         path_snapshot_source_dir,
                         path_snapshot_data_dir,
                         knitr_cache,
                         df_source_files)
    if (is.null(target_dir_figure) == FALSE |
        is.null(target_dir_docs) == FALSE) {
      output_instructions(cache_dir,
                          source_dir,
                          target_dir_figure,
                          target_dir_docs,
                          rename_figure,
                          rename_docs,
                          df_source_files)
    } else {
      unlink(c(target_dir_figure, target_dir_docs), recursive = TRUE)
    }
    file.remove(file.path(cache_dir, "instructions.RData"))
  }
