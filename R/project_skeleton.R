skeleton <-
  function(){
    #### create basic directories ####
    basic_dirs <- list('in/data', 'in/R/sachserf_framework', 'in/fun/sachserf_framework', 'in/Rmd', 'out/usr')
    lapply(X = basic_dirs, FUN = dir.create, recursive = TRUE)
    
    #### create files ####
    # create load.R
      cat("#' # load data", file = "in/R/load.R")
    # create clean.R
      cat("#' # clean data", file = "in/R/clean.R")
    
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
      # create render_Rmd-function
      framework::dput_function(
        pkg_fun = framework::render_Rmd,
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

# read README.txt for a short introduction
# see https://github.com/sachserf/framework for further information

############ PREAMBLE ############   

source('in/R/sachserf_framework/preamble.R')

############ PACKAGES ############   

# install packages without loading:

pkg_install(c('rmarkdown', 
              'knitr', 
              'packrat', 
              'plyr', 
              'stringi'), 
            attach = FALSE)

# install and load packages:
pkg_install(c('dplyr', 
              'ggplot2'), 
            attach = TRUE)

############ SOURCE ############ 

# fill in your R-scripts in chronological order
instructions(input_R = c('in/R/load.R', 
                         'in/R/clean.R'), 
             spin_index = 'all', 
             use_cache = TRUE)

execute_instructions()

############ SUPPLEMENT ############   

source('in/R/sachserf_framework/supplement.R')

", file = 'make.R')
    } else {
      warning("make.R already exists")
    }
    
    #### write template_Rmd ####
    framework::template_Rmd(file = 'in/Rmd/manual.Rmd')
    
    #### write preamble ####
    cat("# clear Global environment
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))

# source every R-file within directory <<in/fun>> 
sapply(list.files(
  'in/fun',
  pattern = '*.R$',
  full.names = TRUE,
  recursive = TRUE
), source)

", file = 'in/R/sachserf_framework/preamble.R', sep = '\n')
      
      #### write supplement ####
      cat("############ SUPPLEMENT ############   

# render Rmd-documents
render_Rmd(source_dir = 'in/Rmd', target_dir = 'out/auto/docs/Rmd')

# render notebooks (website)
# if you want to use this feature you will need 
# to install the development version of rmarkdown 
# devtools::install_github('rstudio/rmarkdown')
prepare_website()
rmarkdown::render_site(input = '.cache/website')

# save all data frames (within .GlobalEnv)
write_dataframe(file_format = 'csv')

# write session_info
session_info()

# backup (optionally change target directory)
backup(exclude_directories = '.git|in/data|out|.cache',
       exclude_files = '*.RData|*.Rhistory')

reminder()

# rm build-in functions except of template_Rmd
local_fun <- gsub(pattern = '.R', replacement = '', list.files(path = 'in/fun/sachserf_framework'), fixed = TRUE)
rm(list = local_fun[!local_fun %in% 'template_Rmd'])
rm(local_fun)

", file = 'in/R/sachserf_framework/supplement.R')

#### write README.txt ####
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

################### Quick How-To ################### 

1. Write code or reports and place them into the appropriate input-directory.
2. Add the path of your snippets as well as additional R-packages into 'make.R'
3. source 'make.R' and browse through the output-directory

Save User-defined functions into 'in/fun'
--> All functions within in/fun will be sourced automatically

Speed up your code:
- use option use_cache = TRUE
- rule out the supplement
- use option spin = 0

NOTES:
- Do not edit or delete the headers in 'make.R'
- Save User-defined functions into 'in/fun':
  All R-files within in/fun will be sourced automatically

################### FILES AND DIRECTORIES ###################

The main directory of the project (top level for all relative file paths within the project) includes:

### the make-like file 'make.R':
This file is the heart of the project. By sourcing make.R the whole project will be executed. 
If you want to use additional packages place them into the makefile.
Fill in your single code snippets/R-files into the 'instructions'-function (chronological order!)
Don´t edit the headers!

### The current working directory (Don´t change the working directory manually)

### An input directory 'in':
This is the place for every file you want to include. Place your files according to the subdirectories (R = normal R scripts, Rmd = Rmd-files, fun = self-written functions, data = ...for your data)

### An output-directory 'out':
There are two subdirectories called 'auto' and 'usr'. 
If you want to save plots, results etc. manually you should always use the path 'out/usr'.
The subdir 'auto' will be deleted and rebuild every time you source 'make.R' and should be treated as read-only!

### A hidden cache directory: 
Don´t edit the files within the cache directory. If you want to source everything from scratch just delete the whole cache-dir by using the option 'use_cache = FALSE' (file: 'make.R' function: 'instructions') 

### Optionally your main directory includes:

### A Backup of your project (or just the most important files)

### a git repository as well as a .gitignore

### a packrat repository

### Default R-image and history (.RData & .Rhistory) - depending on your preferences.

### An Rstudio project-file '*.Rproj'

### This README


################### Background jobs of make.R ###################

### Backup your project on-the-fly (eg if Dropbox is installed on your machine you can save important files directly into your Dropbox - and of course exclude results and data). If you do so consider the usage of an encrypted file system.

### Review the steps of your analysis by using automatically generated notebooks (single html-files or a website).

### Write Reports by using RMarkdown. Every Rmd-file within the directory input/Rmd will be rendered automatically. Include the first two chunks of the template 'manual.Rmd' in every Rmd-file (Autogenerated when using the function 'template_Rmd'). 
The prewritten file 'manual.Rmd' should serve as a template for documentation of YOUR project. 

### Use a cache-directory to speed up CPU-intensive analysis. Scripts will only being sourced if you change the order of the input-files (within make.R) or change the input-file itself. 

### If your Code will break see out/auto/docs/info/sessionInfo.txt for information about the last session that worked properly. Additionally the backup is named with a timestamp and will be created only if there were no errors. When sourcing make.R a reminder (for git) will be printed to the console if there were no errors.

### Automatically save all dataframes within your global environment either as csv, rds or RData for fast exchange of data across projects or to export output-data in a human-readable format.

### Automatically save plots for spinned R-files (e.g. use option spin_index = 'all'): If you create a plot within a R-script you will find a png-file with coarse resolution inside the directory out/auto/figure/scriptname. Including plots inside a Rmd-file will produce a better quality: See out/auto/figure

################### TROUBLESHOOTING ################### 

- update knitr, rmarkdown, RStudio, and R to the most recent version.

", file='README.txt')

  }



