#' Initialize an RStudio-project
#' 
#' @description Creates an .Rproj-file within your current working directory.
#' @note It is not possible to overwrite an existing Rproj.
#' @author Frederik Sachser
#' @export
Rproj_init <- function(project_dir){
  projname <- unlist(strsplit(project_dir, split = '/'))[length(unlist(strsplit(project_dir, split = '/')))]
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
NumSpacesForTab: 4
      
RnwWeave: knitr
LaTeX: Default
        
AutoAppendNewline: Yes
        ')
sink()
}
}
