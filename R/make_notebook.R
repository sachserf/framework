make_notebook <-
  function (input_R = readRDS('.cache/df_cache_R.rds')$filename_full,
            target_dir_html = 'out/auto/documents/notebooks',
            target_dir_figures = 'out/auto/figures/notebooks')
  {
    if (any(
      file.exists(
        ".cache/load_me.rds",
        ".cache/source_me.rds",
        ".cache/df_cache_R.rds"
      ) == FALSE
    ) == TRUE) {
      warning("cache files not found: call <<prepare_cache_R>> and retry.")
    }
    else {
      load_me <- readRDS(".cache/load_me.rds")
      source_me <- readRDS(".cache/source_me.rds")
      df_cache_R <- readRDS(".cache/df_cache_R.rds")
      if (any(is.na(match(input_R, df_cache_R$filename_full))) ==
          TRUE) {
        warning("Input files are not a subset of sourced files.")
      }
      else {
        compile_me <- input_R[match(source_me, input_R)]
        compile_me <- compile_me[which(is.na(compile_me) ==
                                         FALSE)]
        all_not_rendered <-
          df_cache_R$filename_full[which(file.exists(df_cache_R$notebooks_cache_html) ==
                                           FALSE)]
        add_these <-
          df_cache_R$filename_full[all_not_rendered %in%
                                     input_R]
        compile_me <- unique(c(compile_me, add_these))
        if (length(compile_me) != 0) {
          framework::compile_notebooks(file_path = compile_me,
                                      target_dir = ".cache/notebooks")
        }
        names_only <- substr(
          x = basename(input_R),
          start = 1,
          stop = nchar(basename(input_R)) - 2
        )
        all_html <- list.files(path = ".cache/notebooks",
                               pattern = "*.html",
                               full.names = TRUE)
        names_html <-
          paste0(".cache/notebooks", "/", names_only,
                 ".html")
        unlink(all_html[!all_html %in% names_html], recursive = TRUE)
        all_Rmd <-
          list.files(path = ".cache/notebooks",
                     pattern = "*.Rmd",
                     full.names = TRUE)
        names_Rmd <- paste0(".cache/notebooks", "/", names_only,
                            ".Rmd")
        unlink(all_Rmd[!all_Rmd %in% names_Rmd], recursive = TRUE)
        cache_figures <-
          list.files(
            path = ".cache/notebooks/figure",
            pattern = "*png",
            full.names = TRUE,
            recursive = TRUE
          )
        figures_split <- strsplit(basename(cache_figures),
                                  split = "-")
        cache_figures_names <- unlist(lapply(figures_split,
                                             `[[`, 1))
        unlink(cache_figures[!cache_figures_names %in% df_cache_R$filename_no_ext],
               recursive = TRUE)
        html_source <- df_cache_R$notebooks_cache_html
        html_target <- paste0(file.path(target_dir_html),
                              "/", basename(html_source))
        unlink(file.path(target_dir_html), recursive = TRUE)
        dir.create(file.path(target_dir_html), recursive = TRUE)
        file.copy(from = html_source, to = html_target)
        unlink(file.path(target_dir_figures), recursive = TRUE)
        dir.create(file.path(target_dir_figures), recursive = TRUE)
        if (dir.exists(".cache/notebooks/figure") == TRUE) {
          fig_source <- list.files(".cache/notebooks/figure",
                                   full.names = TRUE)
          fig_target <-
            file.path(target_dir_figures,
                      list.files(".cache/notebooks/figure"))
          file.copy(from = fig_source,
                    to = fig_target,
                    overwrite = TRUE)
        }
        
      }
    }
  }
