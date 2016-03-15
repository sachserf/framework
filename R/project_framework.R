project_framework <-
  function(){
    # create directory <<results>>
    if(dir.exists("results") == FALSE){
      dir.create("results")
    } else {
      warning("results (directory) already exists")
    }
    # create directory <<data>>
    if(dir.exists("data") == FALSE){
      dir.create("data")
    } else {
      warning("data (directory) already exists")
    }
    # create directory <<data/input>>
    if(dir.exists("data/input") == FALSE){
      dir.create("data/input")
    } else {
      warning("data/input (directory) already exists")
    }
    # create directory <<data/output>>
    if(dir.exists("data/output") == FALSE){
      dir.create("data/output")
    } else {
      warning("data/output (directory) already exists")
    }
    # create directory <<reports>>
    if(dir.exists("reports") == FALSE){
      dir.create("reports")
    } else {
      warning("reports (directory) already exists")
    }
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
    # create packfun-function
    if(file.exists("functions/packfun.R") == FALSE){
      sink("functions/packfun.R")
      cat(".packfun <- function(packlist = ..., load = TRUE){
          exist_pack <- packlist %in% rownames(installed.packages())
          if(any(!exist_pack)) install.packages(packlist[!exist_pack])
          if(load == TRUE) lapply(packlist, library, character.only = TRUE)
    }")
sink()
  } else {
    warning("packfun already exists")
  }
    # create SessionInfo-function
    if(file.exists("functions/session_info.R") == FALSE){
      sink("functions/session_info.R")
      cat(".session_info <- function(file = 'info/session_info.txt'){
          sink(file)
          print(Sys.time())
          print(sessionInfo())
          sink()
    }")
      sink()
      } else {
        warning("session_info already exists")
    }
    # create directory <<info>>
    if(dir.exists("info") == FALSE){
      dir.create("info")
    } else {
      warning("info (directory) already exists")
    }
    # create README.txt
    if(file.exists("info/README.txt") == FALSE){
      sink("info/README.txt")
      cat("PROJECT DESCRIPTION: \n\nDATA MANUAL: \n\nCOMMENTS:")
      sink()
    } else {
      warning("README already exists")
    }
    # create make.R
    if(file.exists("make.R") == FALSE){
      sink("make.R")
      cat("# make-like file
          # clear workspace
          rm(list = ls())
          
          # source functions placed in directory <<functions>>:
          .file.sources <- list.files('functions', pattern='*.R$', full.names=TRUE, ignore.case=TRUE)
          sapply(.file.sources, source, .GlobalEnv)
          
          # install packages without loading:
          .packfun(c('plyr'), load = FALSE)
          
          # install and load packages:
          .packfun(c('dplyr', 'ggplot2'))
          
          # source files:
          source('scripts/load.R')
          source('scripts/clean.R')    #...
          
          # last line:
          .session_info()")
      sink()
    } else {
      warning("make.R already exists")
    }
    # create report.Rmd
    if(file.exists("reports/report.Rmd") == FALSE){
      sink("reports/report.Rmd")
      cat("--- 
title: 'The Title'
subtitle: |
  | The Subtitle with 
  | a second line
author: |
  | First Author^1^, Second Author^2^
  | 1. university of somewhere
  | 2. another affiliation
date: \"`r format(Sys.time(), '%d %B %Y')`\"
header-includes:
  - \\usepackage[ngerman]{babel}
  - \\pagenumbering{gobble}
abstract: |
  this is the abstract
output: 
  pdf_document:
    toc: yes
    number_sections: yes
#bibliography: references.bib
---
          
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```
          
```{r, message = FALSE}
source('../make.R', chdir = TRUE)
library(knitr)
```

\\newpage
\\pagenumbering{arabic}")
      sink()
    } else {
      warning("report.Rmd already exists")
    }
    }
