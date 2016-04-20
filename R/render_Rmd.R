render_Rmd <- function(source_dir_or_files = 'input/documents', target_dir = 'output/documents') {
  if(file.info(source_dir)$isdir == TRUE) {
    all_files <- list.files(path = source_dir, pattern = '.Rmd',
                            recursive = TRUE,
                            full.names = TRUE,
                            ignore.case = TRUE)
  }
  lapply(X = all_files,
         FUN = rmarkdown::render,
         output_dir = target_dir,
         quiet = TRUE,
         output_format = 'all',
         envir = .GlobalEnv)
}


