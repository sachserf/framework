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
           target_makeR = 'make.R',
           fun_dir = 'R',
           source_files = c('load.R',
                            'report.Rmd'),
           cache_dir = '.cache',
           source_dir = 'scripts',
           data_dir = 'data/raw',
           target_dir_figure = 'figures',
           target_dir_docs = 'docs',
           target_dir_data = 'data/processed',
           devtools_create = TRUE) {
    # create project directory
    if (dir.exists(project_dir) == TRUE) {
      stop("Project directory exists. Choose a different path and retry")
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
    
    # initialize git
    if (init_git == TRUE) {
      cat(".Rproj.user", ".Rhistory", ".RData", data_dir, target_dir_figure, target_dir_data, target_dir_docs, file = ".gitignore", sep = "\n")
      framework::git_init()
    }
    
    # initialize packrat
    if (init_packrat == TRUE) {
      if ('packrat' %in% rownames(utils::installed.packages()) == FALSE) {
        utils::install.packages('packrat')
      }
      packrat::init(project_dir)
    }

    # edit Rbuildignore and DESCRIPTION
    if (file.exists(".Rbuildignore")) {
      lapply(X = c(file.path(fun_dir, "framework"), cache_dir, target_dir_figure, target_dir_data, target_dir_docs, "session_info.txt", "how-to-guide.md", target_makeR, source_dir, data_dir), FUN = function(thedir) if (is.null(thedir) == FALSE) cat(thedir, file = ".Rbuildignore", append = TRUE, sep = "\n"))
    }

    if (file.exists("DESCRIPTION")) {
      cat("Suggests:", "    rmarkdown (>= 0.9.6),", "    knitr", file = "DESCRIPTION", append = TRUE, sep = "\n")
    }
    
  }

