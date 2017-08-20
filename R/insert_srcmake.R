#' Insert source('make.R') to console
#'
#' This addin only works when using RStudio. Call this function as an addin to
#' print source("make.R") to console. Optionally it is possible to assign a custom
#' keybinding (see RStudio/Tools/Modify keyboard shortcuts... and search for
#' "Execute source('make.R')").
#' @author Frederik Sachser
#' @export
insert_srcmake_addin <- function() {
  filesWD <-
    list.files(path = getwd(),
               recursive = TRUE,
               full.names = TRUE)
  
  minusBA <- grep(pattern = "BACKUP", x = filesWD)
  
  if (length(minusBA) > 0) {
    filesWD <- filesWD[-minusBA]
  }
  
  themake <- filesWD[grep(pattern = "make.R", x = filesWD)]
  
  if (length(themake) != 1) {
    rstudioapi::sendToConsole(
      code = print("warning('make.R is not unique: Open manually.')"),
      execute = TRUE
    )
  } else {
    rstudioapi::sendToConsole(paste0("source('", themake, "')"), execute = FALSE)
  }
}
