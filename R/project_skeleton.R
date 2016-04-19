project_skeleton <-
  function(){
    # create basic directories:
    basic_dirs <- list('input/data', 'input/R', 'input/functions/sachserf_framework', 'input/documents')
    lapply(X = basic_dirs, FUN = dir.create, recursive = TRUE)
    # create load.R
    if(file.exists("input/R/load.R") == FALSE){
      cat("# load data", file = "input/R/load.R")
    } else {
      warning("input/R/load.R already exists")
    }
    # create clean.R
    if(file.exists("input/R/clean.R") == FALSE){
      cat("# clean data", file = "input/R/clean.R")
    } else {
      warning("input/R/clean.R already exists")
    }
    # create pkg_install-function
    framework::dput_function(
      pkg_fun = framework::pkg_install,
      target_dir = paste0(dirname, '/', 'input/functions/sachserf/framework'),
      substitute_framework = TRUE
    )
    # create write_dataframe-function
    if(file.exists("input/functions/sachserf_framework/write_dataframe.R") == FALSE){
      cat(".write_dataframe <- function(listofdf = 'GlobalEnv', target_dir =  'standard', file_format = 'csv', overwrite = TRUE) {
  if(listofdf == 'GlobalEnv') {
    listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == TRUE))
  }
  if(target_dir == 'standard') {
    target_dir <- file.path(getwd(), 'output/data/')
  }
  # delete 'old' data
  if(overwrite == TRUE) {
    unlink(target_dir, recursive = TRUE)
  }
  # create target_dir
  if(dir.exists(target_dir) == FALSE) {
    dir.create(target_dir, recursive = TRUE)
  }
  # write data
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
  if(file_format == 'RData') {
    RData_fun <- function(objectname){
      filename <- paste(file.path(target_dir, objectname), 'RData', sep = '.')
      save(file = filename, list = objectname)
    }
    lapply(listofdf, FUN = RData_fun)
  }
}

", file = "input/functions/sachserf_framework/write_dataframe.R")
    } else {
      warning("write_dataframe (function) already exists")
    }
    # create SessionInfo-function
    if(file.exists("input/functions/sachserf_framework/session_info.R") == FALSE){
      cat(".session_info <- function(file = 'output/documents/info/session_info.txt'){
  sink(file)
  print(Sys.time())
  print(sessionInfo())
  sink()
  }

", file = "input/functions/sachserf_framework/session_info.R")
      } else {
        warning("session_info (function) already exists")
      }
# create reminder-function
  if(file.exists("input/functions/sachserf_framework/reminder.R") == FALSE){
    cat(".reminder <- function() {
    print('Don´t forget to add & commit snapshots and pull & push your git repository.')
  }

", file = "input/functions/sachserf_framework/reminder.R")
} else {
  warning("reminder (function) already exists")
}
    # create render_documents-function
    if(file.exists("input/functions/sachserf_framework/render_documents.R") == FALSE){
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

    ", file = "input/functions/sachserf_framework/render_documents.R")
    } else {
      warning("render_documents (function) already exists")
    }
    # create compile_notebooks function
    if(file.exists('input/functions/sachserf_framework/compile_notebooks.R') == FALSE) {
      cat(".compile_notebooks <- function(make_filename = 'make.R', source_dir = 'input/R', target_dir = 'output/documents/notebooks', keep_Rmd = FALSE) {
  # read makefile
  makefile <- readLines(make_filename) 
  # trim makefile (source scripts only)
  make_trimmed <- makefile[grep('(?=.*input/R/)(?=.*source)', makefile, perl = TRUE)]
  # extract file path of scripts
  file_path_R <- substr(x = make_trimmed, start = 9, stop = nchar(make_trimmed)-2)
  # extract filename of scripts 
  file_name_R <- c()
  for(i in seq_along(file_path_R)) {
    tempfile <- strsplit(x = file_path_R, split = '/')[[i]]
    file_name_R[i] <- tempfile[length(tempfile)]
  }
  # extract script-names:
  script_names <- substr(file_name_R, start = 1, stop = nchar(file_name_R)-2)
  # create directory
  if(dir.exists(target_dir) == FALSE) dir.create(target_dir, recursive = TRUE)
  file_path_Rmd <- paste(file.path(target_dir, script_names), 'Rmd', sep = '.')
  # stitch Rmd files
  for(i in seq_along(file_path_R)) {
    knitr::stitch_rmd(script = file_path_R[i], output = file_path_Rmd[i], envir = globalenv())
  }
  # delete old figures
  file_path_figure <- file.path(target_dir, 'figure')
  if(dir.exists(file_path_figure)) unlink(file_path_figure, recursive = TRUE)
  # copy paste new figures
  if(dir.exists('figure')) file.rename(from = 'figure', to = file_path_figure)
  # render html files
  for(i in seq_along(file_path_Rmd)) {
    rmarkdown::render(input = file_path_Rmd[i])
  }
  # delete Rmd
  if(keep_Rmd == FALSE) {
    unlink(list.files(path = target_dir, pattern = '*.Rmd', full.names = TRUE))
  }
}
          ", file = 'input/functions/sachserf_framework/compile_notebooks.R')
    }
    # create backup-function
    if(file.exists("input/functions/sachserf_framework/backup.R") == FALSE){
      cat(".backup <-
function(target_dir = 'project_subdir', source_dir = file.path(getwd()), overwrite = TRUE, exclude_directories = FALSE, exclude_files = FALSE){
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

", file = "input/functions/sachserf_framework/backup.R")
    } else {
      warning("backup (function) already exists")
    }
    # create make.R
    if(file.exists("make.R") == FALSE){
      cat("# make-like file

############ PREAMBLE ############   

# clear environment
rm(list = ls())

# source functions placed in directory <<input/functions>>:
.project_fun <- list.files('input/functions', pattern='*.R$', full.names = TRUE, recursive = TRUE)
sapply(.project_fun, source, .GlobalEnv)

############ PACKAGES ############   

# install packages without loading:
.pkg_install(c('rmarkdown', 'knitr', 'packrat', 'plyr', 'stringi'), attach = FALSE)

# install and load packages:
.pkg_install(c('dplyr', 'ggplot2'), attach = TRUE)

############ SOURCE ############ 
# NOTE: There should not be any comment after source()

source('input/R/load.R')
source('input/R/clean.R')

############ RENDER ############

.render_documents()
.compile_notebooks()

############ SUPPLEMENT ############   

# save all data frames (that are placed in .GlobalEnv) as csv 
# (optionally RData or rds)
.write_dataframe()

# write session_info
.session_info()

# backup (optionally change target directory)
.backup(exclude_directories = '.git|input/data|output',
        exclude_files = '*.RData|*.Rhistory')

.reminder()

", file = 'make.R')
    } else {
      warning("make.R already exists")
    }
    # create manual.Rmd
    if(file.exists("input/documents/manual.Rmd") == FALSE){
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
make_trimmed <- makefile[grep('source|pkg_install', makefile)]
# write new file 'ghost_file.R'
cat(make_trimmed, sep = '\\n', file = 'ghost_file.R') 
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

", file = "input/documents/manual.Rmd")
    } else {
      warning("manual.Rmd already exists")
    }
  }



