#' Initialize a framework-project
#'
#' @description This function is the heart of the package framework and it is
#'   probably the only one you need to call by hand. Furthermore it is a wrapper
#'   for skeleton, Rproj_init and git_init. Therefore it is straightforward to
#'   create a new project, change the working directory, generate basic
#'   directories and initialize a git repository. Optionally you can initialize
#'   a packrat repo.
#' @param project_dir Character. Specify the path to the directory where you want to
#'   create a new project. The last directory will be the project directory
#'   itself. The name of the project will be the name of the project directory.
#'   E.g. '~/Desktop/MyProject' will create a project directory on your desktop.
#' @param init_Rproj Logical. TRUE calls the function Rproj_init.
#' @param init_git Logical. TRUE calls the function git_init.
#' @param init_packrat Logical. TRUE initializes a packrat repo.
#' @param custom_makeR Character. File path to a local make-like R-file. Specify
#'   this option if you want to use a customized version instead of the template
#'   for the file 'make.R'.
#' @note Creation of the project_dir is recursive.
#' @note After calling the function go to the project directory and open the
#'   .Rproj file with RStudio.
#' @seealso \code{\link{Rproj_init}}, \code{\link{git_init}},
#'   \code{\link{skeleton}}
#' @author Frederik Sachser
#' @export
project_framework <-
  function(project_dir,
           rstudio = TRUE,
           init_git = TRUE,
           init_packrat = FALSE,
           custom_makeR = NULL,
           target_makeR = 'analysis/make.R',
           fun_dir = 'R',
           source_files = c('scripts/load.R',
                            'report.Rmd'),
           cache_dir = '.cache',
           source_dir = 'analysis',
           data_dir = 'data',
           target_dir_figure = 'out/figure',
           target_dir_docs = 'out/docs',
           target_dir_data = 'out/data',
           devtools_create = TRUE) {
    # create project directory
    if (dir.exists(project_dir) == TRUE) {
      stop("Project directory exists. Choose a differnet path and retry")
    } else {
      dir.create(project_dir, recursive = TRUE)
    }
    # set working directory
    setwd(project_dir)
    # create R-project
    if ('devtools' %in% utils::installed.packages() == TRUE &
        devtools_create == TRUE) {
      devtools::create(path = project_dir)
    } else if (rstudio == TRUE) {
      framework::Rproj_init(project_dir)
#      devtools::use_rstudio(pkg = file.path(project_dir))
    }
    # create skeleton for a framework project
    framework::skeleton(
      custom_makeR,
      target_makeR,
      fun_dir,
      source_files,
      cache_dir,
      source_dir,
      data_dir,
      target_dir_figure,
      target_dir_docs,
      target_dir_data
    )
    # initialize packrat
    if (init_packrat == TRUE) {
      if ('packrat' %in% rownames(utils::installed.packages()) == FALSE) {
        utils::install.packages('packrat')
      }
      packrat::init(project_dir)
    }
    # initialize git
    if (init_git == TRUE) {
      framework::git_init()
    }
  }
