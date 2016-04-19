project_framework <- function(dirname, init_Rproj = TRUE, init_git = TRUE, init_packrat = FALSE) {
  if(dir.exists(dirname) == FALSE) dir.create(dirname, recursive = TRUE)
  setwd(dirname)  
  framework::project_skeleton()
  if (init_Rproj == TRUE) framework::Rproj_init()
  # create pkg_install-function
  if(file.exists("input/functions/sachserf_framework/pkg_install.R") == FALSE){
    framework::dput_function(pkg_fun = framework::pkg_install, 
                             target_dir = 'input/functions/sachserf/framework', 
                             substitute_framework = TRUE)
  } else {
    warning("pkg_install (function) already exists")
  }
  if (init_packrat == TRUE) {
    if ('packrat' %in% rownames(installed.packages()) == FALSE) {
      install.packages('packrat')
    }
    packrat::init(dirname)
  }
  if (init_git == TRUE) framework::git_init()
}
