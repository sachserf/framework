#' Template for a make-like file
#' 
#' @description This function will create a template for a make-like file. It is
#'   possible to specify a predefined set of parameters.
#' @inheritParams project_framework
#' @author Frederik Sachser
#' @export
template_make <- function(target_makeR = 'make.R', 
                          fun_dir = 'in/fun',
                          source_files = c('load.R',
                                           'report.Rmd'),
                          cache_dir = '.cache',
                          source_dir = 'in/src',
                          data_dir = 'in/data',
                          target_dir_figure = 'out/figure',
                          target_dir_docs = 'out/docs',
                          target_dir_data = 'out/data',
                          rename_figure = TRUE,
                          rename_docs = TRUE,
                          spin_index,
                          cache_index,
                          knitr_cache) {
    if (file.exists(target_makeR)) {
        stop("File exists. Delete the file and retry.")
    }
  framework_version <- paste0(unlist(utils::packageVersion('framework')), collapse = ".")
    cat(
"############ make-like file ############

# This project was build by using the package <<framework>> (v", framework_version, ")
# visit https://github.com/sachserf/framework/blob/master/README.md for a short introduction
# visit https://sachserf.github.io for further information and tutorials

############ PREAMBLE ############

# detach package:framework
if ('package:framework' %in% search() == TRUE) {
  detach(package:framework)
}

# detach localfun
if ('localfun' %in% search() == TRUE) {
    detach(localfun)
}

# clear Global environment
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))

# initialize new environment: <<localfun>>
localfun <- new.env(parent = .GlobalEnv)

# source every R-file within directory <<fun_dir>>
# and assign them to the environment <<localfun>>
sapply(list.files(
        '", fun_dir, "',
        pattern = '*.R$',
        full.names = TRUE,
        recursive = TRUE
    ), source, local = localfun)

# attach the environment <<localfun>>
attach(localfun)

# remove the environment <<localfun>> from .GlobalEnv
rm(localfun)

############ PACKAGES ############

# install packages without loading:
pkg_install(c('utils', 
        'tools',
        'rmarkdown',
        'knitr',
        'rstudioapi'),
    attach = FALSE)

# install and load packages:
pkg_install(c('tidyr'),
    attach = TRUE)

############ SOURCE ############

# fill in R/Rmd-files in chronological order
instructions(
    source_files = c('", paste(source_files, collapse = '\',\''),"'),   # relative to source_dir
    spin_index = ", spin_index,",
    cache_index = ", cache_index,",
    cache_dir = '", cache_dir,"',
    source_dir = '", source_dir,"',
    data_dir = '", data_dir,"',
    target_dir_figure = '", target_dir_figure,"',
    target_dir_docs = '", target_dir_docs,"',
    rename_figure = ", rename_figure, ",
    rename_docs = ", rename_docs, ",
    knitr_cache = ", knitr_cache, "
)

############ SUPPLEMENT ############

# save all data frames (within .GlobalEnv)
write_dataframe(target_dir_data = '", target_dir_data, "', file_format = 'csv')

# write session_info
session_info()

# backup (optionally change target directory and excluded files/dir)
#backup(exclude_directories = 'packrat|.git|", data_dir,"|", cache_dir,"|", target_dir_data,"|", target_dir_figure,"|", target_dir_docs,"',
#       exclude_files = '*.RData|*.Rhistory|*.rds', delete_target = TRUE)

# print summary of instructions
summary_instructions(cache_dir = '", cache_dir,"')

",
        file = target_makeR, sep = ""
    )
}
