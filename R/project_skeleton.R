project_skeleton <-
  function(){
    #### create basic directories ####
    basic_dirs <- list('input/data', 'input/R', 'input/functions/sachserf_framework', 'input/documents')
    lapply(X = basic_dirs, FUN = dir.create, recursive = TRUE)
    
    #### create files ####
    # create load.R
      cat("# load data", file = "input/R/load.R")
    # create clean.R
      cat("# clean data", file = "input/R/clean.R")
    
      #### create functions ####
    # create pkg_install-function
    framework::dput_function(
      pkg_fun = framework::pkg_install,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create compile_notebooks-function
    framework::dput_function(
      pkg_fun = framework::compile_notebooks,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create compile_or_copy_notebooks-function
    framework::dput_function(
      pkg_fun = framework::compile_or_copy_notebooks,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create make_notebook-function
    framework::dput_function(
      pkg_fun = framework::make_notebook,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create make_source-function
    framework::dput_function(
      pkg_fun = framework::make_source,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create prepare_cache-function
    framework::dput_function(
      pkg_fun = framework::prepare_cache,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create session_info-function
    framework::dput_function(
      pkg_fun = framework::session_info,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create source_n_save-function
    framework::dput_function(
      pkg_fun = framework::source_n_save,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create source_or_load-function
    framework::dput_function(
      pkg_fun = framework::source_or_load,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create template_Rmd-function
    framework::dput_function(
      pkg_fun = framework::template_Rmd,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create write_dataframe-function
    framework::dput_function(
      pkg_fun = framework::write_dataframe,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create backup-function
    framework::dput_function(
      pkg_fun = framework::backup,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create reminder-function
    framework::dput_function(
      pkg_fun = framework::reminder,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    # create render_Rmd-function
    framework::dput_function(
      pkg_fun = framework::render_Rmd,
      target_dir = 'input/functions/sachserf_framework',
      substitute_framework = TRUE
    )
    
    #### create make.R ####
    if(file.exists("make.R") == FALSE){
      cat("# make-like file

# read README.txt for a short introduction
# see https://github.com/sachserf/framework for further information

############ PREAMBLE ############   

source('input/R/preamble.R')

############ PACKAGES ############   

# install packages without loading:
.pkg_install(c('rmarkdown', 
               'knitr', 
               'packrat', 
               'plyr', 
               'stringi'), 
             attach = FALSE)

# install and load packages:
.pkg_install(c('dplyr', 
               'ggplot2'), 
             attach = TRUE)

############ SOURCE ############ 

# fill in your R-scripts in chronological order
make_source(wa = c('input/R/drei.R', 
                   'input/R/clean.R'),
            use_cache = TRUE)

############ RENDER ############

.render_documents()
make_notebook(input_R = 'all')

############ SUPPLEMENT ############   

# save all data frames (within .GlobalEnv)
.write_dataframe(file_format = 'csv')

# write session_info
.session_info()

# backup (optionally change target directory)
.backup(exclude_directories = '.git|input/data|output|cache',
        exclude_files = '*.RData|*.Rhistory')

.reminder()

", file = 'make.R')
    } else {
      warning("make.R already exists")
    }
    
    #### write template_Rmd ####
    framework::template_Rmd(file = 'input/documents/manual.Rmd')
    
    #### write preamble ####
    cat("# clear Global environment
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))
        
# create new environment for local functions
local_fun <- new.env(parent = .GlobalEnv)
        
# list R-files placed in directory <<input/functions>>:
local_fun$list_local_fun <-
list.files(
    'input/functions',
      pattern = '*.R$',
      full.names = TRUE,
      recursive = TRUE
    )
        
# source every R-file within directory <<input/functions>> 
sapply(local_fun$list_local_fun, 
       source, local = local_fun)
        
# rm list of functions
rm(list_local_fun, envir = local_fun)
        
", file = 'input/R/preamble.R', sep = '\n')
  }



