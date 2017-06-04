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
                          source_dir = 'in/docs',
                          data_dir = 'in/data',
                          target_dir_figure = 'out/figure',
                          target_dir_docs = 'out/docs',
                          target_dir_data = 'out/data',
                          rename_figure = TRUE,
                          rename_docs = TRUE,
                          log_filepath = 'meta/log.csv',
                          tree_target = 'meta/tree.txt',
                          session_info_filepath = 'meta/session_info.txt',
                          spin_index,
                          cache_index,
                          knitr_cache = FALSE) {
    if (file.exists(target_makeR)) {
        stop("File exists. Delete the file and retry.")
    }
  
    cat(
"############ ########### ############
############ fast access ############
############ ########### ############
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))
current_project <- '",basename(getwd()),"'
############ files to process (chronological order) ############
project_docs <- c('", paste(source_files, collapse = '\',\''),"')
############ packages to install (not loading) ############
pkg2install <- c('utils', 
                 'tools',
                 'rmarkdown',
                 'knitr',
                 'rstudioapi')
############ packages to install AND load ############
pkg2attach <- c('tidyverse', 
                'stringi')



############ ######## ############
############ PREAMBLE ############
############ ######## ############

############ SET WD ############

setwd2toplevel <- function(toplevel) {
  cmdArgs <- commandArgs(trailingOnly = FALSE)
  needle <- '--file='
  match <- grep(needle, cmdArgs)
  if (length(match) > 0) {
    # Rscript via command line
    current_file_path <-
      normalizePath(sub(needle, '', cmdArgs[match]))
  } else {
    ls_vars = ls(sys.frames()[[1]])
    if ('fileName' %in% ls_vars) {
      # Source'd via RStudio
      current_file_path <- normalizePath(sys.frames()[[1]]$fileName)
    } else {
      if (!is.null(sys.frames()[[1]]$ofile)) {
        # Source'd via R console
        current_file_path <- normalizePath(sys.frames()[[1]]$ofile)
      } else {
        # RStudio Run Selection
        current_file_path <-
          normalizePath(rstudioapi::getActiveDocumentContext()$path)
        if (nchar(current_file_path) == 0) {
          message('No Active Document. Try to set working directory to active project.')
          current_file_path <-
            rstudioapi::getActiveProject()
          if (is.null(current_file_path)) {
            return(message(
              'No Active Document or Project. Skip setwd()'
            ))
          }
        }
      }
    }
  }
  # change wd to top level
  if (grepl(pattern = '\\\\\\\\', x = current_file_path)) {
    fp_split <-
      unlist(strsplit(x = file.path(current_file_path), split = '\\\\\\\\'))
    if (length(which(fp_split == toplevel)) > 0) {
      project_directory <-
        file.path(paste(fp_split[1:max(which(fp_split == toplevel))], collapse = '\\\\'))
    } else {
      return(message('Cannot set working directory.'))
    }
  } else {
    fp_split <-
      unlist(strsplit(x = file.path(current_file_path), split = '/'))
    if (length(which(fp_split == toplevel)) > 0) {
      project_directory <-
        file.path(paste(fp_split[1:max(which(fp_split == toplevel))], collapse = '/'))
    } else {
      return(message('Cannot set working directory.'))
    }
  }
  if (dir.exists(project_directory) == FALSE) {
    stop('Check typo of the top level directory')
  }
  setwd(project_directory)
}
setwd2toplevel(toplevel = current_project)

# detach package:framework
if ('package:framework' %in% search() == TRUE) {
  detach(package:framework)
}

# detach localfun
if ('localfun' %in% search() == TRUE) {
    detach(localfun)
}

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
pkg_install(pkg_names = pkg2install,
    attach = FALSE)

# install and load packages:
pkg_install(pkg_names = pkg2attach,
    attach = TRUE)





############ #### ############
############ BODY ############
############ #### ############

# fill in R/Rmd-files in chronological order
instructions(
    source_files = project_docs, 
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





############ ########## ############
############ SUPPLEMENT ############
############ ########## ############

# clean globalenv
rm(pkg2attach, pkg2install, project_docs, current_project)

# save all data frames (within .GlobalEnv)
write_dataframe(target_dir_data = '", target_dir_data, "', file_format = 'RData')

# write tree
treedir(tree_target = '", tree_target,"')

# write log_entry
log_entry(log_filepath = '", log_filepath, "')

# View log summary
# log_summary(log_filepath = '", log_filepath, "') # depends on dplyr

# write session_info
session_info(session_info_filepath = '", session_info_filepath, "')

# backup (optionally change target directory and excluded files/dir)
#backup(exclude_directories = 'packrat|.git|", data_dir,"|", cache_dir,"|", target_dir_data,"|", target_dir_figure,"|", target_dir_docs,"', exclude_files = '*.RData|*.Rhistory|*.rds', delete_target = TRUE)

# print summary of instructions
summary_instructions(cache_dir = '", cache_dir,"')

",
        file = target_makeR, sep = ""
    )
}
