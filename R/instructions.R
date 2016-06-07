instructions <- 
  function (input_R, spin_index = 0, cache_index = 0) 
  {
    # specify input
    if (length(cache_index) == 1 && cache_index == "all") {
      cache_index <- 1:length(input_R)
    }
    if (length(spin_index) == 1 && spin_index == "all") {
      spin_index <- 1:length(input_R)
    }
    # delete cache
    if (length(cache_index) == 1 && cache_index == 0) {
      unlink(x = ".cache", recursive = TRUE)
    }
    if (dir.exists(".cache") == FALSE) {
      dir.create(".cache")
    }
    # write file info of in/src
    src_files <- list.files(path = 'in/src', all.files = TRUE, recursive = TRUE, full.names = TRUE)
    file_info_src <- file.info(src_files)
    saveRDS(object = file_info_src, file = '.cache/file_info_src.rds')
    
    # check if data changed
    if (file.exists(".cache/input_data.rds") == TRUE && 
        sum(cache_index) > 0) {
      input_data_current <- sapply(X = list.files("in/data", 
                                                  full.names = TRUE, recursive = TRUE), FUN = file.info)
      input_data_source <- readRDS(file = ".cache/input_data.rds")
      if (isTRUE(all.equal(target = input_data_source, current = input_data_current)) == 
          FALSE) {
        stop("files in directory <<in/data>> changed - use option <<cache_index = FALSE>> and retry.")
      }
    }
    
    #################################################################  
    filename_in <- paste0(input_R)
    # start
    Rmd_index <- grep(pattern = '.Rmd', filename_in)
    
    if (length(Rmd_index > 0)) {
      filename_in[Rmd_index] <- substr(x = filename_in[Rmd_index], 
                                       start = 1, 
                                       stop = nchar(filename_in[Rmd_index])-2)
      
    }
    # stop
    
    basename_in <- gsub(pattern = ".R", replacement = "", x = basename(filename_in))
    basename_in <- gsub(pattern = ".R", replacement = "", x = basename(filename_in))
    
    basedirname <- paste0(dirname(filename_in), '/', basename_in)
    basedirname <- gsub(pattern = 'in/src/', replacement = '', basedirname)
    
    # test
    nr_basename <- paste0(seq_along(basename_in), '_', basename_in)
    filename_image <- paste0(".cache/", basename_in, "_image.RData")
    filename_mtime <- paste0(".cache/", basename_in, "_mtime.rds")
    filename_Rmd <- paste0(".cache/", basename_in, ".Rmd")
    filename_md <- paste0(".cache/", basename_in, ".md")
    filename_html <- paste0(".cache/docs/", basename_in, ".html")
    filename_nb <- paste0(".cache/docs/", basename_in, ".nb.html")
    filename_pdf <- paste0(".cache/docs/", basename_in, ".pdf")
    filename_docx <- paste0(".cache/docs/", basename_in, ".docx")
    dirname_figure_in <- paste0(dirname(filename_in), '/', basename_in, '_files')
    dirname_figure <- paste0(".cache/figure/", dirname_figure_in)
    dirname_figure <- gsub(pattern = 'in/src/', replacement = '', x = dirname_figure, fixed = TRUE)
    mtime_current <- file.mtime(input_R)
    df_cache <- data.frame(filename_in, basename_in, nr_basename,
                           filename_image, basedirname, 
                           filename_mtime, filename_Rmd, filename_md, 
                           filename_html, filename_nb, filename_pdf,
                           filename_docx, 
                           dirname_figure, dirname_figure_in,
                           mtime_current, stringsAsFactors = FALSE)
    df_cache$instruction <- "source"
    df_cache$instruction[spin_index] <- "render"
    
    # start
    df_cache$instruction[Rmd_index] <- 'render'
    df_cache$filename_in[Rmd_index] <- paste0(input_R[Rmd_index])
    
    #    df_cache <- readRDS('.cache/df_cache.rds')
    #    df_cache[which(df_cache$instruction == 'load'), c('filename_html', 'filename_nb', 'filename_pdf')]
    
    
    ######## TEST temporär raus und schauen, ob besser
    #### delete deprecated pdf and html from cache
    cache_files <- list.files(path = '.cache/docs', recursive = FALSE, full.names = TRUE)
    
    keep_files <- grep(pattern = paste(paste0('.cache/docs/', df_cache$basename[which(df_cache$instruction == 'render')], '.', collapse = '|')), x = cache_files)
    deprecated_output <- cache_files[-keep_files]
    
    #pdf_files <- cache_files[grep(pattern = '.pdf', x = cache_files)]
    #html_files <- cache_files[grep(pattern = '.html', x = cache_files)]
    #potential_output <- unlist(df_cache[which(df_cache$instruction == 'render'), c('filename_html', 'filename_nb', 'filename_pdf')])
    #all_out_cache <- c(pdf_files, html_files)
    #deprecated_output <- all_out_cache[!all_out_cache %in% potential_output]
    unlink(deprecated_output)
    
    df_cache$instruction_orig <- df_cache$instruction
    
    
    #############################################
    filename_image_pre <- list.files(path = ".cache", pattern = "*_image.RData", 
                                     recursive = TRUE, full.names = TRUE)
    image_del <- filename_image_pre[!filename_image_pre %in% 
                                      df_cache$filename_image]
    unlink(image_del, recursive = TRUE)
    df_cache$file_exist_mtime <- file.exists(df_cache$filename_mtime)
    df_cache$mtime_read <- as.POSIXct(x = "1970-01-02")
    add_mtime_read <- function(row_id) {
      x <- readRDS(df_cache$filename_mtime[row_id])
      df_cache$mtime_read[row_id] <<- x
    }
    file_exist_index <- as.integer(which(df_cache$file_exist_mtime == 
                                           TRUE))
    lapply(X = file_exist_index, FUN = add_mtime_read)
    df_cache$mtime_read <- as.POSIXct(df_cache$mtime_read)
    df_cache$file_exist_mtime <- NULL
    df_cache$difftime <- as.integer(df_cache$mtime_current) - 
      as.integer(df_cache$mtime_read)
    df_cache$load <- FALSE
    # start
    # exclude load by cache_index
    df_cache$use_cache <- FALSE
    df_cache$use_cache <- 1:nrow(df_cache) %in% cache_index
    #   df_cache$load[which(df_cache$use_cache == FALSE)] <- FALSE
    
    df_cache$load[which(df_cache$difftime == 0 & df_cache$use_cache == TRUE)] <- TRUE
    # stop
    if (any(df_cache$difftime != 0) == TRUE) {
      df_cache$load[min(which(df_cache$difftime != 0)):nrow(df_cache)] <- FALSE
    }
    for (i in which(df_cache$load == TRUE)) {
      if (file.exists(df_cache$filename_image[i]) == FALSE) {
        df_cache$load[i] <- FALSE
      }
    }
    
    cache_files <- list.files(path = '.cache/docs', full.names = TRUE, recursive = TRUE)
    # render again if files not exist 
    for (i in which(df_cache$instruction_orig == 'render')) {
      check_file_exist <- length(grep(pattern = paste(paste0('.cache/docs/', df_cache$basename[i], '.', collapse = '|')), x = cache_files))
      if (check_file_exist == 0) {
        df_cache$load[i] <- FALSE
      }
    }
    #    for (i in which(df_cache$load == TRUE & df_cache$instruction == 
    #        "spin")) {
    #        if (file.exists(df_cache$filename_md[i]) == FALSE) {
    #            df_cache$load[i] <- FALSE
    #        }
    #    }
    if (file.exists(".cache/df_cache.rds")) {
      df_cache_old <- readRDS(".cache/df_cache.rds")
      df_cache$row_names <- row.names(df_cache)
      df_cache_old$row_names <- row.names(df_cache_old)
      df_cache_both <- merge(x = df_cache, y = df_cache_old[, 
                                                            c("filename_in", "row_names")], by = "filename_in", 
                             all.x = TRUE)
      df_cache_both <- df_cache_both[order(df_cache_both$row_names.x), 
                                     ]
      df_cache_both$pos_match <- as.numeric(df_cache_both$row_names.x) - 
        as.numeric(df_cache_both$row_names.y)
      df_cache$load[which(df_cache_both$pos_match != 0)] <- FALSE
    }
    if (any(df_cache$load == FALSE) == TRUE) {
      df_cache$load[min(which(df_cache$load == FALSE)):nrow(df_cache)] <- FALSE
    }
    
    
    
    
    
    if (sum(cache_index) > 0) {
      df_cache$instruction[which(df_cache$load == TRUE)] <- "load"
    }
    
    ##### löschen der Dateien, die nicht in aktuellen instructions stehen:    
    
    #cache_files <- list.files(path = ".cache", recursive = TRUE, 
    #    full.names = TRUE)
    #cache_files <- cache_files[-grep(pattern = "input_data.rds", 
    #    x = cache_files)]
    #cache_files <- cache_files[-grep(pattern = "file_info_src.rds", 
    #                                 x = cache_files)]
    #cache_files <- cache_files[-grep(pattern = "df_cache", x = cache_files)]
    #cache_files <- cache_files[-grep(pattern = "figure/", x = cache_files)]
    #    df_cache <- readRDS('.cache/df_cache.rds')
    #    cache_files_new <- c(df_cache$filename_image, df_cache$filename_mtime,
    #                         df_cache$filename_pdf, df_cache$filename_html, 
    #                         df_cache$filename_nb)
    
    #render_docs <- df_cache[which(df_cache$instruction_orig == 'render'),c('filename_pdf', 'filename_html', 'filename_nb')]
    #cache_files_keep <- c(unlist(render_docs), df_cache$filename_image, df_cache$filename_mtime)
    #cache_files_del <- cache_files[!cache_files %in% cache_files_keep]
    #    cache_files_del <- cache_files[!cache_files %in% cache_files_new]
    #unlink(cache_files_del, recursive = TRUE)
    #    cache_files_spin_keep <- c(df_cache$filename_Rmd[spin_index], 
    #        df_cache$filename_md[spin_index], df_cache$filename_html[spin_index])
    #    cache_files_spin_all <- cache_files_new[-grep(pattern = "RData|rds", 
    #        x = cache_files_new)]
    #    del_cache_files_spin <- cache_files_spin_all[!cache_files_spin_all %in% 
    #        cache_files_spin_keep]
    #    unlink(del_cache_files_spin, recursive = TRUE)
    #    fig_dir <- list.dirs(path = ".cache/figure")
    #    fig_dir <- fig_dir[-which(fig_dir == ".cache/figure")]
    #    grep_index <- paste(df_cache$basename_in[spin_index], collapse = "|")
    #    fig_del <- fig_dir[-grep(pattern = grep_index, x = fig_dir)]
    #    unlink(fig_dir[fig_dir %in% fig_del], recursive = TRUE)
    #    if (length(spin_index) == 1 && spin_index == 0) {
    #        unlink(".cache/figure", recursive = TRUE)
    #    }
    input_data <- sapply(X = list.files("in/data", full.names = TRUE, 
                                        recursive = TRUE), FUN = file.info)
    saveRDS(object = input_data, file = ".cache/input_data.rds")
    saveRDS(object = df_cache, file = ".cache/df_cache.rds")
    if (dir.exists("out/auto")) {
      unlink(x = "out/auto", recursive = TRUE)
    }
    dir.create("out/auto/figure", recursive = TRUE)
    #dir.create("out/auto/notebooks/website", recursive = TRUE)
    #dir.create("out/auto/reports", recursive = TRUE)
    dir.create("out/auto/data", recursive = TRUE)
  }
