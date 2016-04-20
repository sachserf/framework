make_source <- function(wa, use_cache = TRUE) {
  if (use_cache == TRUE) {
    # check if file.info about input/data exists and load it
    if (file.exists('cache/input_data.rds') == TRUE) {
      input_data_current <-
        sapply(X = list.files(
          'input/data',
          full.names = TRUE,
          recursive = TRUE
        ),
        FUN = file.info)
      input_data_source <- readRDS(file = 'cache/input_data.rds')
      # check if file.info about input/data changed since last source
      if (all.equal(target = input_data_source, input_data_current) == TRUE) {
        # prepare cache
        framework::prepare_cache(input_R = wa)
        # source or load input_R
        framework::source_or_load()
      } else {
        warning(
          'files in directory <<input/data>> changed - use option <<use_cache = FALSE>> and retry.'
        )
      }
    } else {
      # delete cache
      unlink(x = 'cache', recursive = TRUE)
      # prepare cache
      framework::prepare_cache(input_R = wa)
      # source all
      framework::source_or_load()
    }
  } else {
    # delete cache
    unlink(x = 'cache', recursive = TRUE)
    # prepare cache
    framework::prepare_cache(input_R = wa)
    # source all
    framework::lapply(X = wa, FUN = source)
  }
}
