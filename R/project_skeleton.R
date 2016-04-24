project_skeleton <-
  function(){
    #### create basic directories ####
    basic_dirs <- list('in/data', 'in/R/sachserf_framework', 'in/fun/sachserf_framework', 'in/docs', 'out/usr')
    lapply(X = basic_dirs, FUN = dir.create, recursive = TRUE)
    
    #### create files ####
    # create load.R
      cat("# load data", file = "in/R/load.R")
    # create clean.R
      cat("# clean data", file = "in/R/clean.R")
    
      #### create fun ####
      # create backup-function
      framework::dput_function(
        pkg_fun = framework::backup,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create compile_notebooks-function
      framework::dput_function(
        pkg_fun = framework::compile_notebooks,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create make_notebook-function
      framework::dput_function(
        pkg_fun = framework::make_notebook,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create make_source-function
      framework::dput_function(
        pkg_fun = framework::make_source,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create pkg_install-function
      framework::dput_function(
        pkg_fun = framework::pkg_install,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create prepare_cache-function
      framework::dput_function(
        pkg_fun = framework::prepare_cache,
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
      # create source_n_save-function
      framework::dput_function(
        pkg_fun = framework::source_n_save,
        target_dir = 'in/fun/sachserf_framework',
        substitute_framework = TRUE
      )
      # create source_or_load-function
      framework::dput_function(
        pkg_fun = framework::source_or_load,
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
      
    #### create make.R ####
    if(file.exists("make.R") == FALSE){
      cat("############ make-like file ############ 

# read README.txt for a short introduction
# see https://github.com/sachserf/framework for further information

############ PREAMBLE ############   

source('in/R/sachserf_framework/preamble.R')

############ PACKAGES ############   

# install packages without loading:
local_fun$pkg_install(c('rmarkdown', 
                        'knitr', 
                        'packrat', 
                        'plyr', 
                        'stringi'), 
                      attach = FALSE)

# install and load packages:
local_fun$pkg_install(c('dplyr', 
                        'ggplot2'), 
                      attach = TRUE)

############ SOURCE ############ 

# fill in your R-scripts in chronological order
local_fun$make_source(c('in/R/load.R',
                        'in/R/clean.R'),
                      use_cache = TRUE)

############ SUPPLEMENT ############   

source('in/R/sachserf_framework/supplement.R')

local_fun$reminder()
", file = 'make.R')
    } else {
      warning("make.R already exists")
    }
    
    #### write template_Rmd ####
    framework::template_Rmd(file = 'in/docs/manual.Rmd')
    
    #### write preamble ####
    cat("# clear Global environment
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))

# create new environment for local fun
local_fun <- new.env(parent = .GlobalEnv)

# list R-files placed in directory <<in/fun>>:
local_fun$list_local_fun <-
  list.files(
    'in/fun',
    pattern = '*.R$',
    full.names = TRUE,
    recursive = TRUE
  )

# source every R-file within directory <<in/fun>> 
sapply(local_fun$list_local_fun, 
       source, local = local_fun)

# rm list of fun
rm(list_local_fun, envir = local_fun)

", file = 'in/R/sachserf_framework/preamble.R', sep = '\n')
      
      #### write supplement ####
      cat("############ SUPPLEMENT ############   

# delete out/auto
unlink('out/auto', recursive = TRUE)  

# render Rmd-documents
local_fun$render_Rmd()

# compile notebooks
local_fun$make_notebook()

# buils website (experimental!! - delete these lines, 
# if you don´t need a website of your input scripts)
source('in/R/sachserf_framework/build_website.R')

# save all data frames (within .GlobalEnv)
local_fun$write_dataframe(file_format = 'csv')

# write session_info
local_fun$session_info()

# backup (optionally change target directory)
local_fun$backup(exclude_directories = '.git|in/data|out|.cache',
                 exclude_files = '*.RData|*.Rhistory')

", file = 'in/R/sachserf_framework/supplement.R')
      
      #### write build_website ####
      cat("# copy directory cache/notebooks for website building
          if (dir.exists('.cache/website') == TRUE) {
          unlink('.cache/website', recursive = TRUE)
          }
          dir.create('.cache/website/figure', recursive = TRUE)
          
          source_rmd <- list.files(path = '.cache/notebooks', pattern = '.Rmd', full.names = TRUE)
          target_rmd <- file.path('.cache/website', list.files(path = '.cache/notebooks', pattern = '.Rmd'))
          
          file.copy(from = source_rmd, to = target_rmd)
          
          # paste0('.cache/website/figure/', basename(list.files('.cache/notebooks/figure')))
          # list.files('.cache/notebooks/figure')
          if (dir.exists('.cache/notebooks/figure')) {
          file.copy(from = '.cache/notebooks/figure', to = '.cache/website', recursive = TRUE)
          }
          
          # get list of all files that are being sourced (even if they are not stitched)
          # necessary for order
          html_files <- c(basename(readRDS('.cache/df_cache_R.rds')$notebooks_cache_html))
          # replace html with Rmd 
          Rmd_files <- gsub(pattern = 'html', replacement = 'Rmd', x = html_files, ignore.case = TRUE)
          # list all files in cache (already stitched)
          list_files <- list.files(path = '.cache/website', pattern = '.Rmd')
          # remove files that where not stitched
          rf <- Rmd_files[Rmd_files %in% list_files]
          # include index (precondition for websites)
          rf <- c('index.Rmd', rf)
          # replace Rmd with html
          hf <- gsub(pattern = 'Rmd', replacement = 'html', x = rf)
          # remove extension
          ne <- gsub(pattern = '.Rmd', replacement = '', x = rf)
          # write lines needed for yaml-file
          print_lines <- function() {
          for (i in seq_along(ne)) {
          cat('    - text: ', '\'', ne[i], '\'', '\n', '      href: ', hf[i], '\n', sep = '')
          }
          }
          
          # write yaml file
          sink('.cache/website/_site.yml')
          c(cat('name: \'', basename(getwd()),'\'
          output_dir: \'../../out/auto/docs/website\'
          navbar:
          title: \', basename(getwd()), '\'
          left:
          '', sep =''), print_lines(), cat('output:
          html_document:
          theme: cosmo
          highlight: textmate
          ''))
          sink()
          
          cat('# This website is a collection of compiled notebooks of the project: \"`r basename(dirname(dirname(getwd())))`\". 
          
          Compiled at `r Sys.time()`
          
          The following files have been compiled:
          
          `r list.files('.cache/website', pattern = 'Rmd')`
          
          ```{r, echo = FALSE}
          list.files(pattern = 'Rmd')
          if ('devtools' %in% installed.packages() == TRUE) {
          devtools::session_info()
          } else {
          sessionInfo()
          }
          ```
          
          ', file = '.cache/website/index.Rmd')
# render website
rmarkdown::render_site(input = '.cache/website')
", file = 'in/R/sachserf_framework/build_website.R')
  
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

User-defined functions:
1. Write your own functions and save them into 'in/fun'
--> By doing so your function will be sourced within a new environment named 'local_fun'
2. call the function within your project by specifying the environment
- e.g. local_fun$myfunction()

Speed up your code:
- When you don´t need the output directory and backups (e.g. while working on the project) you should put the supplement inside a comment.

################### FILES AND DIRECTORIES ###################

The 'base-directory' aka 'control-level'
includes:

### the make-like file 'make.R':
This file is the heart of the project. By sourcing make.R the whole project will be executed. 
If you want to use additional packages place them into the makefile.
Fill in your single code snippets/R-files into the make_source function (chronological order!)

### The current working directory (Don´t change the working directory manually)

### An input directory 'in':
This is the place for every file you want to include. Place your files according to the subdirectories (R = normal R scripts, docs = Rmd-files etc., fun = self-written functions, data = ...for your data)

### An output-directory 'out':
There are two subdirectories called 'auto' and 'usr'. 
If you want to save plots, results etc. manually you should always use the path 'out/usr'.
The subdir 'auto' will be deleted and rebuild every time you source 'make.R' and should be treated as read-only!

### A hidden cache directory: 
Don´t edit the files within the cache directory. If you want to source everything from scratch just delete the whole cache-dir by using the option 'use_cache = FALSE' (file: 'make.R' function: 'source_make') 

### Optionally your main directory includes:

### A Backup of your project (or just the most important files)

### a git repository as well as a .gitignore (hidden)

### a packrat repository

### Default R-image and history (.RData & .Rhistory) - depending on your preferences.

### An Rstudio project-file '*.Rproj'

### This README


################### Background jobs of make.R ###################

### Backup your project on-the-fly (eg if Dropbox is installed on your machine you can save important files directly into your Dropbox - and of course exclude results and data)

### Review the steps of your analysis by using automatically generated notebooks or a website.

### Write Reports by using RMarkdown. Every Rmd-file within the directory input/documents will be rendered automatically. Include the first two chunks of the template 'manual.Rmd' in every Rmd-file (Autogenerated when using the function 'template_Rmd'). 
The prewritten file 'manual.Rmd' should serve as a template for documentation of YOUR project. 

### Use a cache-directory to speed up CPU-intensive analysis. Scripts will only being sourced if you change the order of the input-files (within make.R) or change the input-file itself. 

### If your Code will break see out/auto/docs/info/sessionInfo.txt for information about the last session that worked properly. Additionally the backup is named with a timestamp and will be created only if there were no errors. When sourcing make.R a reminder (for git) will be printed to the console if there were no errors.

### Automatically save all dataframes within your global environment either as csv, rds or RData for fast exchange of data across projects or to export output-data in a human-readable format.

### Automatically save plots. If you create a plot within a R-script you will find a png-file with coarse resolution inside the directory out/auto/figures/notebooks. Including plots inside a Rmd-file will produce a better quality: See out/auto/figures/docs

################### TROUBLESHOOTING ################### 

- update knitr, rmarkdown, RStudio, and R to the most recent version.
- specify the option use_cache = FALSE
- put the supplement of the make file in a comment (simply write a preceding '#')

", file='README.txt')

  }



