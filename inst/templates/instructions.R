#' instructions
#' @description instructions
#' @export
instructions <-
  function (source_files,
            spin_index,
            cache_index,
            cache_dir,
            source_dir,
            data_dir,
            target_dir_figure,
            target_dir_docs,
            rename_figure,
            rename_docs)
  {
    prepare_instructions(
      source_files,
      spin_index,
      cache_index,
      cache_dir,
      source_dir,
      data_dir,
      target_dir_figure,
      target_dir_docs,
      rename_figure,
      rename_docs
    )
    implement_instructions(cache_dir)
    check_instructions(cache_dir)
    execute_instructions(cache_dir)
    if (is.null(target_dir_figure) == FALSE |
        is.null(target_dir_docs) == FALSE) {
      output_instructions(cache_dir)
    } else {
      unlink(c(target_dir_figure, target_dir_docs), recursive = TRUE)
    }
    file.remove(file.path(cache_dir, "instructions.RData"))
  }
