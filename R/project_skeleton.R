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
    # create directory <<data/raw>>
    if(dir.exists("data/raw") == FALSE){
      dir.create("data/raw")
    } else {
      warning("data/raw (directory) already exists")
    }
    # create directory <<data/modified>>
    if(dir.exists("data/modified") == FALSE){
      dir.create("data/modified")
    } else {
      warning("data/modified (directory) already exists")
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
# clear workspace
rm(list = ls())
          
# source functions placed in directory <<functions>>:
.file.sources <- list.files('functions', pattern='*.R$', full.names=TRUE, ignore.case=TRUE)
sapply(.file.sources, source, .GlobalEnv)
        
# install packages without loading:
.packfun(c('plyr', 'knitr', 'rmarkdown'), NAMESPACE_only = TRUE)
          
# install and load packages:
.packfun(c('dplyr', 'ggplot2', 'stringi'))
          
# source files:
source('scripts/load.R')
source('scripts/clean.R')    #...
          
# last line:
.session_info()
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

