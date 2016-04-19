Rproj_init <- function(){
  dirname <- getwd()
  projname <- unlist(strsplit(dirname, split = '/'))[length(unlist(strsplit(dirname, split = '/')))]
  if(file.exists(paste(projname, '.Rproj', sep = '')) == TRUE) {
    print('project already exists')
  } else {
    sink(paste0(projname, '.Rproj'))
    cat('Version: 1.0
        
RestoreWorkspace: Default
SaveWorkspace: Default
AlwaysSaveHistory: Default
        
EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8
      
RnwWeave: knitr
LaTeX: XeLaTex
        
AutoAppendNewline: Yes
        ')
sink()
}
}