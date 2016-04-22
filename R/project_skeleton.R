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
                        'stringi',
                        'devtools'), 
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

# delete out/auto
unlink('out/auto', recursive = TRUE)        

", file = 'in/R/sachserf_framework/preamble.R', sep = '\n')
      
      #### write supplement ####
      cat("############ SUPPLEMENT ############   

# render Rmd-documents
local_fun$render_Rmd()
          
# compile notebooks
local_fun$make_notebook()
          
# create website 
source('in/R/sachserf_framework/render_website.R')
          
# save all data frames (within .GlobalEnv)
local_fun$write_dataframe(file_format = 'csv')
          
# write session_info
local_fun$session_info()
          
# backup (optionally change target directory)
local_fun$backup(exclude_directories = '.git|in/data|out|.cache',
                 exclude_files = '*.RData|*.Rhistory')

", file = 'in/R/sachserf_framework/supplement.R')
      
      #### write render website ####
render_website <- function() {

# copy directory cache/notebooks for website building
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
c(cat("name: \'", basename(getwd()),"\'
output_dir: \'../../out/auto/documents/website\'
navbar:
  title: \'", basename(getwd()), "\'
  left:
", sep =''), print_lines(), cat("output:
  html_document:
    theme: cosmo
    highlight: textmate
"))
sink()
          
cat("# This website is a collection of compiled notebooks of the project: \"`r basename(dirname(dirname(getwd())))`\". 
          
Compiled at `r Sys.time()`
          
The following files have been compiled:
          
`r list.files('.cache/website', pattern = 'Rmd')`
          
```{r, echo = FALSE}
list.files(pattern = 'Rmd')
devtools::session_info()
```

", file = '.cache/website/index.Rmd')

# render website
rmarkdown::render_site(input = '.cache/website')
}

dump(list = 'render_website', file = 'in/R/sachserf_framework/render_website.R')
  }



