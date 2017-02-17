#' Initialize a framework-project
#' 
#' @description This function is probably the only function of the whole package
#'   'framework' you need to call by hand. It is a wrapper for skeleton, 
#'   Rproj_init and git_init. Therefore it is straightforward to create a new 
#'   project, change the working directory, generate basic directories/files and
#'   initialize a git repository. Optionally you can initialize a packrat repo.
#' @param project_dir Character. Specify the path to the directory where you 
#'   want to create a new project. The last directory will be the project 
#'   directory itself. The name of the project will be the name of the project 
#'   directory. E.g. '~/Desktop/MyProject' will create a project directory on 
#'   your desktop.
#' @param rstudio Logical. TRUE calls the function Rproj_init.
#' @param init_git Logical. TRUE calls the function git_init.
#' @param init_packrat Logical. TRUE initializes a packrat repo.
#' @param custom_makeR Character. File path to a local make-like R-file. Specify
#'   this option if you want to use a customized version instead of the template
#'   for the file 'make.R'.
#' @param target_makeR Character. Target directory of the 'makefile'. Default is
#'   'make.R'. Specify relative file path if you want to use subdirectories.
#' @param fun_dir Character. Target directory of functions. Default is 'I-fun'. 
#'   Some functions of the framework-package will be copied to a subdirectory of
#'   this folder. By using the framework template of the file 'make.R' all 
#'   R-Scripts (functions) within this directory will be attached to a 
#'   predefined environment.
#' @param source_files Character. Specify a vector of file paths, if you want to
#'   create predefined templates for your analysis (relative to 'source_dir'). 
#'   Use file extensions '.R' or '.Rmd'.
#' @param cache_dir Character. Specify file path for the cache directory.
#' @param source_dir Character. Specify file path to directory where you want to
#'   store all your input files.
#' @param data_dir Character. Specify file path to directory where you want to 
#'   store your data files. This directory will be monitored. When files change 
#'   in this directory the cache will be ignored (when using the framework 
#'   template of the file 'make.R').
#' @param target_dir_figure Character. Treat this directory as read-only. By 
#'   using the function 'framework::instructions()' the directory will contain 
#'   rendered plots that are specified within your input scripts.
#' @param target_dir_docs Character. Treat this directory as read-only. By using
#'   the function 'framework::instructions()' the directory will contain 
#'   rendered documents (pdf, html, ...) of your input scripts.
#' @param target_dir_data Character. Treat this directory as read-only. By using
#'   the function 'framework::write_dataframe()' the directory will contain data
#'   of type 'RData', 'rds' or 'csv'.
#' @param log_filepath Character. Specify relative file path (inlcuding the
#'   extension .csv) to write a log-file.
#' @param devtools_create Logical. Choose TRUE if you want to call 
#'   'devtools::create()' in order to prepare your project as an R-package. You 
#'   might want to choose appropriate paths for other variables (e.g. fun_dir = 
#'   'R', data_dir = inst/extdata, and so on).
#' @param rename_figure Logical. If TRUE the rendered figures will be renamed 
#'   and moved into a single directory.
#' @param rename_docs Logical. If TRUE the rendered documents (html, pdf, docx) 
#'   will be renamed and moved into a single directory.
#' @param spin_index Integer. Can be of length one or a vector. Specify index of
#'   'source_files' that should  be spinned (ignored for file extension 'Rmd'). 
#'   Choose 0 (zero) if you do not want to spin any R-files. Choose 999 if you 
#'   want to spin all R-files.
#' @param cache_index Integer. Can be of length one or a vector. Specify index 
#'   of 'source_files' that should  be integrated into the cache. Choose 0 
#'   (zero) if you do not want to use the cache. Choose 999 if you want to use 
#'   the cache for all files.
#' @param knitr_cache Logical. If you want to use the package 'knitr' to cache 
#'   chunks of a file you should additionally specify knitr_cache = TRUE within 
#'   the function 'instructions'. By choosing this option it is not possible to 
#'   use a different target for your figures (target_dir_figure = NULL).
#' @note Creation of the project_dir is recursive.
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
           source_files = c('prepare.Rmd',
                            'visualize.Rmd',
                            'analyze.Rmd',
                            'report.Rmd'),
           cache_dir = '.cache',
           source_dir = 'scripts',
           data_dir = 'data',
           target_dir_figure = 'out/fig',
           target_dir_docs = 'out/docs',
           target_dir_data = 'out/data',
           devtools_create = FALSE,
           rename_figure = TRUE,
           rename_docs = TRUE,
           log_filepath = 'log.csv',
           spin_index = 999,
           cache_index = 999,
           knitr_cache = FALSE) {
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
      target_dir_data,
      rename_figure,
      rename_docs,
      log_filepath,
      spin_index,
      cache_index,
      knitr_cache
    )
    
    # initialize git
    if (init_git == TRUE) {
      cat(".Rproj.user", ".Rhistory", ".RData", data_dir, target_dir_figure, target_dir_data, target_dir_docs, file = ".gitignore", sep = "\n")
      cat(log_filepath, "merge=union", file = ".gitattributes")
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

