#' delete_deprecated_instructions
#' @description delete_deprecated_instructions
#' @inheritParams project_framework
#' @seealso \code{\link{prepare_instructions}}, 
#'   \code{\link{implement_instructions}}, \code{\link{check_instructions}}, 
#'   \code{\link{instructions}}, \code{\link{execute_instructions}},
#'   \code{\link{output_instructions}}
#' @author Frederik Sachser
#' @export
delete_deprecated_instructions <- function(cache_dir = ".cache") {
  # check prerequisites
  if (any(file.exists(
    file.path(cache_dir, "df_source_files.rds"),
    file.path(cache_dir, "instructions.RData")
  ) == FALSE)) {
    print(
      "Required files in cache are missing. Can not delete deprecated output from last session."
    )
  } else {
    # reload instructions
    load(file.path(cache_dir, "instructions.RData"))
    # reload df_source_files (last session)
    df_last_session <-
      readRDS(file = file.path(cache_dir, "df_source_files.rds"))

    # specify index of source-files that have been excluded since the last session
    delete_index <-
      which(df_last_session$filename %in% source_files == FALSE)

    # figures
    the_figures <- df_last_session[delete_index, "figure_out"]
    for (i in seq_along(the_figures)) {
      unlink(file.path(
        dirname(the_figures[i]),
        list.files(
          path = dirname(the_figures[i]),
          pattern = basename(the_figures[i])
        )
      ), recursive = TRUE)
    }

    # temp_docs
    the_temp_docs <- df_last_session[delete_index, "temp_docs_out"]
    for (i in seq_along(the_temp_docs)) {
      unlink(file.path(
        dirname(the_temp_docs[i]),
        list.files(
          path = dirname(the_temp_docs[i]),
          pattern = basename(the_temp_docs[i])
        )
      ), recursive = TRUE)
    }

    # docs
    the_docs <-
      paste0(df_last_session[delete_index, "docs_out"], "_", df_last_session[delete_index, "basename_noxt"])
    for (i in seq_along(the_docs)) {
      unlink(file.path(
        dirname(the_docs[i]),
        list.files(
          path = dirname(the_docs[i]),
          pattern = basename(the_docs[i])
        )
      ), recursive = TRUE)
    }

    # image_cache
    the_image <- df_last_session[delete_index, "image_cache"]
    for (i in seq_along(the_image)) {
      unlink(file.path(
        dirname(the_image[i]),
        list.files(
          path = dirname(the_image[i]),
          pattern = basename(the_image[i])
        )
      ), recursive = TRUE)
    }
  }
}
