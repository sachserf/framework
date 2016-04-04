project_framework <- function(dirname = paste(getwd(), format(Sys.time(), format(Sys.time(), format="%Y%m%d-%A-%H%M%S")), sep = "/")) {
  if(dir.exists(dirname) == FALSE) dir.create(dirname, recursive = TRUE)
  setwd(dirname)  
  framework::Rproj_init()
  framework::git_init()
  framework::project_skeleton()
}
