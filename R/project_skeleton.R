skeleton <-
  function(){
    #### create basic directories ####
    basic_dirs <- list('in/data', 'in/src', 'in/fun/sachserf_framework', 'out/usr')
    lapply(X = basic_dirs, FUN = dir.create, recursive = TRUE)

      #### create fun ####
      # create backup-function
      framework::dput_function(
        pkg_fun = framework::backup,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create pkg_install-function
      framework::dput_function(
        pkg_fun = framework::pkg_install,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create reminder-function
      framework::dput_function(
        pkg_fun = framework::reminder,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create session_info-function
      framework::dput_function(
        pkg_fun = framework::session_info,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create template_Rmd-function
      framework::dput_function(
        pkg_fun = framework::template_Rmd,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create template_R-function
      framework::dput_function(
        pkg_fun = framework::template_R,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create write_dataframe-function
      framework::dput_function(
        pkg_fun = framework::write_dataframe,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create instructions-function
      framework::dput_function(
        pkg_fun = framework::instructions,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create specify_instructions-function
      framework::dput_function(
        pkg_fun = framework::specify_instructions,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create execute_instructions-function
      framework::dput_function(
        pkg_fun = framework::execute_instructions,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create prepare_website-function
      framework::dput_function(
        pkg_fun = framework::prepare_website,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create write_index_Rmd-function
      framework::dput_function(
        pkg_fun = framework::write_index_Rmd,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create write_yaml-function
      framework::dput_function(
        pkg_fun = framework::write_yaml,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
    #### create make.R ####
    if(file.exists("make.R") == FALSE){
      cat("############ make-like file ############ 

# see 'how-to-guide.txt' for a short introduction
# visit https://github.com/sachserf/framework for further information

############ PREAMBLE ############   
# detach localfun
if('localfun' %in% search() == TRUE) {
  detach(localfun)
}

# clear Global environment
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))

# initialize new environment: <<localfun>>
localfun <- new.env(parent = .GlobalEnv)

# source every R-file within directory <<in/fun>> 
# and assign them to the environment <<localfun>>
sapply(list.files(
  'in/fun',
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
pkg_install(c('rmarkdown', 
              'knitr', 
              'packrat', 
              'tidyr',
              'readr'), 
            attach = FALSE)

# install and load packages:
pkg_install(c('dplyr', 
              'ggplot2'
              'stringi'), 
            attach = TRUE)

############ SOURCE ############ 

# fill in R/Rmd-files in chronological order
instructions(input_R = c('in/src/load.R', 
                          'in/src/report.Rmd'), 
             spin_index = 'all', 
             cache_index = 'all')

execute_instructions() # don´t edit

############ SUPPLEMENT ############   

# save all data frames (within .GlobalEnv)
write_dataframe(file_format = 'csv')

# write session_info
session_info()

# backup (optionally change target directory and excluded files/dir)
backup(exclude_directories = 'packrat|.git|in/data|out|.cache',
       exclude_files = '*.RData|*.Rhistory')

# print reminder to console
reminder()

", file = 'make.R')
    } else {
      warning("make.R already exists")
    }
    
    #### write template_Rmd ####
    framework::template_R(file = 'in/src/load.R')
    framework::template_Rmd(file = 'in/src/report.Rmd')

#### write README.md ####
cat('# Readme of the project: ',basename(getwd()),'\n\nThis project was created from **',Sys.info()['user'],'** at **',as.character(Sys.time()),'**\n\n## Outline\nGive an outline of your project.\n\n## To Do\nList your ideas.\n\n## Work Log\nWrite log entries.', file = 'README.md', sep = '')

#### write how-to-guide.txt ####
cat("
################### INTRODUCTION ###################

This project was build by using the R-package 'framework'.
See https://github.com/sachserf/framework for further information
Feel free to edit and redistribute the package 'framework'
Licensed under GPL-2 

###################  Why using a project-framework?  ################### 

### Save time
### Easy documentation of your project
### Standardized structure improves readability
### Easy-to-use Setup for collaboration and presentation
### Make your projects more reproducible

################### REQUIREMENTS ################### 

# required
- R (>= 3.2)
- RStudio (>=0.99.878)

# recommended
- latex
- git 
- packrat 
- pandoc 
- rmarkdown
- knitr 

################### QUICK HOW-TO ################### 

1. Write R-files or Rmd-files and place them into the directory 'in/src'.
2. Edit 'make.R': Add the path of the input files (R/Rmd) to the function 'instructions()'
3. source 'make.R' and browse through the output-directory

Save User-defined functions into 'in/fun'
--> All R-files within in/fun will be sourced automatically. 

Specify additional R-Packages within 'make.R' (not anywhere inside some scripts).

Document your code and edit README.md

Speed up your code: 
Choose the following options within the functions 'instructions()'
- use option spin_index = 0
- use option cache_index = 'all'

NOTES:
- If you want to automatically save all plots of your input R-Scripts set spin_index = 'all' (This will spin/render your R-Scripts).

User-specified output should be saved in the directory 'out/usr'

################### SOURCE MAKE.R ###################
There are several ways to source the makefile:
1. Type 'source('make.R')' into the console and press 'enter'.
2. Open the file 'make.R' and hit the button 'source' (within RStudio).
3. Go to the console and use the addin 'insert source make R' (go to 'Addins -->...'). Afterwards press 'enter'.
4. Just use the RStudio-Addin 'source make R'.
5. Specify a shortcut for the Addins: go to 'Tools' --> 'Modify Keyboard Shortcuts...' and search for source make R to specify your preferred keybinding

################### NOT-TO-DO LIST ###################

- Do not source another R-script within R-Scripts if you want to use the cache: Detection of changed files is not recursive (You can specify a subset of cached files)
- Do not use child-documents within Rmd-files while caching the document: Detection of changed files is not recursive (You can specify a subset of cached files)
- Do not change the working directory manually
- Do not edit files in the output directory 'out' (except of 'out/usr': the directory will be deleted and rebuild every time you source the file 'make.R' and all your changes will be lost. 
- Write 'source('make.R')' inside a script that should be sourced by 'make.R'

################### FILES AND DIRECTORIES ###################

The main directory of the project (working directory and top level for all relative file paths within the project) includes:

### the make-like file 'make.R':
This file is the heart of the project. By sourcing make.R the whole project will be executed. 
If you want to use additional packages place them into the makefile.
Fill in your single Rmd/R-files into the 'instructions'-function (chronological order!)

### A hidden cache directory: 
Don´t edit the files within the cache directory. If you want to source everything from scratch just delete the whole cache-dir by using the option 'cache_index = 0' (file: 'make.R' function: 'instructions') 

### An input directory 'in':
This is the place for every file you want to include. Place your files according to the subdirectories (src = source files, fun = self-written functions, data = ...for your data). You can use subdirectories according to your preferences.

### An output-directory 'out':
All but the 'usr' subdirectories will be deleted and rebuild every time you source 'make.R' and should be treated as read-only! User-specific output should only be saved in out/usr!

Beware:
When saving user-specified output you should be aware that rendered documents change the working directory temporarily. This is also true for spinned R-files, but not if they´re sourced. Therefore it could be necessary to include '../' for each directory level of the file.

Example: You want to store a specific object as a rds-file (the underlying script is placed in 'in/src/myfile.R = two subdirectories of the top-level of the project):

sourced R-script: 
saveRDS(object = myobject, file = 'out/usr/myobject.rds')

spinned R-script or Rmd-file: 
saveRDS(object = myobject, file = '../../out/usr/myobject.rds')

### Potentially the main directory further includes:
- A Backup of your project (or just the most important files)
- a git repository as well as a .gitignore
- a packrat repository
- Default R-image and history (.RData & .Rhistory) - depending on your preferences.
- An Rstudio project-file '*.Rproj'
- This how-to-guide
- A README.md (and eventually a rendered html-version): Be aware that the html-version is not being rendered automatically when you source the makefile!
- An automatically updated session_info.txt

################### Benefits of a framework-project ###################

### Backup your project on-the-fly (eg if Dropbox is installed on your machine you can save important files directly into your Dropbox - and of course optionally exclude results and data). If you do so consider the usage of an encrypted file system.

### Review the steps of your analysis by using automatically generated notebooks/reports (eg html or pdf-files).

### Use a cache-directory to speed up CPU-intensive analysis. Scripts will only being sourced if you change the order of the input-files (within make.R) or change the input-file itself. If an input file will be sourced/rendered all subsequent files will be sourced/rendered as well!

### If your Code breaks see the sessionInfo.txt for information about the last session that worked properly. Additionally the backup is named with a timestamp and will be created only if there were no errors. When sourcing make.R a reminder (for git) will be printed to the console if there were no errors.

### Automatically save all dataframes within your global environment either as csv, rds or RData for fast exchange of data across projects or to export output-data in a human-readable format.

### Automatically save plots for all spinned R-files (e.g. use option spin_index = 'all') and of course Rmd-files in a single directory (with meaningful filenames).

################### TROUBLESHOOTING ################### 

- update knitr, rmarkdown, RStudio, and R to the most recent version.
- contact the maintainer

", file='how-to-guide.txt')

  }



