#' Insert source('make.R') to console
#'
#' This addin only works when using RStudio. Call this function as an addin to
#' print source("make.R") to console. Optionally it is possible to assign a custom 
#' keybinding (see RStudio/Tools/Modify keyboard shortcuts... and search for 
#' "Execute source('make.R')").
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

