prepare_website <- function() {
  # copy files - prepare directory
  if (dir.exists('.cache/website') == TRUE) {
    unlink('.cache/website', recursive = TRUE)
  }
  dir.create('.cache/website')
  filename_Rmd <- list.files(path = '.cache', pattern = '.Rmd', full.names = TRUE)
  
  filename_Rmd_website <- file.path(dirname(filename_Rmd), 'website', basename(filename_Rmd))
  file.copy(from = filename_Rmd, to = filename_Rmd_website)
  # write index
  write_index_Rmd()
  # write yaml
  write_yaml()
}
