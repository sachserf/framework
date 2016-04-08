project_skeleton <-
  function(){
    # create basic directories:
    basic_dirs <- list('input/data', 'input/R', 'input/functions', 'input/documents', 
                       'output/data', 'output/figures', 'output/documents/info')
    lapply(X = basic_dirs, FUN = dir.create, recursive = TRUE)
    # create load.R
    if(file.exists("input/R/load.R") == FALSE){
      sink("input/R/load.R")
      cat("# load data")
      sink()
    } else {
      warning("input/R/load.R already exists")
    }
    # create clean.R
    if(file.exists("input/R/clean.R") == FALSE){
      sink("input/R/clean.R")
      cat("# clean data")
      sink()
    } else {
      warning("input/R/clean.R already exists")
    }
    # create pkg_install-function
    if(file.exists("input/functions/pkg_install.R") == FALSE){
      sink("input/functions/pkg_install.R")
      cat(".pkg_install <- function(pkg_names = ..., attach = TRUE){
  exist_pack <- pkg_names %in% rownames(installed.packages())
  if(any(!exist_pack)) install.packages(pkg_names[!exist_pack])
  if(attach == TRUE) lapply(pkg_names, library, character.only = TRUE)
}")
sink()
  } else {
    warning("pkg_install (function) already exists")
  }
    # create write_dataframe-function
    if(file.exists("input/functions/write_dataframe.R") == FALSE){
      sink("input/functions/write_dataframe.R")
      cat(".write_dataframe <- function(listofdf = 'GlobalEnv', target_dir =  'standard', file_format = 'csv') {
  if(listofdf == 'GlobalEnv') {
    listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == TRUE))
  }
  if(target_dir == 'standard') {
    target_dir <- file.path(getwd(), 'output/data/')
  }
  if(dir.exists(target_dir) == FALSE) {
    dir.create(target_dir, recursive = TRUE)
  }
  if(file_format == 'csv') {
    csv_fun <- function(objectname){
      filename <- paste(file.path(target_dir, objectname), 'csv', sep = '.')
      write.table(get(objectname), filename, sep = ';', row.names = FALSE)
    }
    lapply(listofdf, FUN = csv_fun)
  }
  if(file_format == 'rds') {
    rds_fun <- function(objectname){
      filename <- paste(file.path(target_dir, objectname), 'rds', sep = '.')
      saveRDS(object = get(objectname), file = filename)
    }
    lapply(listofdf, FUN = rds_fun)
  }
  if(file_format == 'rData') {
    rData_fun <- function(objectname){
      filename <- paste(file.path(target_dir, objectname), 'rData', sep = '.')
      save(file = filename, list = objectname)
    }
    lapply(listofdf, FUN = rData_fun)
  }
}

          ")
      sink()
    } else {
      warning("write_dataframe (function) already exists")
    }
    # create SessionInfo-function
    if(file.exists("input/functions/session_info.R") == FALSE){
      sink("input/functions/session_info.R")
      cat(".session_info <- function(file = 'output/documents/info/session_info.txt'){
  sink(file)
  print(Sys.time())
  print(sessionInfo())
  sink()
}")
      sink()
      } else {
        warning("session_info (function) already exists")
      }
# create reminder-function
if(file.exists("input/functions/reminder.R") == FALSE){
  sink("input/functions/reminder.R")
  cat(".reminder <- function() {
  print('Don´t forget to add & commit snapshots and pull & push your git repository.')
}")
  sink()
} else {
  warning("reminder (function) already exists")
}
    # create render_documents-function
    if(file.exists("input/functions/render_documents.R") == FALSE){
      sink("input/functions/render_documents.R")
      cat(".render_documents <- function(source_dir = 'input/documents', target_dir = 'output/documents', file_format = 'rmd') {
  file_pattern <- paste('*.', file_format, sep = '')
  all_files <- list.files(path = source_dir, pattern = file_pattern,
                          recursive = TRUE,
                          full.names = TRUE,
                          ignore.case = TRUE)
  lapply(X = all_files,
        FUN = rmarkdown::render,
        output_dir = target_dir,
        quiet = TRUE,
        output_format = 'all',
        envir = .GlobalEnv)
}
    ")
      sink()
    } else {
      warning("render_documents (function) already exists")
    }
    # create backup-function
    if(file.exists("input/functions/backup.R") == FALSE){
      sink("input/functions/backup.R")
      cat(".backup <-
function(target_dir = 'project_subdir', source_dir = file.path(getwd()), overwrite = TRUE, exclude_directories = FALSE){
  projname <- paste('BACKUP_', basename(getwd()), sep = '')
  if(target_dir == 'project_subdir') {
    target_dir <- file.path(getwd(), projname)
  } else { 
    target_dir <- file.path(target_dir, projname)
  }
  stime <- format(Sys.time(), format(Sys.time(), format='%Y%m%d-%A-%H%M%S'))
  target_dir_stime <- file.path(target_dir, stime)
  sub_directories <- list.dirs(source_dir, full.names = FALSE)
  project_files <- list.files(source_dir, all.files = TRUE, no.. = TRUE, recursive = TRUE)
  # exclude backup directory if 'backup' is placed within the project directory
  dir_exclude <- grep(pattern = target_dir, x = file.path(source_dir, sub_directories))
  if(length(dir_exclude) != 0){
    sub_directories <- file.path(sub_directories)[-dir_exclude]
  }
  if(exclude_directories != FALSE) {
    dir_exclude_custom <- grep(pattern = exclude_directories, x = file.path(source_dir, sub_directories))
    if(length(dir_exclude_custom) != 0){
      sub_directories <- file.path(sub_directories)[-dir_exclude_custom]
    }
  }
  # exclude backup files if 'backup' is placed within the project directory
  project_files_full <- list.files(source_dir, full.names = TRUE, all.files = TRUE, no.. = TRUE, recursive = TRUE)
  file_exclude <- grep(pattern = target_dir, x = project_files_full)
  if(length(file_exclude) != 0){
    project_files <- file.path(project_files)[-file_exclude]
  }
  if(exclude_directories != FALSE) {
    file_exclude_custom_dir <- grep(pattern = exclude_directories, x = project_files)
    if(length(file_exclude_custom_dir) != 0){
      project_files <- file.path(project_files)[-file_exclude_custom_dir]
    }
  }
  # exclude files if specified
  if(exclude_files != FALSE) {
    file_exclude_custom_file <- grep(pattern = exclude_files, x = project_files)
    if(length(file_exclude_custom_file) != 0){
      project_files <- file.path(project_files)[-file_exclude_custom_file]
    }
  }
  # function to create directories
  dir_create_or_exist <- function(thedirectory) {
    if(dir.exists(thedirectory) == FALSE) {
      dir.create(thedirectory, recursive = TRUE)
    }
  }
  if (overwrite == TRUE) unlink(target_dir, recursive = TRUE)
  # create directories
  dir_create_or_exist(target_dir)
  lapply(file.path(target_dir_stime, sub_directories), dir_create_or_exist)
  # copy files
  file.copy(from = file.path(source_dir, project_files), to = file.path(target_dir_stime, project_files),  recursive = FALSE)
}
          ")
      sink()
    } else {
      warning("backup (function) already exists")
    }
    # create make.R
    if(file.exists("make.R") == FALSE){
      sink("make.R")
      cat("# make-like file

############ PREAMBLE ############   

# clear environment
rm(list = ls())
          
# source functions placed in directory <<input/functions>>:
.file.sources <- list.files('input/functions', pattern='*.R$', full.names=TRUE, ignore.case=TRUE)
sapply(.file.sources, source, .GlobalEnv)

############ PACKAGES ############   

# install packages without loading:
.pkg_install(c('rmarkdown', 'knitr', 'packrat', 'plyr', 'stringi'), attach = FALSE)
          
# install and load packages:
.pkg_install(c('dplyr', 'ggplot2'), attach = TRUE)
          
############ SOURCE ############ 

source('input/R/load.R')
source('input/R/clean.R')    #...

############ RENDER ############

.render_documents(source_dir = 'input/R', target_dir = 'output/documents/notebooks', file_format = 'R')
.render_documents(source_dir = 'input/documents', target_dir = 'output/documents', file_format = 'Rmd')

############ SUPPLEMENT ############   

# save all data frames (that are placed in .GlobalEnv) as csv 
# (optionally rData or rds)
.write_dataframe()

# write session_info
.session_info()

# backup
# optionally change target directory and/or exclude directories/files
# wildcards are supported
# e.g exclude directories 'data' and 'documents': 
#   exclude_dirs = 'input/data|input/documents'
# e.g. exclude all '.R'-files:
#   exclude_files = '*.R'

.backup()

.reminder()
          ")
      sink()
    } else {
      warning("make.R already exists")
    }
    # create manual.Rmd
    if(file.exists("input/documents/manual.Rmd") == FALSE){
      sink("input/documents/manual.Rmd")
      cat("---
title: 'Manual'
author: 'Your Name'
date: '7 April 2016'
output: 
  html_document: 
    number_sections: yes
    toc: yes
    toc_float: yes
    theme: united
    highlight: tango
---
        
```{r setup, include=FALSE}
# Copy the first and the second chunk to every .Rmd-file.
# Edit the file path of this chunk 'setup' if you want to use additional subdirectories (for input AND output)
    
# set knitr options
knitr::opts_knit$set(root.dir  = '../..')
      
# set chunk options
knitr::opts_chunk$set(echo = FALSE, fig.path = '../../output/figures/')
```
          
```{r source_make, include=FALSE}
# read make.R
makefile <- readLines('make.R') 
# exclude some lines from make.R
make_trimmed <- makefile[-grep('render_documents|write_dataframe|session_info|backup', makefile)]
# write new file 'ghost_file.R'
cat(make_trimmed, sep = '
', file = 'ghost_file.R') 
# source 'ghost_file.R'
source(file = 'ghost_file.R', chdir = TRUE)
# delete 'ghost_file.R'
unlink('ghost_file.R')
```
          
# Project Description
          
## load.R
          
## clean.R
          
# Data Manual
        
## data 1
          
## data 2
          
          ")
      sink()
    } else {
      warning("manual.Rmd already exists")
    }
  }


