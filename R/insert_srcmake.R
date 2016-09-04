#' Insert source('make.R') to console
#'
#' Call this function as an addin to print source("make.R") to console. 

#'
#' @export
insert_srcmake_addin <- function() {
  filepath_make <-
    list.files(
      path = rstudioapi::getActiveProject(),
      pattern = "^make.R$",
      recursive = TRUE,
      all.files = TRUE,
      full.names = TRUE
    )
  
  if (length(filepath_make) != 1) {
    stop("file make.R does not exist or is not unique within project directory")
  } else {
    rstudioapi::sendToConsole(paste0("source('", filepath_make, "')"), execute = FALSE)
  }
}

