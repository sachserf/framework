#' instructions
#' @description instructions
#' @export
instructions <- function(source_files,
                         spin_index,
                         cache_index,
                         cache_dir,
                         source_dir,
                         data_dir,
                         target_dir_figure,
                         target_dir_docs) {
    prepare_instructions(source_files,
                         spin_index,
                         cache_index,
                         cache_dir,
                         source_dir,
                         data_dir,
                         target_dir_figure,
                         target_dir_docs)
    implement_instructions(cache_dir)
    check_instructions(cache_dir)
    execute_instructions(cache_dir)
}
