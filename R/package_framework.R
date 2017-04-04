#' Initialize a framework-package
#' 
#' @description This function is an alias for project_framework but with different default values. The configuration is adapted for projects that can be build as an R package.
#' @inheritParams project_framework
#' @seealso \code{\link{Rproj_init}}, \code{\link{git_init}}, 
#'   \code{\link{skeleton}}, \code{\link{project_framework}}
#' @author Frederik Sachser
#' @export
package_framework <- function(project_dir,
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
                          source_dir = 'docs/in',
                          data_dir = 'inst/extdata',
                          target_dir_figure = 'inst/fig',
                          target_dir_docs = 'docs/out',
                          target_dir_data = 'data',
                          devtools_create = TRUE,
                          rename_figure = TRUE,
                          rename_docs = TRUE,
                          log_filepath = 'meta/log.csv',
                          session_info_filepath = 'meta/session_info.txt',
                          spin_index = 999,
                          cache_index = 999,
                          knitr_cache = FALSE) {
  framework::project_framework(project_dir = project_dir,
                               rstudio = rstudio,
                               init_git = init_git,
                               init_packrat = init_packrat,
                               custom_makeR = custom_makeR,
                               target_makeR = target_makeR,
                               fun_dir = fun_dir,
                               source_files = source_files,
                               cache_dir = cache_dir,
                               source_dir = source_dir,
                               data_dir = data_dir,
                               target_dir_figure = target_dir_figure,
                               target_dir_docs = target_dir_docs,
                               target_dir_data = target_dir_data,
                               devtools_create = devtools_create,
                               rename_figure = rename_figure,
                               rename_docs = rename_docs,
                               log_filepath = log_filepath,
                               session_info_filepath = session_info_filepath,
                               spin_index = spin_index,
                               cache_index = cache_index,
                               knitr_cache = knitr_cache)
}

