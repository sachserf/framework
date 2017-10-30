#' Initialize a framework-project
#'
#' @description This function is probably the only function of the whole package
#'   'framework' you need to call by hand. It is a wrapper for skeleton,
#'   Rproj_init and git_init. Therefore it is straightforward to create a new
#'   project, change the working directory, generate basic directories/files and
#'   initialize a git repository. Optionally you can initialize a packrat repo.
#' @inheritParams template_params
#' @param rstudio Logical. TRUE calls the function Rproj_init.
#' @param init_git Logical. TRUE calls the function git_init.
#' @param init_packrat Logical. TRUE initializes a packrat repo.
#' @param devtools_create Logical. Choose TRUE if you want to call
#'   'devtools::create()' in order to prepare your project as an R-package. You
#'   might want to choose appropriate paths for other variables (e.g. fun_dir =
#'   'R', data_dir = inst/extdata, and so on). See alias 'package
#' @param project_dir Character. Specify the path to the directory where you
#'   want to create a new project. The last directory will be the top level of the project and additionally the name of your project. E.g. '~/Desktop/MyProject' will create a project called 'MyProject'.
#' @note Creation of the project_dir is recursive.
#' @seealso \code{\link{skeleton}}, \code{\link{package}}
#' @author Frederik Sachser
#' @export
project_framework <-
  function(project_dir,
           devtools_create = FALSE,
           rstudio = TRUE,
           init_git = TRUE,
           init_packrat = FALSE,
           input_files = c('prepare.R', 'visualize.Rmd'),
           pkg_cran_install = c('utils', 'tools', 'rmarkdown', 'knitr', 'rstudioapi'),
           pkg_cran_load = c('tidyverse'),
           pkg_gh_install = NULL,
           pkg_gh_load = NULL,
           input_dir = 'files',
           data_dir = 'data/in',
           cache_dir = '.cache',
           fun_dir = 'R',
           spin_index = 0,
           cache_index = 999,
           symlink_dir_input = 'in',
           symlink_dir_docs = 'out/docs',
           symlink_dir_figure = 'out',
           rename_symlink_input = TRUE,
           rename_symlink_docs = TRUE,
           rename_symlink_figure = TRUE,
           rebuild_figures = TRUE,
           Rplots_device = 'grDevices::png',
           target_dir_data = 'data/out',
           listofdf = 'GlobalEnv',
           data_extension = 'RData',
           rebuild_target_dir_data = TRUE,
           filepath_session_info = 'meta/session_info.txt',
           filepath_log = 'meta/log.csv',
           filepath_tree = 'meta/tree.txt',
           filepath_warnings = 'meta/warnings.Rout',
           tree_directory = 'getwd()',
           include_hidden_tree = FALSE,
           filepath_pkg_bib = 'meta/pkg.bib',
           filepath_image = '.RData',
           autobranch = NULL,
           quiet_processing = TRUE,
           summarize_session_info = FALSE,
           summarize_df = FALSE,
           summarize_memory = FALSE,
           summarize_log = FALSE,
           summarize_git = TRUE,
           summarize_tree = FALSE,
           summarize_warnings = FALSE) {
    # create project directory
    if (dir.exists(project_dir) == TRUE) {
      stop("Project directory exists. Choose a different path and retry")
    } else {
      dir.create(project_dir, recursive = TRUE)
    }
    # set working directory
    setwd(project_dir)
    # create R-project
    if ('devtools' %in% utils::installed.packages() &&
        devtools_create == TRUE) {
      devtools::create(path = project_dir, rstudio = TRUE)
    } else if (rstudio == TRUE) {
      framework::Rproj_init(project_dir)
    }

    # create skeleton for a framework project
    framework::skeleton(
      project_dir = project_dir,
      input_files = input_files,
      pkg_cran_install = pkg_cran_install,
      pkg_cran_load = pkg_cran_load,
      pkg_gh_install = pkg_gh_install,
      pkg_gh_load = pkg_gh_load,
      input_dir = input_dir,
      data_dir = data_dir,
      cache_dir = cache_dir,
      fun_dir = fun_dir,
      spin_index = spin_index,
      cache_index = cache_index,
      symlink_dir_input = symlink_dir_input,
      symlink_dir_docs = symlink_dir_docs,
      symlink_dir_figure = symlink_dir_figure,
      rename_symlink_input = rename_symlink_input,
      rename_symlink_docs = rename_symlink_docs,
      rename_symlink_figure = rename_symlink_figure,
      rebuild_figures = rebuild_figures,
      Rplots_device = Rplots_device,
      target_dir_data = target_dir_data,
      listofdf = listofdf,
      data_extension = data_extension,
      rebuild_target_dir_data = rebuild_target_dir_data,
      filepath_session_info = filepath_session_info,
      filepath_log = filepath_log,
      filepath_tree = filepath_tree,
      filepath_warnings = filepath_warnings,
      tree_directory = tree_directory,
      include_hidden_tree = include_hidden_tree,
      filepath_pkg_bib = filepath_pkg_bib,
      filepath_image = filepath_image,
      autobranch = autobranch,
      quiet_processing = quiet_processing,
      summarize_session_info = summarize_session_info,
      summarize_df = summarize_df,
      summarize_memory = summarize_memory,
      summarize_log = summarize_log,
      summarize_git = summarize_git,
      summarize_tree = summarize_tree,
      summarize_warnings = summarize_warnings)

    # initialize git
    if (init_git == TRUE) {
      if (system('git --version') != 0) {
        warning("Cannot locate git on your machine.")
      } else if (file.exists('.git')) {
        warning(".git already exists.")
      } else {
        framework::git_init()
        cat(
          ".Rproj.user",
          ".Rhistory",
          ".RData",
          "*.pdf",
          "*.html",
          "*.docx",
          data_dir,
          symlink_dir_figure,
          symlink_dir_input,
          symlink_dir_docs,
          target_dir_data,
          data_dir,
          file = ".gitignore",
          sep = "\n"
        )
        cat(filepath_log, "merge=union", file = ".gitattributes")
      }
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
      lapply(X = c(file.path(fun_dir, "framework"), cache_dir, input_dir, symlink_dir_input, symlink_dir_docs, data_dir, symlink_dir_figure, filepath_session_info, filepath_log, filepath_tree, filepath_warnings, filepath_pkg_bib), FUN = function(thedir) if (!is.null(thedir)) cat(thedir, file = ".Rbuildignore", append = TRUE, sep = "\n")) 
    }
  }

