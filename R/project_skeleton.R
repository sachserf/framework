project_skeleton <-
  function(){
    # create directory <<results>>
    if(dir.exists("results") == FALSE){
      dir.create("results")
    } else {
      warning("results (directory) already exists")
    }
    # create directory <<results/plots>>
    if(dir.exists("results/plots") == FALSE){
      dir.create("results/plots")
    } else {
      warning("results/plots (directory) already exists")
    }
    # create directory <<results/data>>
    if(dir.exists("results/data") == FALSE){
      dir.create("results/data")
    } else {
      warning("results/data (directory) already exists")
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
    # create directory <<data/output/GlobalEnv>>
    if(dir.exists("data/output/GlobalEnv") == FALSE){
      dir.create("data/output/GlobalEnv")
    } else {
      warning("data/output/GlobalEnv (directory) already exists")
    }
    # create directory <<reports>>
    if(dir.exists("reports") == FALSE){
      dir.create("reports")
    } else {
      warning("reports (directory) already exists")
    }
    # create directory <<reports/Rmd_pdf>>
    if(dir.exists("reports/Rmd_pdf") == FALSE){
      dir.create("reports/Rmd_pdf")
    } else {
      warning("reports/Rmd_pdf (directory) already exists")
    }
    # create directory <<reports/Rmd_pdf/preamble>>
    if(dir.exists("reports/Rmd_pdf/preamble") == FALSE){
      dir.create("reports/Rmd_pdf/preamble")
    } else {
      warning("reports/Rmd_pdf/preamble (directory) already exists")
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
      cat(".packfun <- function(packlist = ..., NAMESPACE_only = FALSE){
          exist_pack <- packlist %in% rownames(installed.packages())
          if(any(!exist_pack)) install.packages(packlist[!exist_pack])
          if(NAMESPACE_only == FALSE) lapply(packlist, library, character.only = TRUE)
    }")
sink()
  } else {
    warning("packfun (function) already exists")
  }
    # create write_dataframe-function
    if(file.exists("functions/write_dataframe.R") == FALSE){
      sink("functions/write_dataframe.R")
      cat(".write_dataframe <- function(listofdf = 'GlobalEnv', output_dir =  'standard', file_format = 'rds') {
  if(listofdf == 'GlobalEnv') {
          listofdf <- names(which(sapply(.GlobalEnv, is.data.frame) == TRUE))
    }
          if(output_dir == 'standard') {
          output_dir <- file.path(getwd(), '/data/output/')
          }
          if(dir.exists(output_dir) == FALSE) {
          dir.create(output_dir, recursive = TRUE)
          }
          if(file_format == 'csv') {
          csv_fun <- function(...){
          data_path <- file.path(output_dir, ...)
          data_path_extension <- paste(data_path, '.csv', sep = '')
          write.table(get(...), data_path_extension, sep = ';', row.names = FALSE)
          }
          lapply(X = listofdf, FUN = csv_fun)
          }
          if(file_format == 'rds') {
          rds_fun <- function(...){
          data_path <- file.path(output_dir, ...)
          data_path_extension <- paste(data_path, '.rds', sep = '')
          saveRDS(object = get(...), file = data_path_extension)
          }
          lapply(X = listofdf, FUN = rds_fun)
          }
  }
          ")
      sink()
    } else {
      warning("write_dataframe (function) already exists")
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
        warning("session_info (function) already exists")
      }
    # create backup-function
    if(file.exists("functions/backup.R") == FALSE){
      sink("functions/backup.R")
      cat(".backup <-
  function(target_dir = 'project_subdir', source_dir = file.path(getwd()), overwrite = FALSE){
          projname <- paste('BACKUP_', unlist(strsplit(source_dir, split = '/'))[length(unlist(strsplit(source_dir, split = '/')))], sep = '')
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
    }
          ")
      sink()
    } else {
      warning("backup (function) already exists")
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
      warning("README (.txt) already exists")
    }
    # create make.R
    if(file.exists("make.R") == FALSE){
      sink("make.R")
      cat("# make-like file

############ PREAMBLE ############   

# clear workspace
rm(list = ls())
          
# source functions placed in directory <<functions>>:
.file.sources <- list.files('functions', pattern='*.R$', full.names=TRUE, ignore.case=TRUE)
sapply(.file.sources, source, .GlobalEnv)

############ PACKAGES ############   

# install packages without loading:
.packfun(c('plyr', 'knitr', 'rmarkdown'), NAMESPACE_only = TRUE)
          
# install and load packages:
.packfun(c('dplyr', 'ggplot2', 'stringi'))
          
############ SOURCE ############ 

source('scripts/load.R')
source('scripts/clean.R')    #...

############ BACKUP ############   

# save all data frames (within .GlobalEnv) as rds (optionally csv)
.write_dataframe()

# write session_info
.session_info()

# backup the whole project directory
# optionally change target directory (eg server-connection or cloud-service)
.backup()
          ")
      sink()
    } else {
      warning("make.R already exists")
    }
    # create report.Rmd
    if(file.exists("reports/Rmd_pdf/report.Rmd") == FALSE){
      sink("reports/Rmd_pdf/report.Rmd")
      cat("--- 
output: 
  pdf_document:
    fig_caption: yes
    includes:  
      in_header: preamble/preamble_latex.tex
      before_body: preamble/title_page.tex
#      after_body: preamble/supplement.tex
#bibliography: preamble/references.bib
#csl: preamble/custom_csl.csl
---

```{r on-the-fly, include = FALSE, eval = FALSE}
# copy-paste this line into console for rendering this document on-the-fly
knitr::knit_watch(knitr::current_input(dir = TRUE), rmarkdown::render)
```
          
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```
          
```{r, message = FALSE}
source('../../make.R', chdir = TRUE)
```

\\tableofcontents
\\listoffigures
\\listoftables

\\newpage
# Definitions {.unnumbered}

Define me 1
~ Definition of Define me 1 

Define me 2
~ Definition of Define me 2

# Abbreviations {.unnumbered}

Abbreviation 1
~ Definition of Abbreviation 1

Abbreviation 2
~ Definition of Abbreviation 2

\\newpage
\\pagenumbering{arabic}

# Introduction

# Material and Methods

# Results

## Example of a plot

```{r, fig.cap = 'This is a caption.'}
data(iris)
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point(aes(color = Species))
```

## Example of a table

```{r}
iris %>%
  select(Sepal.Width, Sepal.Length) %>%
  head() %>%
  knitr::kable(caption = 'This is a caption.')
```

# Discussion

# References

```{r bib, include=FALSE}
# KEEP THIS AT THE END OF THE DOCUMENT TO GENERATE A LOCAL bib FILE FOR PKGS USED
knitr::write_bib(sub('^package:', '', grep('package', search(), value=TRUE)), file='used_packages.bib')
```
          ")
      sink()
    } else {
      warning("report.Rmd (Rmd_pdf) already exists")
    }
    # create preamble_latex.tex
    if(file.exists("reports/Rmd_pdf/preamble/preamble_latex.tex") == FALSE){
      sink("reports/Rmd_pdf/preamble/preamble_latex.tex")
      cat("\\pagenumbering{gobble}
%\\usepackage[ngerman]{babel}
\\usepackage{float}
\\let\\origfigure\\figure
\\let\\endorigfigure\\endfigure
\\renewenvironment{figure}[1][2] {
  \\expandafter\\origfigure\\expandafter[H]
} {
  \\endorigfigure
}")
      sink()
    } else {
      warning("preamble_latex.tex (Rmd_pdf/preamble) already exists")
    }
    # create title_page.tex
    if(file.exists("reports/Rmd_pdf/preamble/title_page.tex") == FALSE){
      sink("reports/Rmd_pdf/preamble/title_page.tex")
      cat("
          \\begin{titlepage}
\\newcommand*{\\titleTH}{\\begingroup % Create the command for including the title page in the document
          \\raggedleft % Right-align all text
          \\vspace*{\\baselineskip} % Whitespace at the top of the page
          
          {\\Large Author}\\\\[0.167\\textheight] % Author name
          
          {\\LARGE\\bfseries This is a title}\\\\[\\baselineskip] % First part of the title, if it is unimportant consider making the font size smaller to accentuate the main title
          
          \\parbox[b]{0.57\\textwidth}{{ \\Large \\textit{this is a Subtitle}}\\par} % Tagline or further description
          
          \\vfill % Whitespace between the title block and the publisher
          
          
          
          {\\large Your University}\\par % Affiliation
          {\\large \\raggedright \\today}
          
          \\vspace*{3\\baselineskip} % Whitespace at the bottom of the page
          \\endgroup}
          
          \\pagestyle{empty} % Removes page numbers
          
          \\titleTH % This command includes the title page
          \\end{titlepage}
          ")
      sink()
    } else {
      warning("title_page.tex (Rmd_pdf/preamble) already exists")
    }
  }

