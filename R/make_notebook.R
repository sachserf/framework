make_notebook <-
  function(input_R,
           target_dir_html,
           target_dir_figures) {
    if (input_R == '') {
      message('Did not compile any notebook.')
    } else if (input_R == 'all') {
      input_R <- readRDS('cache/df_cache_R.rds')$filename_full
    }
    if (file.exists('cache/use_cache.rds') == TRUE &&
        readRDS('cache/use_cache.rds') == TRUE) {
      framework::compile_or_copy_notebooks(
        input_R = input_R,
        target_dir_html = target_dir_html,
        target_dir_figures = target_dir_figures
      )
    } else {
      framework::compile_notebooks(
        file_path = input_R,
        target_dir = target_dir_html,
        figure_output = target_dir_figures
      )
    }
  }
