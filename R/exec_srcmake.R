#' Execute source('make.R')
#'
#' Call this function as an addin to source the file 'make.R'
#'
#' @export
srcmake_addin <- function() {
  filepath_make <-
    list.files(
      path = rstudioapi::getActiveProject(),
      pattern = "^make.R$",
      recursive = TRUE,
      all.files = TRUE
    )
  if (length(filepath_make) != 1) {
    stop("file make.R does not exist or is not unique within project directory")
  } else {
    rstudioapi::sendToConsole(paste0("source('", filepath_make, "')"), execute = TRUE)
  }
}