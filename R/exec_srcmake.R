#' Execute source('make.R')
#'
#' This addin only works when using RStudio. Call this function as an addin to
#' source the file 'make.R'. Optionally it is possible to assign a custom
#' keybinding (see RStudio/Tools/Modify keyboard shortcuts... and search for
#' "Execute source('make.R')").
#' @author Frederik Sachser
#' @export
srcmake_addin <- function() {
  filesWD <-
    list.files(path = getwd(),
               recursive = TRUE,
               full.names = TRUE)
  
  minusBA <- grep(pattern = "BACKUP", x = filesWD)
  
  if (length(minusBA) > 0) {
    filesWD <- filesWD[-minusBA]
  }
  
  themake <- filesWD[basename(filesWD) %in% "make.R"]
  
  if (length(themake) != 1) {
    rstudioapi::sendToConsole(
      code = stop("Cannot locate file 'make.R'. Open manually."),
      execute = TRUE
    )
  } else {
    rstudioapi::sendToConsole(paste0("source('", themake, "')"), execute = TRUE)
  }
  
}