project_framework <- function(dirname, init_Rproj = TRUE, init_git = TRUE, init_packrat = FALSE) {
  if(dir.exists(dirname) == FALSE) dir.create(dirname, recursive = TRUE)
  setwd(dirname)  
  framework::project_skeleton()
  if (init_Rproj == TRUE) framework::Rproj_init()
  if (init_packrat == TRUE) {
    if ('packrat' %in% rownames(installed.packages()) == FALSE) {
      install.packages('packrat')
    }
    packrat::init(dirname)
  }
  if (init_git == TRUE) framework::git_init()
}
