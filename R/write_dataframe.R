#' write_dataframe
#' @description write_dataframe
#' @export
write_dataframe <- 
function(listofdf = "GlobalEnv", data_dir = "out/data", file_format = "csv") 
{
    data_dir <- file.path(data_dir)
    if (listofdf == "GlobalEnv") {
        listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == 
            TRUE))
    }
    if (dir.exists(data_dir) == FALSE) {
        dir.create(data_dir, recursive = TRUE)
    }
    if (file_format == "csv") {
        csv_fun <- function(objectname) {
            filename <- paste(file.path(data_dir, objectname), 
                "csv", sep = ".")
            utils::write.table(x = get(objectname), file = filename, 
                sep = ";", row.names = FALSE)
        }
        lapply(listofdf, FUN = csv_fun)
    }
    if (file_format == "rds") {
        rds_fun <- function(objectname) {
            filename <- paste(file.path(data_dir, objectname), 
                "rds", sep = ".")
            saveRDS(object = get(objectname), file = filename)
        }
        lapply(listofdf, FUN = rds_fun)
    }
    if (file_format == "RData") {
        RData_fun <- function(objectname) {
            filename <- paste(file.path(data_dir, objectname), 
                "RData", sep = ".")
            save(file = filename, list = objectname)
        }
        lapply(listofdf, FUN = RData_fun)
    }
}
