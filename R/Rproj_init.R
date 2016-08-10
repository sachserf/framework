#' Initialize an RStudio-project
#' 
#' @description Creates an .Rproj-file within your current working directory.
#' @note It is not possible to overwrite an existing Rproj.
#' @author Frederik Sachser
#' @export
Rproj_init <- function(){
  dirname <- getwd()
  projname <- unlist(strsplit(dirname, split = '/'))[length(unlist(strsplit(dirname, split = '/')))]
  if (file.exists(paste(projname, '.Rproj', sep = '')) == TRUE) {
    stop('project already exists')
  } else {
    sink(paste0(projname, '.Rproj'))
    cat('Version: 1.0
        
RestoreWorkspace: Default
SaveWorkspace: Default
AlwaysSaveHistory: Default
        
EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: native.enc
      
RnwWeave: knitr
LaTeX: XeLaTex
        
AutoAppendNewline: Yes
        ')
sink()
}
}