#' write_dataframe
#' @description write_dataframe
#' @export
write_dataframe <-
  function(listofdf = "GlobalEnv",
           target_dir_data = "out/data",
           file_format = "csv",
           delete_target_dir = TRUE)
  {
    # specify input option
    if (listofdf == "GlobalEnv") {
      listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) ==
                                TRUE))
    }
    
    # target_dir_data = file path
    target_dir_data <- file.path(target_dir_data)
    
    # Check if source dir is part of target_dir
    if (grepl(pattern = target_dir_data, x = source_dir) == TRUE) {
      stop(
        "Source_dir should neither be equal nor a subdirectory of target directory! Change paths and retry."
      )
    }
    
    
    # delete target_dir_data
    if (delete_target_dir == TRUE) {
      unlink(target_dir_data, recursive = TRUE)
    }
    
    # create target_dir_data
    if (dir.exists(target_dir_data) == FALSE) {
      dir.create(target_dir_data, recursive = TRUE)
    }
    
    # write csv files
    if (file_format == "csv") {
      csv_fun <- function(objectname) {
        filename <- paste(file.path(target_dir_data, objectname),
                          "csv", sep = ".")
        utils::write.table(
          x = get(objectname),
          file = filename,
          sep = ";",
          row.names = FALSE
        )
      }
      lapply(listofdf, FUN = csv_fun)
    }
    
    # write rds files
    if (file_format == "rds") {
      rds_fun <- function(objectname) {
        filename <- paste(file.path(target_dir_data, objectname),
                          "rds", sep = ".")
        saveRDS(object = get(objectname), file = filename)
      }
      lapply(listofdf, FUN = rds_fun)
    }
    
    # write RData files
    if (file_format == "RData") {
      RData_fun <- function(objectname) {
        filename <- paste(file.path(target_dir_data, objectname),
                          "RData", sep = ".")
        save(file = filename, list = objectname)
      }
      lapply(listofdf, FUN = RData_fun)
    }
  }
