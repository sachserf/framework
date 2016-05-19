instructions <-
  function (input_R,
            spin_index = 0,
            use_cache = TRUE)
  {
    # detect changes in directory in/data
    if (file.exists(".cache/input_data.rds") == TRUE && use_cache == TRUE) {
      input_data_current <- sapply(X = list.files("in/data", 
                                                  full.names = TRUE, recursive = TRUE), FUN = file.info)
      input_data_source <- readRDS(file = ".cache/input_data.rds")
      if (isTRUE(all.equal(target = input_data_source, current = input_data_current)) == 
          FALSE) {
        stop("files in directory <<in/data>> changed - use option <<use_cache = FALSE>> and retry.")
      }
    }
    
    # delete cache if specified
    if (use_cache == FALSE) {
      unlink(x = ".cache", recursive = TRUE)
    }
    
    # create new cache necessary
    if (dir.exists('.cache') == FALSE) {
      dir.create('.cache')
    }
    
    if (length(spin_index) == 1 && spin_index == 'all') {
      spin_index <- 1:length(input_R)
    }
    
    # prepare names
    filename_in <- paste0(input_R)
    basename_in <-
      gsub(pattern = '.R',
           replacement = '',
           x = basename(input_R))
    filename_image <- paste0('.cache/', basename_in, '_image.RData')
    filename_mtime <- paste0(".cache/", basename_in, "_mtime.rds")
    filename_Rmd <- paste0(".cache/", basename_in, ".Rmd")
    filename_md <- paste0(".cache/", basename_in, ".md")
    filename_html <- paste0(".cache/", basename_in, ".html")
    # get mtime
    mtime_current <- file.mtime(input_R)
    
    # write dataframe
    df_cache <- data.frame(
      filename_in,
      basename_in,
      filename_image,
      filename_mtime,
      filename_Rmd,
      filename_md,
      filename_html,
      mtime_current,
      stringsAsFactors = FALSE
    )
    
    # specify instructions
    df_cache$instruction <- 'source'
    df_cache$instruction[spin_index] <- 'spin'
    
    # delete deprecated images
    filename_image_pre <- list.files(
      path = '.cache',
      pattern = "*_image.RData",
      recursive = TRUE,
      full.names = TRUE
    )
    
    image_del <-
      filename_image_pre[!filename_image_pre %in% df_cache$filename_image]
    unlink(image_del, recursive = TRUE)
    
    # check if filename_mtime exists
    df_cache$file_exist_mtime <-
      file.exists(df_cache$filename_mtime)
    
    # prepare col for reading mtime
    df_cache$mtime_read <- as.POSIXct(x = "1970-01-02")
    
    # load mtime if file exists
    add_mtime_read <- function(row_id) {
      x <- readRDS(df_cache$filename_mtime[row_id])
      df_cache$mtime_read[row_id] <<- x
    }
    file_exist_index <-
      as.integer(which(df_cache$file_exist_mtime ==
                         TRUE))
    lapply(X = file_exist_index, FUN = add_mtime_read)
    df_cache$mtime_read <- as.POSIXct(df_cache$mtime_read)
    
    # delete col
    df_cache$file_exist_mtime <- NULL
    
    # compute time difference between mtime (current and preceding)
    df_cache$difftime <- as.integer(df_cache$mtime_current) -
      as.integer(df_cache$mtime_read)
    
    # define which scripts to load according to difftime
    df_cache$load <- FALSE
    df_cache$load[which(df_cache$difftime == 0)] <- TRUE
    # if mtime changed all following scripts will be sourced or spinned
    if (any(df_cache$difftime != 0) == TRUE) {
      df_cache$load[min(which(df_cache$difftime != 0)):nrow(df_cache)] <-
        FALSE
    }
    
    # Before loading files: check if image exist
    for (i in which(df_cache$load == TRUE)) {
      if (file.exists(df_cache$filename_image[i]) == FALSE) {
        df_cache$load[i] <- FALSE
      }
    }
    
    # Before loading files: check if md exist (while instruction = 'spin')
    for (i in which(df_cache$load == TRUE &
                    df_cache$instruction == 'spin')) {
      if (file.exists(df_cache$filename_md[i]) == FALSE) {
        df_cache$load[i] <- FALSE
      }
    }
    
    # check if order has changed and edit df_cache$load
    if (file.exists(".cache/df_cache.rds")) {
      df_cache_old <- readRDS(".cache/df_cache.rds")
      df_cache$row_names <- row.names(df_cache)
      df_cache_old$row_names <- row.names(df_cache_old)
      df_cache_both <- merge(
        x = df_cache,
        y = df_cache_old[, c("filename_in",
                             "row_names")],
        by = "filename_in",
        all.x = TRUE
      )
      df_cache_both <-
        df_cache_both[order(df_cache_both$row_names.x),]
      df_cache_both$pos_match <-
        as.numeric(df_cache_both$row_names.x) -
        as.numeric(df_cache_both$row_names.y)
      df_cache$load[which(df_cache_both$pos_match !=
                            0)] <- FALSE
    }
    
    # if a script should not be loaded all following scripts should be sourced or spinned
    if (any(df_cache$load == FALSE) == TRUE) {
      df_cache$load[min(which(df_cache$load == FALSE)):nrow(df_cache)] <-
        FALSE
    }
    
    if (use_cache == TRUE) {
      # change instruction according to df_cache$load
      df_cache$instruction[which(df_cache$load == TRUE)] <- 'load'
    }
    
    # delete all deprecated files in cache
    cache_files <- list.files(path = '.cache',
                              recursive = TRUE,
                              full.names = TRUE)
    cache_files <-
      cache_files[-grep(pattern = 'input_data', x = cache_files)]
    cache_files <-
      cache_files[-grep(pattern = 'df_cache', x = cache_files)]
    cache_files <-
      cache_files[-grep(pattern = 'figure/', x = cache_files)]
    
    cache_files_new <- c(
      df_cache$filename_image,
      df_cache$filename_mtime,
      df_cache$filename_Rmd,
      df_cache$filename_md,
      df_cache$filename_html
    )
    
    cache_files_del <-
      cache_files[!cache_files %in% cache_files_new]
    unlink(cache_files_del, recursive = TRUE)
    
    # delete deprecated md, Rmd, html (not spinned)
    
    cache_files_spin_keep <- c(df_cache$filename_Rmd[spin_index],
                               df_cache$filename_md[spin_index],
                               df_cache$filename_html[spin_index])
    
    cache_files_spin_all <-
      cache_files_new[-grep(pattern = 'RData|rds', x = cache_files_new)]
    del_cache_files_spin <-
      cache_files_spin_all[!cache_files_spin_all %in% cache_files_spin_keep]
    unlink(del_cache_files_spin, recursive = TRUE)
    
    # delete deprecated figures (not spinned)
    
    fig_dir <- list.dirs(path = '.cache/figure')
    fig_dir <- fig_dir[-which(fig_dir == '.cache/figure')]
    
    grep_index <-
      paste(df_cache$basename_in[spin_index], collapse = '|')
    fig_del <- fig_dir[-grep(pattern = grep_index, x = fig_dir)]
    
    unlink(fig_dir[fig_dir %in% fig_del], recursive = TRUE)
    
    if (length(spin_index) == 1 && spin_index == 0) {
      unlink('.cache/figure', recursive = TRUE)
    }
    
    # save info about data
    input_data <-
      sapply(X = list.files("in/data", full.names = TRUE,
                            recursive = TRUE),
             FUN = file.info)
    saveRDS(object = input_data, file = ".cache/input_data.rds")
    # save df_cache
    saveRDS(object = df_cache, file = ".cache/df_cache.rds")
    
    # delete out/auto and rebuild directories
    if (dir.exists('out/auto')) {
      unlink(x = 'out/auto', recursive = TRUE)
    }
    dir.create('out/auto/figure', recursive = TRUE)
    dir.create('out/auto/notebooks/website', recursive = TRUE)
    dir.create('out/auto/reports', recursive = TRUE)
    dir.create('out/auto/data', recursive = TRUE)
  }
