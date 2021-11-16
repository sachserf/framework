#' Create a framework-project skeleton
#'
#' @description The function creates a predefined directory structure and some
#'   files to enhance project organization. Among other things it is a wrapper
#'   for 'template_params'.
#' @inheritParams template_params
#' @return The output are several files and directories within your working
#'   directory.
#' @seealso \code{\link{project_framework}}
#' @author Frederik Sachser
#' @export
skeleton <-
  function(project_dir,
           input_files = c('load_data.R'),
           pkg_cran_install = c('utils', 'tools', 'rmarkdown', 'knitr', 'rstudioapi'),
           pkg_cran_load = c('tidyverse'),
           pkg_gh_install = NULL,
           pkg_gh_load = NULL,
           input_dir = 'files',
           data_dir = 'inst/extdata',
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
           target_dir_data = 'data',
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
    # specify framework_fun directory
    framework_fun <- file.path(fun_dir, "framework")

    #### create basic directories ####
    basic_dirs <-
      list(
        file.path(data_dir),
        file.path(input_dir),
        file.path(cache_dir),
        file.path(framework_fun),
        file.path(symlink_dir_input),
        file.path(symlink_dir_docs),
        file.path(symlink_dir_figure),
        file.path(target_dir_data),
        file.path(dirname(filepath_session_info)),
        file.path(dirname(filepath_log)),
        file.path(dirname(filepath_tree)),
        file.path(dirname(filepath_warnings))
      )
    basic_dirs <- basic_dirs[!basic_dirs %in% "character(0)"]
    lapply(X = basic_dirs,
           FUN = dir.create,
           recursive = TRUE,
           showWarnings = FALSE)

    invisible(lapply(X = list.files(system.file("templates", package = "framework"), full.names = TRUE), FUN = file.copy, to = framework_fun, recursive = TRUE))

    #### create make.R ####
    framework::template_make()
    #### create params.R ####
    framework::template_params(project_dir = project_dir,
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

    # write first logfile entry
    write_log(filepath_log = filepath_log, summarize_log = FALSE)

    #### write templates for source-files ####
    source_files <- file.path(input_dir, input_files)
    source_files_R <-
      source_files[which(tools::file_ext(source_files) == "R")]
    source_files_Rmd <-
      source_files[which(tools::file_ext(source_files) == "Rmd")]
    if (length(source_files_R) > 0) {
      lapply(X = source_files_R, FUN = template_rmd, open = FALSE)
    }
    if (length(source_files_Rmd) > 0) {
      lapply(X = source_files_Rmd, FUN = template_rmd, open = FALSE)
    }

    #### write README.md ####
    framework_version <- paste0(unlist(utils::packageVersion('framework')), collapse = ".")
    cat(
      '# Readme of the project: ',
      basename(getwd()),
      '\n\nThis project was created from **',
      Sys.info()['user'],
      '** at **',
      as.character(Sys.time()),
      '(using R-package `framework` v', framework_version, ', [framework@github](https://github.com/sachserf/framework))',

      '\n\n## Outline\nGive an outline of your project.\n\n## To Do\nList your ideas.\n\n## Decisions/milestones\nWrite log entries.\n\n',

      '# Brief usage of framework projects:
      1. write scripts (R, Rmd, Rnw)
      2. add file_path of scripts to params.R
      3. source(make.R")',
      file = 'README.md',
      sep = ''
    )

    #### write how-to-guide.md
    #    htg <- readLines(file.path(system.file(package = "framework"), "how_to_guide/README.md"))
    #    cat(htg, file = "README.md", sep = "\n", append = TRUE)
  }
