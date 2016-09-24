#' Initialize an RStudio-project
#' 
#' @description Creates an .Rproj-file within your current working directory.
#' @inheritParams project_framework
#' @note It is not possible to overwrite an existing Rproj.
#' @author Frederik Sachser
#' @export
Rproj_init <- function(project_dir){
  projname <- unlist(strsplit(project_dir, split = '/'))[length(unlist(strsplit(project_dir, split = '/')))]
  if (file.exists(paste(projname, '.Rproj', sep = '')) == TRUE) {
    stop('project already exists')
  } else {
    sink(paste0(projname, '.Rproj'))
    cat("Version: 1.0

RestoreWorkspace: No
SaveWorkspace: No
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
Encoding: UTF-8

AutoAppendNewline: Yes
StripTrailingWhitespace: Yes

BuildType: Package
PackageUseDevtools: Yes
PackageInstallArgs: --no-multiarch --with-keep.source
PackageRoxygenize: rd,collate,namespace")
sink()
}
}
