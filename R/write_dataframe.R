#' dsfrrgrdsghrr
#' 
#' @description aswgarsg swegrr
#' @author Frederik Sachser
#' @export
write_dataframe <- 
function (listofdf = "GlobalEnv", target_dir = "out/data/", file_format = "csv") 
{
    if (listofdf == "GlobalEnv") {
        listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == 
            TRUE))
    }
    if (dir.exists(target_dir) == FALSE) {
        dir.create(target_dir, recursive = TRUE)
    }
    if (file_format == "csv") {
        csv_fun <- function(objectname) {
            filename <- paste(file.path(target_dir, objectname), 
                "csv", sep = ".")
            write.table(get(objectname), filename, sep = ";", 
                row.names = FALSE)
        }
        lapply(listofdf, FUN = csv_fun)
    }
    if (file_format == "rds") {
        rds_fun <- function(objectname) {
            filename <- paste(file.path(target_dir, objectname), 
                "rds", sep = ".")
            saveRDS(object = get(objectname), file = filename)
        }
        lapply(listofdf, FUN = rds_fun)
    }
    if (file_format == "RData") {
        RData_fun <- function(objectname) {
            filename <- paste(file.path(target_dir, objectname), 
                "RData", sep = ".")
            save(file = filename, list = objectname)
        }
        lapply(listofdf, FUN = RData_fun)
    }
}
