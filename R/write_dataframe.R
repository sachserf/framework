write_dataframe <- function(listofdf = 'GlobalEnv', output_dir =  'standard', file_format = 'rds') {
  if(listofdf == 'GlobalEnv') {
    listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == TRUE))
  }
  if(output_dir == 'standard') {
    output_dir <- file.path(getwd(), '/data/output/')
  }
  if(dir.exists(output_dir) == FALSE) {
    dir.create(output_dir, recursive = TRUE)
  }
  if(file_format == 'csv') {
    csv_fun <- function(...){
      data_path <- file.path(output_dir, ...)
      data_path_extension <- paste(data_path, '.csv', sep = '')
      write.table(get(...), data_path_extension, sep=";", row.names = FALSE)
    }
    lapply(X = listofdf, FUN = csv_fun)
  }
  if(file_format == 'rds') {
    rds_fun <- function(...){
      data_path <- file.path(output_dir, ...)
      data_path_extension <- paste(data_path, '.rds', sep = '')
      saveRDS(object = get(...), file = data_path_extension)
    }
    lapply(X = listofdf, FUN = rds_fun)
  }
}
