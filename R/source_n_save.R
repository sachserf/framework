source_n_save <-
  function(file_path,
           target_mtime,
           target_image,
           use_cache = TRUE) {
    #### specify target file paths ####
    if (use_cache == TRUE) {
      # check if cache file is missing
      if (file.exists('cache/df_cache_R.rds')) {
        # load df_cache_R
        df_cache_R <- readRDS('cache/df_cache_R.rds')
        # specify target_mtime
        target_mtime <-
          df_cache_R[grep(file_path, df_cache_R$filename_full) , "filename_mtime"]
        # specify target_mtime
        target_image <-
          df_cache_R[grep(file_path, df_cache_R$filename_full) , "filename_image"]
      } else {
        warning(
          'cache file not found. choose option use_cache = FALSE or call prepare_cache and retry.'
        )
      }
    }
    #### source input file ####
    source(file_path)
    #### create dir ####
    if (dir.exists(dirname(target_mtime)) == FALSE) {
      dir.create(path = dirname(target_mtime), recursive = TRUE)
    }
    #### save mtime.rds ####
    x <- strftime(file.mtime(file_path))
    saveRDS(object = x, file = target_mtime)
    rm(x)
    #### save image ####
    save.image(file = target_image)
  }
