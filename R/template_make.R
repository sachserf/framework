#' Template for a make-like file
#' 
#' @description This function will create a template for a make-like file. It is
#'   possible to specify a predefined set of parameters.
#' @inheritParams project_framework
#' @author Frederik Sachser
#' @export
template_make <- function(target_makeR = 'make.R',
                          target_params = "params.R",
                          source_files = c('load.R',
                                           'report.Rmd'),
                          pkg_cran_install = c('utils', 'tools', 'rmarkdown', 'knitr', 'rstudioapi'),
                          pkg_cran_load = c('tidyverse'),
                          pkg_gh_install = NULL,
                          pkg_gh_load = NULL,
                          fun_dir = 'in/fun',
                          spin_index = 0,
                          cache_index = 999,
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
                          listofdf = 'GlobalEnv',
                          file_format = 'RData',
                          include_hidden = FALSE,
                          delete_target_dir = TRUE,
                          tree_directory = getwd(),
                          knitr_cache = FALSE) {
    if (file.exists(target_makeR) | file.exists(target_params)) {
        stop("File(s) exists. Specify a different directory or delete the file(s) and retry.")
    }
  
    cat(
"# This file is dependent on parameters specified in external files (default: params.R)
# .rs.restartR() # only RStudio
cat('\014')
options(warn = 1)
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))
current_project <- ", basename(getwd()), 
"filepath_instructions <- c('params.R')

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
            suppressWarnings(normalizePath(rstudioapi::getActiveDocumentContext()$path))
          if (nchar(current_file_path) == 0) {
            message('No Active Document. Try to set working directory to active project.')
            current_file_path <-
              rstudioapi::getActiveProject()
            if (is.null(current_file_path)) {
              return(message('No Active Document or Project. Skip setwd()'))
            }
          }
        }
      }
    }
    # change wd to top level
    if (grepl(pattern = '\\\\', x = current_file_path)) {
      fp_split <-
        unlist(strsplit(x = file.path(current_file_path), split = '\\\\'))
      if (length(which(fp_split == toplevel)) > 0) {
        project_directory <-
          file.path(paste(fp_split[1:max(which(fp_split == toplevel))], collapse = '\\'))
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

prj_toplvl <- getwd()

cat(message('#############################################\n############ WARNINGS & MESSAGES ############\n#############################################'), '\n')

sapply(file.path(getwd(), filepath_instructions), source) # neu

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
sapply(
  list.files(
    path = fun_dir,
    pattern = '*.R$',
    full.names = TRUE,
    recursive = TRUE
  ), 
  source, 
  local = localfun
)

# attach the environment <<localfun>>
attach(localfun)

# remove the environment <<localfun>> from .GlobalEnv
rm(localfun)

# install packages without loading:
pkg_cran(pkg_names = pkg_cran_install, attach = FALSE)
pkg_gh(pkg_names = pkg_gh_install, attach = FALSE)

# install and load packages:
pkg_cran(pkg_names = pkg_cran_load)
pkg_gh(pkg_names = pkg_gh_load)

framework_object_list <- ls()

instructions(
  source_files = source_files,
  spin_index = spin_index,
  cache_index = cache_index,
  cache_dir = cache_dir,
  source_dir = source_dir,
  data_dir = data_dir,
  target_dir_figure = target_dir_figure,
  target_dir_docs = target_dir_docs,
  rename_figure = rename_figure,
  rename_docs = rename_docs,
  knitr_cache = knitr_cache
)
    
# save all data frames (within .GlobalEnv)
write_dataframe(listofdf = listofdf, 
                target_dir_data = target_dir_data, 
                file_format = file_format, 
                delete_target_dir = delete_target_dir
)
    
# write tree
treedir(tree_directory = tree_directory, tree_target = tree_target, include_hidden = include_hidden)

# write log_entry
log_entry(log_filepath = log_filepath)
    
# write session_info
session_info(session_info_filepath = session_info_filepath)
    
message('\n#############################################\n################## SUMMARY ##################\n#############################################')
    
# log summary
if ('dplyr' %in% installed.packages()) {
  message('\nlog:\n')
  print(log_summary(log_filepath = 'meta/log.csv')$per_NODENAME)
  cat('\n--------------------------------------------\n')
}
    
# git summary
message('\ngit:\n')
summary_git(git_repo = prj_toplvl)
    
cat('\n--------------------------------------------\n')
    
# print summary of instructions
message('\nSummary of executed instructions:\n')
summary_instructions(cache_dir = cache_dir)
    
cat('\n--------------------------------------------\n')
    
# memory
message('\nMemory Usage:'); print(memory_usage())
# getwd
df_source_files <- readRDS(file = file.path(cache_dir, 'df_source_files.rds'))
message(
  '\nProcessed ', 
  nrow(df_source_files) - which(df_source_files$instruction == 'load'), 
  '/', 
  nrow(df_source_files), 
  ' files @WD:')
cat(getwd(), '\n')
    
message('\n#############################################\n###### FINISHED at ', Sys.time(), ' ######\n#############################################')
    
# clean globalenv
rm(framework_object_list, 
  list = paste(framework_object_list), 
  envir = .GlobalEnv)
", file = target_makeR, sep = ""
    )

cat("
source_files = ", source_files, "

pkg_cran_install <- ", pkg_cran_install, "
pkg_cran_load <- ", pkg_cran_load, "
if (system('git --version') == 0) {
  pkg_cran_load <- c(pkg_cran_load, 'git2r')
}
pkg_gh_install <- ", pkg_gh_install, "
pkg_gh_load <- ", pkg_gh_load, "

spin_index = ", spin_index, "
cache_index = ", cache_index, "
cache_dir = '", cache_dir, "'
source_dir = '", source_dir, "'
fun_dir = '", fun_dir, "'
data_dir = '", data_dir, "'
target_dir_figure = '", target_dir_figure, "'
target_dir_docs = '", target_dir_docs, "'
rename_figure = ", rename_figure, "
rename_docs = ", rename_docs, "
knitr_cache = ", knitr_cache, "

target_dir_data = '", target_dir_data, "'
listofdf = ", listofdf, "
file_format = '", file_format, "'
delete_target_dir = ", delete_target_dir, "

tree_directory = ", tree_directory, "
tree_target = '", tree_target, "'
include_hidden = ", include_hidden, "
log_filepath = '", log_filepath, "'
session_info_filepath = '", session_info_filepath, "'", 
file = target_params, sep = "")
}
