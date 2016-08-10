#' Initialize a framework-project
#' 
#' @description This function is the heart of the package framework and it is 
#'   probably the only one you need to call by hand. Furthermore it is a wrapper
#'   for skeleton, Rproj_init and git_init. Therefore it is straightforward to 
#'   create a new project, change the working directory, generate basic
#'   directories and initialize a git repository. Optionally you can initialize
#'   a packrat repo.
#' @param dirname Character. Specify the path to the directory where you want to
#'   create a new project. The last directory will be the project directory 
#'   itself. The name of the project will be the name of the project directory. 
#'   E.g. '~/Desktop/MyProject' will create a project directory on your desktop.
#' @param init_Rproj Logical. TRUE calls the function Rproj_init.
#' @param init_git Logical. TRUE calls the function git_init.
#' @param init_packrat Logical. TRUE initializes a packrat repo.
#' @note Creation of the dirname is recursive.
#' @note After calling the function go to the project directory and open the 
#'   .Rproj file with RStudio.
#' @seealso \code{\link{Rproj_init}}, \code{\link{git_init}}, 
#'   \code{\link{skeleton}}
#' @author Frederik Sachser
#' @export
project_framework <- function(dirname, init_Rproj = TRUE, init_git = TRUE, init_packrat = FALSE) {
  if (dir.exists(dirname) == FALSE) dir.create(dirname, recursive = TRUE)
  setwd(dirname)  
  framework::skeleton()
  if (init_Rproj == TRUE) framework::Rproj_init()
  if (init_packrat == TRUE) {
    if ('packrat' %in% rownames(utils::installed.packages()) == FALSE) {
      utils::install.packages('packrat')
    }
    packrat::init(dirname)
  }
  if (init_git == TRUE) framework::git_init()
}
