execute_instructions <-
  function (filename_df_cache = ".cache/df_cache.rds")
  {
    df_cache <- readRDS(filename_df_cache)
    for (i in 1:nrow(df_cache)) {
      specify_instructions(
        filename_in = df_cache$filename_in[i],
        basename_in = df_cache$basename_in[i],
        filename_image = df_cache$filename_image[i],
        filename_mtime = df_cache$filename_mtime[i],
        filename_Rmd = df_cache$filename_Rmd[i],
        instruction = df_cache$instruction[i],
        filename_dot = df_cache$filename_dot[i]
      )
    }
    new_figures <-
      df_cache$dirname_figure_in[dir.exists(df_cache$dirname_figure_in)]
    
    if (length(new_figures > 0)) {
      deprecated_fig <-
        gsub(pattern = 'in/src',
             replacement = '.cache/figure',
             x = new_figures)
      unlink(x = deprecated_fig, recursive = TRUE)
      figure_copy_from <-
        list.files(path = new_figures,
                   recursive = TRUE,
                   full.names = TRUE)
      figure_copy_to <-
        gsub(pattern = 'in/src',
             replacement = '.cache/figure',
             x = figure_copy_from)
      lapply(
        X = file.path(dirname(figure_copy_to)),
        dir.create,
        recursive = TRUE,
        showWarnings = FALSE
      )
      file.copy(from = figure_copy_from, to = figure_copy_to)
      unlink(x = new_figures, recursive = TRUE)
    }
    
    # delete deprecated figures
    figure_keep <-
      df_cache$dirname_figure[which(df_cache$instruction_orig == 'render')]
    keep <-
      list.files(
        path = figure_keep,
        recursive = TRUE,
        include.dirs = TRUE,
        full.names = TRUE
      )
    da <-
      list.files(
        '.cache/figure',
        recursive = TRUE,
        include.dirs = TRUE,
        full.names = TRUE
      )
    weg1 <- da[!da %in% keep]
    if (length(weg1) > 0) {
      for (i in 1:length(weg1)) {
        if (length(grep(pattern = weg1[i], x = keep)) == 0) {
          unlink(weg1[i], recursive = TRUE)
        }
      }
    }
    all_figures_from <-
      list.files(path = '.cache/figure',
                 recursive = TRUE,
                 full.names = TRUE)
    all_figures_to <-
      gsub(pattern = '.cache/figure/',
           replacement = '',
           x = all_figures_from)
    all_figures_to <-
      gsub(pattern = '/', replacement = '-', all_figures_to)
    all_figures_to <-
      gsub(pattern = '_files-figure', replacement = '', all_figures_to)
    
    for (i in seq_along(df_cache$dirname_figure)) {
      nr_index <-
        grep(pattern = df_cache$dirname_figure[i], all_figures_from)
      all_figures_to[nr_index]
      nr_names <-
        paste0(as.character(i), '_', all_figures_to[nr_index])
      nr_names <- file.path('out/figure', nr_names)
      file.copy(from = all_figures_from[nr_index], to = nr_names)
    }
    
    ####### delete spinned_R-files
    
    src_files <- list.files(path = "in/src",
                            recursive = TRUE,
                            full.names = TRUE)
    
    file_info_src <- readRDS('.cache/file_info_src.rds')
    temp_files <-
      src_files[!src_files %in% row.names(file_info_src)]
    
    equally_named_files <-
      src_files[src_files %in% row.names(file_info_src)]
    new_rendered_files <-
      equally_named_files[!file.info(equally_named_files)$mtime %in% file_info_src$mtime]
    
    temp_and_new_rendered <- c(temp_files, new_rendered_files)
    
    if (dir.exists('.cache/docs') == FALSE) {
      dir.create('.cache/docs')
    }
    
    file.copy(from = temp_and_new_rendered,
              to = '.cache/docs',
              recursive = TRUE)
    
    unlink(x = temp_and_new_rendered, recursive = TRUE)
    
    # delete deprecated docs
    cache_files <-
      list.files(path = '.cache/docs',
                 full.names = TRUE,
                 recursive = TRUE)
    keep_files <-
      grep(pattern = paste(
        paste0('.cache/docs/', df_cache$basename, '.', collapse = '|')
      ), x = cache_files)
    deprecated_files <- cache_files[-keep_files]
    unlink(deprecated_files, recursive = TRUE)
    
    if (dir.exists('out/docs') == FALSE) {
      dir.create('out/docs')
    }
    
    # final output (pdf, html and docx)
    cache_files <-
      list.files(path = '.cache/docs', recursive = TRUE)
    cache_files <-
      cache_files[grep(pattern = '.html|.pdf|.docx', x = cache_files)]
    
    split_elements <- strsplit(cache_files, split = "[.]")
    first_element <- lapply(split_elements, `[[`, 1)
    
    grep(pattern = '.html|.pdf|.docx', x = cache_files)
    
    for (i in seq_along(df_cache$basename)) {
      nr_index <- grep(pattern = df_cache$basename[i], x = first_element)
      for_cache_files <- cache_files[nr_index]
      nr_basename_docs <-
        paste0(as.character(i), '_', for_cache_files)
      file.copy(
        from = file.path('.cache/docs/', for_cache_files),
        to = file.path('out/docs', nr_basename_docs)
      )
    }
    
    # temp output (md, spin.R etc)
    if (dir.exists('out/docs/temp_files') == FALSE) {
      dir.create('out/docs/temp_files', recursive = TRUE)
    }
    
    cache_files <-
      list.files(path = '.cache/docs', recursive = TRUE)
    cache_files <-
      cache_files[-grep(pattern = '.html|.pdf|.docx', x = cache_files)]
    
    split_elements <- strsplit(cache_files, split = "[.]")
    first_element <- lapply(split_elements, `[[`, 1)
    
    grep(pattern = '.html|.pdf|.docx', x = cache_files)
    
    for (i in seq_along(df_cache$basename)) {
      nr_index <- grep(pattern = df_cache$basename[i], x = first_element)
      for_cache_files <- cache_files[nr_index]
      nr_basename_docs <-
        paste0(as.character(i), '_', for_cache_files)
      file.copy(
        from = file.path('.cache/docs/', for_cache_files),
        to = file.path('out/docs/temp_files', nr_basename_docs)
      )
    }
  }
