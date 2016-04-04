# framework
this package provides functions to standardize the structure of R-projects. Furthermore it is straightforward to make backups of directories (e.g. the project folder) or files in a standardized way (possibly interesting for file transfer, collaboration and backups). The functions should support the reproducibility of projects. The main function 'project_framework' (see below) is a wrapper for all other functions within the package. Once a project is created this way the package is not needed for proper performance of the project and can be passed on to colleagues that do not use the package itself (therefore some functions are being written into a subdirectory within each project).

## Requirements
On windows machines you will need 'Rtools' (Xcode command line tools on Mac).

## Installation
devtools::install_github("sachserf/framework")

## Installation notes
For some linux-distributions you need to specify 'options(unzip='internal')' before installing the package.

## optional software for complete range of functions
- git
- pandoc
- knitr
- rmarkdown
- latex (e.g. texlive - Linux, MacTex - Mac OS, MiKTex - Windows)

### project_framework()
The idea is to provide a standardized and easy-to-use framework for R-projects (including a .Rproj-file, a git repository, basic directories and a report template). After running project_framework() you can write scripts and functions and place them into the corresponding directories. The framework should enhance the readability as well as reproducibility of your projects. The make-like file 'make.R' automatically sources all files within the directory 'functions/'; scripts must be specified due to the correct order. A prewritten R-markdown report (template) should enhance the usage of reports. This file should not be included within the makefile but called separately (on the contrary the report sources the make-file). 

By using this framework it should be simple to keep your scripts short, clean and readable and write reproducible code and projects that can be passed on to colleagues.

![structure of the created files and directories by using project_framework()][1]





[1]: figures/structure.jpg "structure of the created files and directories by using project_framework()"