source_or_load <-
  function() {
    #### check if cache files exists ####
    if (any(
      file.exists(
        'cache/load_me.rds',
        'cache/source_me.rds',
        'cache/df_cache_R.rds'
      ) == FALSE
    ) == TRUE) {
      warning('cache files not found: call <<prepare_cache>> and retry')
    } else {
      #### load cache files ####
      load_me <- readRDS('cache/load_me.rds')
      source_me <- readRDS('cache/source_me.rds')
      df_cache_R <- readRDS('cache/df_cache_R.rds')
      input_R <- df_cache_R$filename_full
      #### check missing files ####
      # check if any image.Rdata for corresponding mtime.rds is missing
      # if any file is missing: source everything new
      if (identical(
        file.exists(df_cache_R$filename_image),
        file.exists(df_cache_R$filename_mtime)
      ) == FALSE) {
        lapply(X = input_R, FUN = framework::source_n_save)
      } else {
        #### check if length of source_me == 0 ####
        if (identical(sum(as.integer(is.na(source_me))), length(source_me))) {
          # load the most recent image of cached files
          load(load_me[length(load_me)], envir = .GlobalEnv)
          #### check if length of load_me == 0 ####
        } else if (identical(sum(as.integer(is.na(load_me))), length(load_me))) {
          # source every R script in df_cache_R
          lapply(X = source_me, FUN = framework::source_n_save)
          #### load most recent image and source the rest ####
          # according to source_me.rds and load_me.rds
        } else {
          load(load_me[length(load_me)], envir = .GlobalEnv)
          lapply(X = source_me, FUN = framework::source_n_save)
        }
      }
    }
  }
