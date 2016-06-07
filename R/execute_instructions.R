execute_instructions <- 
  function (filename_df_cache = ".cache/df_cache.rds") 
  {
    df_cache <- readRDS(filename_df_cache)
    for (i in 1:nrow(df_cache)) {
      specify_instructions(filename_in = df_cache$filename_in[i], 
                           basename_in = df_cache$basename_in[i], filename_image = df_cache$filename_image[i], 
                           filename_mtime = df_cache$filename_mtime[i], filename_Rmd = df_cache$filename_Rmd[i], 
                           instruction = df_cache$instruction[i])
    }
    # wozu ist das folgende?? - kein unterschied soweit ob 
    # drin oder nicht
    #    files_rename <- c(basename(df_cache$filename_md), basename(df_cache$filename_html))
    #    files_rename <- files_rename[files_rename %in% list.files()]
    #    if (length(files_rename) > 0) {
    #        file.rename(from = files_rename, to = paste0(".cache/", 
    #            files_rename))
    #    }
    
    #    if (dir.exists("figure") == TRUE) {
    #        if (dir.exists(".cache/figure") == FALSE) {
    #            dir.create(".cache/figure")
    #        }
    #        fig_dir <- list.dirs("figure", recursive = TRUE)
    #        fig_dir <- fig_dir[-which(fig_dir == "figure")]
    #        deprecated_fig_dir <- fig_dir[dir.exists(paths = file.path(".cache", 
    #            fig_dir))]
    #        unlink(file.path(".cache", deprecated_fig_dir), recursive = TRUE)
    #        sapply(X = file.path(".cache", fig_dir), FUN = dir.create, 
    #            recursive = TRUE)
    #        file.copy(from = fig_dir, to = paste0(".cache/", fig_dir))
    #        filename_figures <- list.files(path = "figure", recursive = TRUE, 
    #            full.names = TRUE)
    #        file.copy(from = filename_figures, to = paste0(".cache/", 
    #            filename_figures))
    #        unlink("figure", recursive = TRUE)
    #    }
    
    #df_cache <- readRDS('.cache/df_cache.rds')
    new_figures <- df_cache$dirname_figure_in[dir.exists(df_cache$dirname_figure_in)]
    
    ### NEU
    #    nr_of_file <- grep(pattern = paste(new_figures, collapse = '|'), df_cache$dirname_figure_in)
    #    nr_figures <- paste0(dirname(new_figures), '/', nr_of_file, '_', basename(new_figures))
    #    file.rename(from = new_figures, to = nr_figures)
    #    new_figures <- nr_figures
    ###
    
    if(length(new_figures > 0)) {
      deprecated_fig <- gsub(pattern = 'in/src', replacement = '.cache/figure', x = new_figures)
      unlink(x = deprecated_fig, recursive = TRUE)
      figure_copy_from <- list.files(path = new_figures, recursive = TRUE, full.names = TRUE)
      figure_copy_to <- gsub(pattern = 'in/src', replacement = '.cache/figure', x = figure_copy_from) 
      lapply(X = file.path(dirname(figure_copy_to)), dir.create, recursive = TRUE, showWarnings = FALSE)
      file.copy(from = figure_copy_from, to = figure_copy_to)
      unlink(x = new_figures, recursive = TRUE)
    }
    
    # delete deprecated figures
    figure_keep <- df_cache$dirname_figure[which(df_cache$instruction_orig == 'render')]
    keep <- list.files(path = figure_keep, recursive = TRUE, include.dirs = TRUE, full.names = TRUE)
    da <- list.files('.cache/figure', recursive = TRUE, include.dirs = TRUE, full.names = TRUE)
    weg1 <- da[!da %in% keep]
    
    for (i in 1:length(weg1)) {
      if(length(grep(pattern = weg1[i], x = keep)) == 0) {
        unlink(weg1[i], recursive = TRUE)
      }
    }
    
    
    #fig_path <- list.dirs(path = '.cache/figure', recursive = TRUE, full.names = FALSE)
    #lapply(X = file.path('out/auto/figure/', fig_path), FUN = dir.create, recursive = TRUE, showWarnings = FALSE)
    
    all_figures_from <- list.files(path = '.cache/figure', recursive = TRUE, full.names = TRUE)
    
    
    
    
    
    #all_figures_to <- gsub(pattern = '.cache', replacement = 'out/auto', all_figures_from)
    all_figures_to <- gsub(pattern = '.cache/figure/', replacement = '', x = all_figures_from)
    
    
    ## zum scheitern verurteilt...viel zu kompliziert:
    #    split_elements <- strsplit(all_figures_to, split = "/")
    #    first_element <- lapply(split_elements, `[[`, 1)
    #    no_subdir <- grep(pattern = paste(paste0(df_cache$basename_in, '_files'), collapse = '|'), x = first_element)
    #    seq_along(all_figures_to)
    #####
    
    all_figures_to <- gsub(pattern = '/', replacement = '-', all_figures_to)
    all_figures_to <- gsub(pattern = '_files-figure', replacement = '', all_figures_to)
    #all_figures_to <- gsub(pattern = '_files-figure-latex', replacement = '', all_figures_to)
    #all_figures_to <- gsub(pattern = '_files-figure-html', replacement = '', all_figures_to)
    #all_figures_to <- gsub(pattern = '_files-figure-docx', replacement = '', all_figures_to)
    
    #    all_figures_to <- file.path('out/auto/figure', all_figures_to)
    
    ### NEU
    #    no_dir <- gsub(pattern = 'out/auto/figure/', replacement = '', x = all_figures_to)
    
    for (i in seq_along(df_cache$dirname_figure)) {
      nr_index <- grep(pattern = df_cache$dirname_figure[i], all_figures_from)
      all_figures_to[nr_index]
      nr_names <- paste0(as.character(i), '_', all_figures_to[nr_index])
      nr_names <- file.path('out/auto/figure', nr_names)
      file.copy(from = all_figures_from[nr_index], to = nr_names)
    }
    
    #for (i in seq_along(df_cache$basename_in)) {
    #  nrnr <- grep(pattern = paste(df_cache$basename_in[i], collapse = '|'), x = all_figures_to)
    #  ii <- as.character(i)
    #      nr_names <- gsub(pattern = all_figures_to[i], replacement = paste0(ii, '_', all_figures_to[i]), x = all_figures_to[i])
    #  nr_names <- gsub(pattern = df_cache$basename_in[i], replacement = df_cache$nr_basename[i], all_figures_to[nrnr])
    #  nr_names <- file.path('out/auto/figure', nr_names)
    #  file.copy(from = all_figures_from[nrnr], to = nr_names)
    #}
    ###    
    
    #    src_figure <- list.dirs('in/src', recursive = TRUE, full.names = TRUE)
    
    #    new_figure <- df_cache$dirname_figure_in[df_cache$dirname_figure_in %in% src_figure]
    #    fig_cache <- file.path('.cache/figure', basename(new_figure))
    #    dir.create(path = fig_cache, recursive = TRUE)
    #    file.copy(from = new_figure, to = fig_cache, overwrite = TRUE, recursive = TRUE)
    
    #new_figure
    
    # copy docs from in/src to docs/cache
    # df_cache <- readRDS('.cache/df_cache.rds')
    
    ####### delete spinned_R-files
    
    src_files <- list.files(path = "in/src",
                            recursive = TRUE, full.names = TRUE)
    #    del_md <- src_files[grep(pattern = '.md', x = src_files, fixed = TRUE)]
    #del_spinR <- src_files[grep(pattern = '.spin.R', x = src_files, fixed = TRUE)]
    #unlink(del_spinR, recursive = TRUE)
    
    ### kurz mal raus
    #last2 <- substr(src_files, (nchar(src_files)-1), nchar(src_files))
    #src_R <- grep(pattern = '.R', x = last2, fixed = TRUE)
    #last4 <- substr(src_files, (nchar(src_files)-3), nchar(src_files))
    #src_Rmd <- grep(pattern = '.Rmd', x = last4, fixed = TRUE)
    #src_Rnw <- grep(pattern = '.Rnw', x = last4, fixed = TRUE)
    ####
    
    file_info_src <- readRDS('.cache/file_info_src.rds')
    temp_files <- src_files[!src_files %in% row.names(file_info_src)]
    
    equally_named_files <- src_files[src_files %in% row.names(file_info_src)]
    new_rendered_files <- equally_named_files[!file.info(equally_named_files)$mtime %in% file_info_src$mtime]
    
    
    ####
    #src_files <- readRDS('.cache/file_info_src.rds')
    #src_files$mtime
    
    #src_files_current <- list.files(path = 'in/src', all.files = TRUE, recursive = TRUE, full.names = TRUE)
    #file_info_src_current <- file.info(src_files_current)
    #all.equal(src_files, file_info_src_current)
    
    ####
    
    
    #pdf_files <- list.files(path = 'in/src', pattern = '.pdf', recursive = TRUE, full.names = TRUE)
    #html_files <- list.files(path = 'in/src', pattern = '.html', recursive = TRUE, full.names = TRUE)
    #docx_files <- list.files(path = 'in/src', pattern = '.docx', recursive = TRUE, full.names = TRUE)
    #temp_and_reports <- c(temp_files, pdf_files, html_files, docx_files)
    
    temp_and_new_rendered <- c(temp_files, new_rendered_files)
    
    if (dir.exists('.cache/docs') == FALSE) {
      dir.create('.cache/docs')
    }
    
    # geht nicht innerhalb funktion
    #docs_cache_target <- gsub(pattern = 'in/src', replacement = '.cache/docs', x = temp_and_new_rendered)
    #lapply(X = unique(dirname(docs_cache_target)), FUN = dir.create, recursive = TRUE, showWarnings = FALSE)
    #file.copy(from = temp_and_new_rendered, to = docs_cache_target)
    #####
    file.copy(from = temp_and_new_rendered, to = '.cache/docs', recursive = TRUE)
    
    unlink(x = temp_and_new_rendered, recursive = TRUE)
    #unlink(src_files[-c(src_R, src_Rmd, src_Rnw)], recursive = TRUE)
    
    # delete deprecated docs
    cache_files <- list.files(path = '.cache/docs', full.names = TRUE, recursive = TRUE)
    keep_files <- grep(pattern = paste(paste0('.cache/docs/', df_cache$basename, '.', collapse = '|')), x = cache_files)
    deprecated_files <- cache_files[-keep_files]
    
    #deprecated_docs <- cache_files[!cache_files %in% c(df_cache$filename_html, df_cache$filename_nb, df_cache$filename_pdf, df_cache$filename_docx)]
    unlink(deprecated_files, recursive = TRUE)
    
    # delete pdf and html from src
    #pdf_src <- list.files(path = 'in/src', pattern = '.pdf', recursive = TRUE, full.names = TRUE)
    #html_src <- list.files(path = 'in/src', pattern = '.html', recursive = TRUE, full.names = TRUE)
    #unlink(c(pdf_src, html_src), recursive = TRUE)
    # copy docs from docs/cache to out/auto/docs
    
    if (dir.exists('out/auto/docs') == FALSE) {
      dir.create('out/auto/docs')
    }
    
    ### weiter
    #df_cache <- readRDS('.cache/df_cache.rds')
    
    #docs_cache <- list.files(path = '.cache/docs', recursive = TRUE, full.names = TRUE)
    #nr_index <- grep(pattern = paste0('.cache/docs/', 
    #                                  df_cache$basedirname[1], '.'), x = docs_cache)
    #basename(docs_cache)
    #docs_cache_basename <- basename(docs_cache)
    #paste0(as.character(1), '_', no_ext[nr_index])
    
    #for (i in seq_along(df_cache$basename)) {
    #  nr_index <- grep(pattern = grep(paste0('.cache/docs/', df_cache$basename[i])), docs_cache)
    #  all_figures_to[nr_index]
    #  nr_names <- paste0(as.character(i), '_', all_figures_to[nr_index])
    #  nr_names <- file.path('out/auto/figure', nr_names)
    #  file.copy(from = all_figures_from[nr_index], to = nr_names)
    #}
    
    # final output (pdf, html and docx)
    cache_files <- list.files(path = '.cache/docs', recursive = TRUE)
    cache_files <- cache_files[grep(pattern = '.html|.pdf|.docx', x = cache_files)]
    
    split_elements <- strsplit(cache_files, split = "[.]")
    first_element <- lapply(split_elements, `[[`, 1)
    
    grep(pattern = '.html|.pdf|.docx', x = cache_files)
    
    #df_cache <- readRDS('.cache/df_cache.rds')
    for (i in seq_along(df_cache$basename)) {
      nr_index <- grep(pattern = df_cache$basename[i], x = first_element)
      for_cache_files <- cache_files[nr_index]
      nr_basename_docs <- paste0(as.character(i), '_', for_cache_files)
      file.copy(from = file.path('.cache/docs/', for_cache_files), to = file.path('out/auto/docs', nr_basename_docs))
    }
    
    # temp output (md, spin.R etc)
    if (dir.exists('out/auto/docs/temp_files') == FALSE) {
      dir.create('out/auto/docs/temp_files', recursive = TRUE)
    }
    
    
    
    cache_files <- list.files(path = '.cache/docs', recursive = TRUE)
    cache_files <- cache_files[-grep(pattern = '.html|.pdf|.docx', x = cache_files)]
    
    split_elements <- strsplit(cache_files, split = "[.]")
    first_element <- lapply(split_elements, `[[`, 1)
    
    grep(pattern = '.html|.pdf|.docx', x = cache_files)
    
    #df_cache <- readRDS('.cache/df_cache.rds')
    for (i in seq_along(df_cache$basename)) {
      nr_index <- grep(pattern = df_cache$basename[i], x = first_element)
      for_cache_files <- cache_files[nr_index]
      nr_basename_docs <- paste0(as.character(i), '_', for_cache_files)
      file.copy(from = file.path('.cache/docs/', for_cache_files), to = file.path('out/auto/docs/temp_files', nr_basename_docs))
    }
    
    #    filename_spin_rmd_in <- list.files(path = "in/R", pattern = ".Rmd", 
    #        recursive = TRUE)
    #    file.copy(from = file.path("in/R", filename_spin_rmd_in), 
    #        to = file.path(".cache", filename_spin_rmd_in), overwrite = TRUE)
    #    file.remove(file.path("in/R", filename_spin_rmd_in))
    #    if (dir.exists(".cache/figure")) {
    #        fig_dir_cache <- list.dirs(path = ".cache/figure", recursive = TRUE, 
    #            full.names = FALSE)
    #        fig_dir_cache <- fig_dir_cache[-which(fig_dir_cache == 
    #            "")]
    #        fig_dir_out <- file.path("out/auto/figure", fig_dir_cache)
    #        sapply(X = fig_dir_out, FUN = dir.create, recursive = TRUE)
    #        fig_cache <- list.files(path = ".cache/figure", recursive = TRUE, 
    #            full.names = FALSE)
    #        file.copy(from = file.path(".cache/figure", fig_cache), 
    #            to = file.path("out/auto/figure", fig_cache))
    #    }
    
    #    html_cache <- list.files(path = ".cache", pattern = ".html", 
    #        full.names = TRUE)
    #    if (length(html_cache > 0)) {
    #        file.copy(from = html_cache, to = file.path("out/auto/notebooks", 
    #            basename(html_cache)))
    #    }
  }
