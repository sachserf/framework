template_Rmd <- function(file, Author = 'Your Name', Date = '2016-04-17') {
  # create directory
  if (dir.exists(paths = dirname(file)) == FALSE) {
    dir.create(path = dirname(file), recursive = TRUE)
  }
  # process input for names
  split_elements <- strsplit(file, split = '/')
  last_element <- lapply(split_elements, `[[`, 3)
  header <- substr(x = last_element, start = 1, stop = nchar(last_element)-4)
  # process input for directories
  nr_subdir <- nchar(file) - nchar(gsub(pattern = '/', replacement = '', x = file))
  paste_nr_subdir <- paste(rep('..', nr_subdir), collapse = '/')

      if (file.exists(file) == TRUE) {
      warning('File exists.')
    } else {
    
  cat(
    "---
title: '",header,"'
author: '",Author,"'
date: '",Date,"'
output: 
  html_document: 
    number_sections: yes
    toc: yes
    toc_float: yes
    theme: united
    highlight: tango
---
    
```{r setup, include=FALSE}
# Copy the first and the second chunk to every .Rmd-file or use the function 'template_Rmd'.
# Edit the file path of this chunk 'setup' if you want to use additional subdirectories (for input AND output) 

# set knitr options
knitr::opts_knit$set(root.dir  = '",paste_nr_subdir,"')
  
# set chunk options
knitr::opts_chunk$set(echo = FALSE, fig.path = '",paste_nr_subdir,"/output/auto/figures/documents/')
```
    
```{r source_make, include=FALSE}
# read make.R
makefile <- readLines('make.R') 
# exclude some lines from make.R
make_trimmed <- makefile[grep('## PREAMBLE ##', makefile) : grep('## RENDER ##', makefile) - 1]
# write new file 'ghost_file.R'
cat(make_trimmed, sep = '\n', file = 'ghost_file.R') 
# source 'ghost_file.R'
source(file = 'ghost_file.R', chdir = TRUE)
# delete 'ghost_file.R'
unlink('ghost_file.R', recursive = TRUE)
# clean workspace
rm(makefile, make_trimmed)
```
    
# Project Description
    
## load.R

## clean.R
    
# Data Manual
    
## data 1
    
## data 2
    
",
    file = file, sep = ''
  )

    
  }
}

