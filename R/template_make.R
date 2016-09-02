#' template_make
#' @description template_make
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
                          rename_docs = TRUE) {
    if (file.exists(target_makeR)) {
        stop("File exists. Delete the file and retry.")
    }
  framework_version <- paste0(unlist(utils::packageVersion('framework')), collapse = ".")
    cat(
"############ make-like file ############

# This project was build by using the package <<framework>> (v", framework_version, ")
# see 'how-to-guide.md' for a short introduction
# visit https://sachserf.github.io for further information

############ PREAMBLE ############
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

# check if Working directory is different from active Project
if ('rstudioapi' %in% utils::installed.packages() == TRUE) {
  if (identical(rstudioapi::getActiveProject(), getwd()) == FALSE) {
    stop('Working directory is different from active Project')
  }
}

############ PACKAGES ############

# install packages without loading:
pkg_install(c('utils', 
        'tools',
        'rmarkdown',
        'knitr',
        'rstudioapi'),
    attach = FALSE)

# install and load packages:
pkg_install(c('dplyr',
        'ggplot2',
        'stringi',
        'tidyr',
        'readr'),
    attach = TRUE)

############ SOURCE ############

# fill in R/Rmd-files in chronological order
instructions(
    source_files = c('", paste(source_files, collapse = '\',\''),"'),   # relative to source_dir
    spin_index = 'all',
    cache_index = 'all',
    cache_dir = '", cache_dir,"',
    source_dir = '", source_dir,"',
    data_dir = '", data_dir,"',
    target_dir_figure = '", target_dir_figure,"',
    target_dir_docs = '", target_dir_docs,"',
    rename_figure = ", rename_figure, ",
    rename_docs = ", rename_docs, "
)

# Optionally prepare and render Rmd-files as a website
#prepare_site(
#  Rmd_input = c('in/src/website/placeholder.Rmd'),
#  target_dir = 'out/website',
#  index_menu = FALSE,
#  index_name = 'Home',
#  page_name = 'framework-hp'
#)

#rmarkdown::render_site(input = 'in/src/website/') # same input_dir as the files in prepare_site

############ SUPPLEMENT ############

# save all data frames (within .GlobalEnv)
write_dataframe(target_dir_data = '", target_dir_data, "', file_format = 'csv')

# write session_info
session_info()

# backup (optionally change target directory and excluded files/dir)
#backup(exclude_directories = 'packrat|.git|", data_dir,"|", cache_dir,"|", target_dir_data,"|", target_dir_figure,"|", target_dir_docs,"',
#       exclude_files = '*.RData|*.Rhistory|*.rds', delete_target = TRUE)

# print summary of instructions
summary_instructions()

",
        file = target_makeR, sep = ""
    )
}
