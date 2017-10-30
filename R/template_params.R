#' Write params to file
#' 
#' @description Aside from scripts for analysis each framework project contain 
#'   two important files: 'make.R' and 'params.R'. All parameters should be 
#'   specified in params.R. These values will be passed to make.R
#' @param project_dir Character. File path to your project top level.
#' @param input_files character vector. File paths to your input files. Should
#'   be found within the directory 'input dir'. Use file extension 'R' or 'Rmd'.
#' @param pkg_cran_install Character vector. Package names that should be
#'   installed from your default cran mirror.
#' @param pkg_cran_load Character vector. Package names that should be installed
#'   from your default cran mirror and additionally loaded.
#' @param pkg_gh_install Character vector. Package names that should be
#'   installed from github. Depends on the package 'devtools'.
#' @param pkg_gh_load Character vector. Package names that should be installed
#'   from github and additionally loaded. Depends on the package 'devtools'.
#' @param input_dir Character. Source directory for your input_files.
#' @param data_dir Character. Source directory for raw data. This directory will
#'   be monitored. When files change in this directory the cache will be ignored
#'   (when using the framework template of the file 'make.R').
#' @param cache_dir Character. Directory for the cache.
#' @param fun_dir Character. Directory for user-written functions. When using
#'   the framework template of the file 'make.R' all R-Scripts (functions)
#'   within this directory will be attached to a predefined environment.
#' @param spin_index Integer vector. Subset of input_files that should be
#'   spinned. Files extensions other than '.R' will be ignored. (0 = none, 999 =
#'   all)
#' @param cache_index Integer vector. Subset of input_files that should be
#'   cached. (0 = none, 999 = all)
#' @param symlink_dir_input Character. Target directory for symbolic links to
#'   input_files. Should betreated as read-only.
#' @param symlink_dir_docs Character. Target directory for symbolic links to
#'   rendered files. Should betreated as read-only.
#' @param symlink_dir_figure Character. Target directory for symbolic links to
#'   rendered figures. Should betreated as read-only.
#' @param rename_symlink_input Logical. Preserve directory structure and
#'   filename or collapse directories and rename symbolic links.
#' @param rename_symlink_docs Logical. Preserve directory structure and filename
#'   or collapse directories and rename symbolic links.
#' @param rename_symlink_figure Logical. Preserve directory structure and
#'   filename or collapse directories and rename symbolic links.
#' @param rebuild_figures Logical. Delete figures before rendering. Choose FALSE
#'   if you want to use knitr::cache.
#' @param Rplots_device Character. Function that should be passed to write
#'   figures of R-files if sourced. E.g. 'grDevices::pdf' or 'grDevices::png'. Choose NULL if you want to write figures manually (e.g. using ggsave for ggplot2-graphics).
#' @param filepath_pkg_bib Character. Target filepath to write bib-file of packages. See ?knitr::write_bib()
#' @param filepath_image Character. Target filepath to write final image.
#' @inheritParams autosnapshot
#' @inheritParams write_dataframe
#' @inheritParams write_session_info
#' @inheritParams write_log
#' @inheritParams write_tree
#' @inheritParams write_warnings
#' @param quiet_processing Logical. Specify if processing of files should be
#'   quiet.
#' @param summarize_memory Logical. Should memory usage be printed to console?
#' @param summarize_git Logical. If TRUE git2r::summary() will be called.
#' @seealso \code{\link{template_make}}, \code{\link[knitr]{write_bib}}
#' @author Frederik Sachser
#' @return A file named 'params.R'.
#' @export
template_params <- function(project_dir,
                            input_files = c('prepare.R', 'visualize.Rmd'),
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
  if (file.exists('params.R')) {
    stop("File params.R exists. Choose another target directory and retry.")
  } else {
    cat(text = "#' # Specify parameters for make.R\n#' # INPUT (required)\ntoplvl = '", basename(project_dir),"'\ninput_files = ", paste0('c(\'', paste(input_files, collapse = '\',\''), '\')'), "\npkg_cran_install = ", ifelse(is.null(pkg_cran_install), deparse(pkg_cran_install), paste0('c(\'', paste(pkg_cran_install, collapse = '\',\''), '\')')),"\npkg_cran_load = ", ifelse(is.null(pkg_cran_load), deparse(pkg_cran_load), paste0('c(\'', paste(pkg_cran_load, collapse = '\',\''), '\')')),"\npkg_gh_install = ", ifelse(is.null(pkg_gh_install), deparse(pkg_gh_install), paste0('c(\'', paste(pkg_gh_install, collapse = '\',\''), '\')')),"\npkg_gh_load = ", ifelse(is.null(pkg_gh_load), deparse(pkg_gh_load), paste0('c(\'', paste(pkg_gh_load, collapse = '\',\''), '\')')),"\nif (system('git --version') == 0) {\n  pkg_cran_load = c(pkg_cran_load, 'git2r')\n}\ninput_dir = '", input_dir,"'\ndata_dir = '",data_dir,"'\ncache_dir = '",cache_dir,"'\nfun_dir = '",fun_dir,"'\nspin_index = ",spin_index,"\ncache_index = ",cache_index,"\n#' -------------------\n#' # OUTPUT (optional)\nsymlink_dir_input = ", ifelse(is.null(symlink_dir_input), deparse(symlink_dir_input), paste0('\'', symlink_dir_input, '\'')),"\nsymlink_dir_docs = ", ifelse(is.null(symlink_dir_docs), deparse(symlink_dir_docs), paste0('\'', symlink_dir_docs, '\'')),"\nsymlink_dir_figure = ", ifelse(is.null(symlink_dir_figure), deparse(symlink_dir_figure), paste0('\'', symlink_dir_figure, '\'')),"\nrename_symlink_input = ", rename_symlink_input,"\nrename_symlink_docs = ", rename_symlink_docs,"\nrename_symlink_figure = ", rename_symlink_figure,"\nrebuild_figures = ", rebuild_figures,"\nRplots_device = ", eval(Rplots_device),"\n\ntarget_dir_data = ", ifelse(is.null(target_dir_data), deparse(target_dir_data), paste0('\'', target_dir_data, '\'')),"\nlistofdf = '", listofdf,"'\ndata_extension = ", ifelse(is.null(data_extension), deparse(data_extension), paste0('\'', data_extension, '\'')),"\nrebuild_target_dir_data = ", rebuild_target_dir_data,"\nfilepath_session_info = ", ifelse(is.null(filepath_session_info), deparse(filepath_session_info), paste0('\'', filepath_session_info, '\'')),"\nfilepath_log = ", ifelse(is.null(filepath_log), deparse(filepath_log), paste0('\'', filepath_log, '\'')),"\nfilepath_tree = ", ifelse(is.null(filepath_tree), deparse(filepath_tree), paste0('\'', filepath_tree, '\'')),"\nfilepath_warnings = ", ifelse(is.null(filepath_warnings), deparse(filepath_warnings), paste0('\'', filepath_warnings, '\'')),"\ntree_directory = ", ifelse(is.null(tree_directory), deparse(tree_directory), ifelse(tree_directory == 'getwd()', eval(tree_directory), paste0('\'', tree_directory, '\''))),"\ninclude_hidden_tree = ", include_hidden_tree,"\nfilepath_pkg_bib = ", ifelse(is.null(filepath_pkg_bib), deparse(filepath_pkg_bib), paste0('\'', filepath_pkg_bib, '\'')),"\nfilepath_image = ", ifelse(is.null(filepath_image), deparse(filepath_image), paste0('\'', filepath_image, '\'')),"\nautobranch = ", ifelse(is.null(autobranch), deparse(autobranch), paste0('\'', autobranch, '\'')), "\n\nquiet_processing = ", quiet_processing,"\nsummarize_session_info = ", summarize_session_info,"\nsummarize_df = ", summarize_df,"\nsummarize_memory = ", summarize_memory,"\nsummarize_log = ", summarize_log,"\nsummarize_git = ", summarize_git,"\nsummarize_tree = ", summarize_tree,"\nsummarize_warnings = ", summarize_warnings, "\n",
sep = "",
file = 'params.R')
  }
}
