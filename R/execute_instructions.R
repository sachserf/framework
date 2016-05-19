execute_instructions <- function(filename_df_cache = '.cache/df_cache.rds') {
  df_cache <- readRDS(filename_df_cache)
  # execute instruction
  for (i in 1:nrow(df_cache)) {
    specify_instructions(filename_in = df_cache$filename_in[i], 
                        basename_in = df_cache$basename_in[i],
                        filename_image = df_cache$filename_image[i], 
                        filename_mtime = df_cache$filename_mtime[i], 
                        filename_Rmd = df_cache$filename_Rmd[i], 
                        instruction = df_cache$instruction[i])
  }
  # move spinned files from top-level to cache
  files_rename <- c(basename(df_cache$filename_md),
                    basename(df_cache$filename_html)
  )
  
  files_rename <- files_rename[files_rename %in% list.files()]
  
  if (length(files_rename) > 0) {
    file.rename(from =  files_rename, to = paste0('.cache/', files_rename))
  }
  
  # move spinned figures from top-level to cache
  
  if(dir.exists('figure') == TRUE) {
    if(dir.exists('.cache/figure') == FALSE) {
      dir.create ('.cache/figure')
    }
    fig_dir <- list.dirs('figure', recursive = TRUE)
    fig_dir <- fig_dir[-which(fig_dir == 'figure')]
    deprecated_fig_dir <- fig_dir[dir.exists(paths = file.path('.cache', fig_dir))]
    unlink(file.path('.cache', deprecated_fig_dir), recursive = TRUE)
    sapply(X = file.path('.cache', fig_dir), FUN = dir.create, recursive = TRUE)
    file.copy(from = fig_dir, to = paste0('.cache/', fig_dir))
    filename_figures <- list.files(path = 'figure', 
                                   recursive = TRUE, 
                                   full.names = TRUE)
    file.copy(from =  filename_figures, to = paste0('.cache/', filename_figures))
    unlink('figure', recursive = TRUE)
  }
  
  # move spinned Rmd from in/R to cache
  filename_spin_rmd_in <- list.files(path = 'in/R', pattern = '.Rmd', recursive = TRUE)
  file.copy(from = file.path('in/R', filename_spin_rmd_in), to = file.path('.cache', filename_spin_rmd_in), overwrite = TRUE)
  file.remove(file.path('in/R', filename_spin_rmd_in))
  
  # copy figures to out/auto
  if (dir.exists('.cache/figure')) {
    fig_dir_cache <- list.dirs(path = '.cache/figure', recursive = TRUE, full.names = FALSE)
    fig_dir_cache <- fig_dir_cache[-which(fig_dir_cache == '')]
    fig_dir_out <- file.path('out/auto/figure', fig_dir_cache)
    sapply(X = fig_dir_out, FUN = dir.create, recursive = TRUE)
    fig_cache <- list.files(path = '.cache/figure', recursive = TRUE, full.names = FALSE)
    file.copy(from = file.path('.cache/figure', fig_cache), to = file.path('out/auto/figure', fig_cache))
  }
  
  # copy notebooks-html to out/auto
  html_cache <- list.files(path = '.cache', pattern = '.html', full.names = TRUE)
  if (length(html_cache > 0)) {
    file.copy(from = html_cache, to = file.path('out/auto/notebooks', basename(html_cache)))
  }
}
