compile_or_copy_notebooks <- function(input_R,
                                      target_dir_html,
                                      target_dir_figures) {
  #### check if cache files exists ####
  if (any(
    file.exists(
      'cache/load_me.rds',
      'cache/source_me.rds',
      'cache/df_cache_R.rds'
    ) == FALSE
  ) == TRUE) {
    warning('cache files not found: call <<prepare_cache_R>> and retry.')
  } else {
    #### load cache files ####
    load_me <- readRDS('cache/load_me.rds')
    source_me <- readRDS('cache/source_me.rds')
    df_cache_R <- readRDS('cache/df_cache_R.rds')
    #### check if input files are a subset of sourced files ####
    if (any(is.na(match(
      input_R, df_cache_R$filename_full
    ))) == TRUE) {
      warning('Input files are not a subset of sourced files.')
    } else {
      #### match input and source ####
###      input_R <- c('input/R/drei.R', 'input/R/clean.R', 'input/R/test/atest.R')
      compile_me <-
        input_R[match(source_me, input_R)]
      compile_me <-
        compile_me[which(is.na(compile_me) == FALSE)]
      # check if there are files that are already sourced but not compiled, yet
      all_not_rendered <- df_cache_R$filename_full[which(file.exists(df_cache_R$notebooks_cache_html) == FALSE)]
      add_these <- df_cache_R$filename_full[all_not_rendered %in% input_R]
      compile_me <- unique(c(compile_me, add_these))
      ## compile me ergänzen falls datei die kopiert werden soll nicht vorhanden ist
      if (length(compile_me) != 0) {
        #### call ext fun 'compile_notebooks' ####
        framework::compile_notebooks(file_path = compile_me, target_dir = 'cache/notebooks')
      }
      
      #### delete deprecated files ####
      names_only <-
        substr(
          x = basename(input_R),
          start = 1,
          stop = nchar(basename(input_R)) - 2
        )
      
      # delete html
      all_html <-
        list.files(path = 'cache/notebooks',
                   pattern = '*.html',
                   full.names = TRUE)
      names_html <-
        paste0('cache/notebooks', '/', names_only, '.html')
      unlink(all_html[!all_html %in% names_html], recursive = TRUE)
      # delete Rmd
      all_Rmd <-
        list.files(path = 'cache/notebooks',
                   pattern = '*.Rmd',
                   full.names = TRUE)
      names_Rmd <-
        paste0('cache/notebooks', '/', names_only, '.Rmd')
      unlink(all_Rmd[!all_Rmd %in% names_Rmd], recursive = TRUE)
      
      #### delete deprecated figures ####
      # get list of figures in cache
      cache_figures <-
        list.files(
          path = 'cache/notebooks/figure',
          pattern = '*png',
          full.names = TRUE,
          recursive = TRUE
        )
      # split names (prepare to extract script_name)
      figures_split <-
        strsplit(basename(cache_figures), split = '-')
      # get the first element and extract script name
      cache_figures_names <-
        unlist(lapply(figures_split, `[[`, 1))
      # delete deprecated figures
      unlink(cache_figures[!cache_figures_names %in% df_cache_R$filename_no_ext], recursive = TRUE)

      #### prepare to copy html ####
      # specify html files in cache
      html_source <- df_cache_R$notebooks_cache_html
      # specify html target files
      html_target <-
        paste0(file.path(target_dir_html), '/', basename(html_source))
      # delete deprecated html files
      unlink(file.path(target_dir_html), recursive = TRUE)
      # create dir for target_dir_html
      dir.create(file.path(target_dir_html), recursive = TRUE)
      
      #### copy html ####
      file.copy(from = html_source, to = html_target)
      
      #### prepare to copy figures ####
      # delete deprecated figures
      unlink(file.path(target_dir_figures), recursive = TRUE)
      # create dir for target_dir_figures
      dir.create(file.path(target_dir_figures), recursive = TRUE)
      # check if there are any figures
      if (dir.exists('cache/notebooks/figure') == TRUE) {
        fig_source <-
          list.files('cache/notebooks/figure', full.names = TRUE)
        fig_target <-
          file.path(target_dir_figures,
                    list.files('cache/notebooks/figure'))
      }
      
      #### copy figures ####
      file.copy(from = fig_source,
                to = fig_target,
                overwrite = TRUE)
      
    }
  }
}
