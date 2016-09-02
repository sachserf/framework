#' write_dataframe
#' @description write all dataframes
#' @export
write_dataframe <- 
  function(listofdf = "GlobalEnv", target_dir_data = "out/data", file_format = "csv") 
  {
    target_dir_data <- file.path(target_dir_data)
    if (listofdf == "GlobalEnv") {
      listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == 
                                TRUE))
    }
    if (dir.exists(target_dir_data) == FALSE) {
      dir.create(target_dir_data, recursive = TRUE)
    }
    if (file_format == "csv") {
      csv_fun <- function(objectname) {
        filename <- paste(file.path(target_dir_data, objectname), 
                          "csv", sep = ".")
        utils::write.table(x = get(objectname), file = filename, 
                           sep = ";", row.names = FALSE)
      }
      lapply(listofdf, FUN = csv_fun)
    }
    if (file_format == "rds") {
      rds_fun <- function(objectname) {
        filename <- paste(file.path(target_dir_data, objectname), 
                          "rds", sep = ".")
        saveRDS(object = get(objectname), file = filename)
      }
      lapply(listofdf, FUN = rds_fun)
    }
    if (file_format == "RData") {
      RData_fun <- function(objectname) {
        filename <- paste(file.path(target_dir_data, objectname), 
                          "RData", sep = ".")
        save(file = filename, list = objectname)
      }
      lapply(listofdf, FUN = RData_fun)
    }
  }
