start_proj <-
  function(){
  # create directory <<scripts>>
  if(dir.exists("scripts") == FALSE){
    dir.create("scripts")
  } else {
    warning("scripts (directory) already exists")
  }
  # create load.R
  if(file.exists("scripts/load.R") == FALSE){
    sink("scripts/load.R")
    cat("# load data")
    sink()
  } else {
    warning("scripts/load.R already exists")
  }
  # create clean.R
  if(file.exists("scripts/clean.R") == FALSE){
    sink("scripts/clean.R")
    cat("# clean data")
    sink()
  } else {
    warning("scripts/clean.R already exists")
  }
  # create directory <<functions>>
  if(dir.exists("functions") == FALSE){
    dir.create("functions")
  } else {
    warning("functions (directory) already exists")
  }
  # create README.txt
  if(file.exists("README.txt") == FALSE){
    sink("README.txt")
    cat("PROJECT DESCRIPTION: \n\nDATA MANUAL: \n\nCOMMENTS:")
    sink()
  } else {
    warning("README already exists")
  }
  # create make.R
  if(file.exists("make.R") == FALSE){
    sink("make.R")
    cat("# make-like file
# define function
packfun <- function(packlist = ...){
     exist_pack <- packlist %in% rownames(installed.packages())
     if(any(!exist_pack)) install.packages(packlist[!exist_pack])
     lapply(packlist, library, character.only = TRUE)
}

# load packages:
packfun(c('devtools', 'ggplot2'))

# source functions placed in directory <<functions>>:
file.sources <- list.files('functions', pattern='*.R$', full.names=TRUE, ignore.case=TRUE)
sapply(file.sources, source, .GlobalEnv)

# source files:
source('scripts/load.R')
source('scripts/clean.R')    #...")
    sink()
    } else {
      warning("make.R already exists")
      }
}
