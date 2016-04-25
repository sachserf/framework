prepare_website_dir <- function(source_dir_Rmd = ".cache/notebooks", target_dir_web = ".cache/website") {
  source_dir_Rmd_figure <- file.path(source_dir_Rmd, 'figure')
  target_dir_web_figure <- file.path(target_dir_web, 'figure')
  
  if (dir.exists(target_dir_web) == TRUE) {
    unlink(target_dir_web, recursive = TRUE)
  }
  dir.create(target_dir_web_figure, recursive = TRUE)
  source_rmd <-
    list.files(path = source_dir_Rmd,
               pattern = ".Rmd",
               full.names = TRUE)
  target_rmd <-
    file.path(target_dir_web,
              list.files(path = source_dir_Rmd,
                         pattern = ".Rmd"))
  file.copy(from = source_rmd, to = target_rmd)
  if (dir.exists(source_dir_Rmd_figure)) {
    file.copy(from = source_dir_Rmd_figure,
              to = target_dir_web,
              recursive = TRUE)
  }
}
