# framework
this package provides functions to standardize the structure of R-projects. Furthermore it is straightforward to save snapshots of folders (e.g. the project folder) or files in a standardized way (possibly interesting for file transfer and collaboration). The functions should support the reproducibility of projects.

## Installation
devtools::install_github("sachserf/framework")


### project_framework()
the following figure depicts the structure of the created files and directories by using project_framework().
The idea is to provide a standardized and easy-to-use framework for R-projects. After running project_framework() you can write scripts and functions and place them into the corresponding directories. The framework should enhance the readability as well as reproducibility of your projects. The make-like file 'make.R' automatically sources all files within the directory 'functions/'; scripts must be specified due to the correct order. The function does not replace an '.Rproj'-file. If you dont use an '.Rproj' you should include 'setwd()' within 'make.R'. The file 'report.Rmd' is a prewritten R-markdown file and should enhance the usage of reports. This file should not be included within the makefile but called separately (on the contrary the report sources the make-file).

By using this framework it should be simple to keep your scripts short, clean and readable.

![structure of the created files and directories by using project_framework()][1]





[1]: figures/structure.png "structure of the created files and directories by using project_framework()"