# framework
this package provides functions to standardize the structure of R-projects. Furthermore it is straightforward to make backups of directories (e.g. the project directory). The project structure should support the reproducibility of projects. The main function 'project_framework' (see below) is a wrapper for all other functions within the package. Once a project is created this way the package itself is not needed for proper performance of the project and can be passed on to colleagues 'as is' (therefore some functions are being written into a subdirectory within each project).

## Requirements for Installation
On windows machines you will need 'Rtools' (Xcode command line tools on Mac).

## Installation
devtools::install_github("sachserf/framework")

## Installation notes
For some linux-distributions you need to specify 'options(unzip='internal')' before installing packages from github.

## optional software for complete range of functions
- git
- rmarkdown
- RStudio
- knitr
- packrat

## Beware
by sourcing the make-like file 'as is' the following packages will be installed on your machine: dplyr, ggplot2, packrat, rmarkdown, knitr, plyr and stringi

### project_framework()
The idea is to provide a standardized and easy-to-use framework for R-projects (including a .Rproj-file, a git repository, a packrat repository (default = FALSE), basic directories and a report template). The base-directory of the project will be the working directory and represents the 'control-level'. By this I mean it includes the packrat repo, RStudio-project file, .git repo, the make-file, optionally a backup directory and an input as well as an output directory. It is suggested to treat the output directory as 'read-only'. To ensure reproducibility some directories (e.g. output/data) will be deleted by default every time you run the make-file.

After running project_framework() you are able to start writing scripts, functions and documentations immediately and place them into the corresponding directories. The framework should enhance the readability as well as reproducibility of your projects. The make-like file 'make.R' automatically sources all files within the directory 'input/functions/' (recursive); scripts must be specified due to the correct order. A prewritten R-markdown report (template) should enhance the usage of reports. When sourcing 'make.R' every Rmd-file within the directory 'input/documents' will be rendered automatically into the directory 'output/documents'. Additionally every R-script, that is specified in 'make.R' will be compiled to a notebook. 

By using this framework it should be simple to keep your scripts short, clean and readable and write reproducible code and projects that can be passed on to colleagues.

#### Before source('make.R')

![structure of the created files and directories before source('make.R')][1]

[1]: figures/before.jpg "structure of the created files and directories before source('make.R')"

#### After source('make.R')

![structure of the created files and directories after source('make.R')][2]

[2]: figures/after.jpg "structure of the created files and directories after source('make.R')"