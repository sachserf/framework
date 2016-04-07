project_skeleton <-
  function(){
    # create basic directories:
    basic_dirs <- list('input/data', 'input/R/fun', 'input/documents', 
                       'output/data', 'output/figures', 'output/documents')
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
    if(file.exists("input/R/fun/pkg_install.R") == FALSE){
      sink("input/R/fun/pkg_install.R")
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
    if(file.exists("input/R/fun/write_dataframe.R") == FALSE){
      sink("input/R/fun/write_dataframe.R")
      cat(".write_dataframe <- function(listofdf = 'GlobalEnv', target_dir =  'standard', file_format = 'rData') {
  if(listofdf == 'GlobalEnv') {
    listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == TRUE))
  }
  if(target_dir == 'standard') {
    target_dir <- file.path(getwd(), 'output/data')
  }
  if(dir.exists(target_dir) == FALSE) {
    dir.create(target_dir, recursive = TRUE)
  }
  if(file_format == 'csv') {
    csv_fun <- function(...){
      data_path <- file.path(target_dir, ...)
      data_path_extension <- paste(data_path, '.csv', sep = '')
      write.table(get(...), data_path_extension, sep = ';', row.names = FALSE)
    }
    lapply(X = listofdf, FUN = csv_fun)
  }
  if(file_format == 'rds') {
    rds_fun <- function(...){
      data_path <- file.path(target_dir, ...)
      data_path_extension <- paste(data_path, '.rds', sep = '')
      saveRDS(object = get(...), file = data_path_extension)
    }
  lapply(X = listofdf, FUN = rds_fun)
  }
  if(file_format == 'rData') {
    rData_fun <- function(...){
      data_path <- file.path(target_dir, ...)
      data_path_extension <- paste(data_path, '.rData', sep = '')
      save(get(...), file = data_path_extension)
    }
  lapply(X = listofdf, FUN = rData_fun)
  }
}
          ")
      sink()
    } else {
      warning("write_dataframe (function) already exists")
    }
    # create SessionInfo-function
    if(file.exists("input/R/fun/session_info.R") == FALSE){
      sink("input/R/fun/session_info.R")
      cat(".session_info <- function(file = 'output/documents/session_info.txt'){
  sink(file)
  print(Sys.time())
  print(sessionInfo())
  sink()
}")
      sink()
      } else {
        warning("session_info (function) already exists")
      }
    # create render_documents-function
    if(file.exists("input/R/fun/render_documents.R") == FALSE){
      sink("input/R/fun/render_documents.R")
      cat(".render_documents <- function(source_dir = 'input/documents', target_dir = 'output/documents', file_format = 'rmd') {
  file_pattern <- paste('*.', file_format, sep = '')
  all_files <- list.files(path = source_dir, pattern = file_pattern,
                          recursive = TRUE,
                          full.names = TRUE,
                          ignore.case = TRUE)
  lapply(X = all_files,
         FUN = rmarkdown::render,
         output_dir = target_dir,
         quiet = TRUE)
}
    ")
      sink()
    } else {
      warning("render_documents (function) already exists")
    }
    # create backup-function
    if(file.exists("input/R/fun/backup.R") == FALSE){
      sink("input/R/fun/backup.R")
      cat(".backup <-
function(target_dir = 'project_subdir', source_dir = file.path(getwd()), overwrite = TRUE){
  suppressMessages(
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
    # exclude backup directory and files if it is within the project directory
    dir_exclude <- grep(pattern = target_dir, x = file.path(source_dir, sub_directories))
    if(length(dir_exclude) != 0){
      sub_directories <- file.path(sub_directories)[-dir_exclude]
    }
    project_files_full <- list.files(source_dir, full.names = TRUE, all.files = TRUE, no.. = TRUE, recursive = TRUE)
    file_exclude <- grep(pattern = target_dir, x = project_files_full)
    if(length(file_exclude) != 0){
      project_files <- file.path(project_files)[-file_exclude]
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
  )
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
          
# source functions placed in directory <<input//R/fun>>:
.file.sources <- list.files('input/R/fun', pattern='*.R$', full.names=TRUE, ignore.case=TRUE)
sapply(.file.sources, source, .GlobalEnv)

############ PACKAGES ############   

# install packages without loading:
.pkg_install(c('plyr', 'rmarkdown', 'packrat', 'stringi'), attach = FALSE)
          
# install and load packages:
.pkg_install(c('dplyr', 'ggplot2'), attach = TRUE)
          
############ SOURCE ############ 

source('scripts/load.R')
source('scripts/clean.R')    #...

############ RENDER ############

.render_documents()

############ SUPPLEMENT ############   

# save all data frames (that are placed in .GlobalEnv) as rData 
# (optionally csv or rds)
.write_dataframe()

# write session_info
.session_info()

# backup the whole project directory
# optionally change target directory 
.backup()

print('Reminder: Don´t forget to commit a snapshot frequently.')
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
knitr::opts_chunk$set(echo = FALSE)
```
        
```{r source_make, include=FALSE}
# Copy this chunk to every .Rmd-file and edit the file paths if you want to use additional subdirectories (../)
          
# read make.R
makefile <- readLines('../../make.R') 
# delete lines including the word 'render'
makefile_wo_render <- makefile[-grep('render', makefile)]
# write new file '.do_not_edit.R'
cat(makefile_wo_render, sep = '\n', file = '../../.do_not_edit.R') 
# source '.do_not_edit.R'
source(file = '../../.do_not_edit.R', chdir = TRUE)
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


