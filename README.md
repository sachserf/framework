# framework
this package provides functions to standardize the structure of R-projects. Furthermore it is straightforward to make backups of directories (e.g. the project directory). The project structure should support the reproducibility of projects. The main function 'project_framework' (see below) is a wrapper for all other functions within the package. Once a project is created this way the package itself is not needed for proper performance of the project and can be passed on to colleagues 'as is' (therefore some functions are being written into a subdirectory within each project).

# Setup

## Requirements for Installation
On windows machines you will need 'Rtools' (Xcode command line tools on Mac).

## Installation
devtools::install_github("sachserf/framework")

## Pre-Installation notes
- For some linux-distributions you need to specify 'options(unzip='internal')' before installing packages from github.

## Required software for complete range of functions
- R (>= 3.2)
- RStudio (testet under 0.99.878)
- rmarkdown 
- knitr 
- pandoc 
- git 
- packrat 

## Beware
by sourcing the make-like file 'as is' the following packages will be installed on your machine: dplyr, ggplot2, packrat, rmarkdown, knitr, plyr, tidyr, readr and stringi

## Post-Installation notes
- After installing the package there will be two new addins within RStudio. The addin 'insert source make R' will write the text ```source('make.R')``` at the location of the pointer, while the addin 'source make R' directly executes this command. For further information see below.

# Usage

## project_framework()
The idea is to provide a standardized and easy-to-use framework for R-projects (including a .Rproj-file, a git repository, a packrat repository (default = FALSE), basic directories and a report template). The base-directory of the project will be the working directory and represents the 'control-level'. By this I mean it includes the packrat repo, RStudio-project file, .git repo, the make-file, a hidden cache directory, optionally a backup directory and an input as well as an output directory. It is suggested to treat the output directory 'out' as 'read-only'. To ensure reproducibility the directory 'out' will be deleted (and rebuild) by default every time you run the make-file. User-defined output should be stored in 'out/usr'. The directory 'out/usr' is not going to be deleted automatically. 

After running project_framework() you are able to start writing scripts, functions and documentations immediately and place them into the corresponding directories. The framework should enhance the readability as well as reproducibility of your projects. There is a prewritten README.md at the top level of each project.

## The file 'make.R'
The make-like file 'make.R' should be the heart of your project. It should contain all information (ie commands) of your work in a logical order. Therefore it is needed to specify the (relative) path of each script (.R or .Rmd-file) you want to include (e.g. source it) and also every additional R-package you want to use. The benefit is that you only need to source this make-like file and everything else will be done automatically (for further info see section 'Output'). Everytime you source the make.R-file YOUR WHOLE PROJECT WILL BE PROCESSED. If there are files that did not change since the last run of course they won´t be compiled/sourced etc again. This is not true, if the order of he files have changed.
Thanks to the addin 'source make R' you can specify a shortcut to source the make.R-file (even without opening it). Mine is Strg+Shift+M.
By using this framework it should be simple to keep your scripts short, clean and readable and write reproducible code and projects that can be passed on to colleagues.

## Version control
If git is installed on your machine and you didn´t change the default option when calling project_framework() the following things will be executed: 

- initialize a git repo
- commit the whole project structure on branch master(if you accidentally delete the functions that are needed for proper functioning of the project this might be a benefit)
- checkout to a newly created branch 'devel'

# Output
- **All R and Rmd files will be rendered** to html/pdf/etc. If you compile R-scripts to html you might want to use Roxygen-commands for your comments and text. Thus you can use "normal" R-scripts with nicely rendered and formatted output.
- **All your Plots are being saved** within a single output-directory. You can easily specify the format (pdf, png, jpeg, etc) and the names of the files by using chunk-labels (and/or global chunk options).
- **All datasets within your global environment are being saved** as csv/RData/RDS.

# Project Workflow

The figure below depicts the workflow and main structure of a project. Every file should be placed in the directory 'in'. The make-file processes the input and creates out/auto (out/auto stands for several automatically created subdirectories within the directory 'out'). Using the cache is optionally. User-defined output should be placed in the directory out/usr.

![][1]

[1]: figures/project_workflow.png 

