#' Create a framework-project skeleton
#' @description The function creates a predefined directory structure and some 
#'   files to enhance project organization.
#' @param custom_makeR Character. File path to a local make-like R-file. Specify
#'   this option if you want to use a customized version instead of the template
#'   for the file 'make.R'.
#' @return The output are several files and directories within your working 
#'   directory. The structure contains a how-to-guide.txt, README.md, 
#'   directories for input and output, some file-templates and several functions
#'   for proper functioning of the project.
#' @note There are no parameters to specify.
#' @note There is a wrapper-function to call this function. You might want to 
#'   use project_framework() instead.
#' @seealso \code{\link{project_framework}}
#' @author Frederik Sachser
#' @export
skeleton <-
  function(custom_makeR = NULL){
    #### create basic directories ####
    basic_dirs <- list('in/data', 'in/src', 'in/fun/sachserf_framework', 'out/usr')
    lapply(X = basic_dirs, FUN = dir.create, recursive = TRUE)

      #### create fun ####
      # create backup-function
      framework::dput_function(
        pkg_fun = framework::backup,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create pkg_install-function
      framework::dput_function(
        pkg_fun = framework::pkg_install,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create reminder-function
      framework::dput_function(
        pkg_fun = framework::reminder,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create session_info-function
      framework::dput_function(
        pkg_fun = framework::session_info,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create template_Rmd-function
      framework::dput_function(
        pkg_fun = framework::template_Rmd,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create template_R-function
      framework::dput_function(
        pkg_fun = framework::template_R,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create write_dataframe-function
      framework::dput_function(
        pkg_fun = framework::write_dataframe,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create instructions-function
      framework::dput_function(
        pkg_fun = framework::instructions,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create specify_instructions-function
      framework::dput_function(
        pkg_fun = framework::specify_instructions,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create execute_instructions-function
      framework::dput_function(
        pkg_fun = framework::execute_instructions,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
      # create prepare_website-function
      framework::dput_function(
        pkg_fun = framework::website,
        target_dir = 'in/fun/sachserf_framework',
        rm_pattern = 'framework::'
      )
    #### create make.R ####
    if (is.null(custom_makeR) == TRUE) {
      cat("############ make-like file ############ 

# see 'how-to-guide.txt' for a short introduction
# visit https://github.com/sachserf/framework for further information

############ PREAMBLE ############   
# detach localfun
if ('localfun' %in% search() == TRUE) {
  detach(localfun)
}

# clear Global environment
rm(list = ls(all.names = TRUE, envir = .GlobalEnv))

# initialize new environment: <<localfun>>
localfun <- new.env(parent = .GlobalEnv)

# source every R-file within directory <<in/fun>> 
# and assign them to the environment <<localfun>>
sapply(list.files(
  'in/fun',
  pattern = '*.R$',
  full.names = TRUE,
  recursive = TRUE
), source, local = localfun)

# attach the environment <<localfun>>
attach(localfun)

# remove the environment <<localfun>> from .GlobalEnv
rm(localfun)

############ PACKAGES ############   

# install packages without loading:
pkg_install(c('rmarkdown', 
              'knitr'), 
            attach = FALSE)

# install and load packages:
pkg_install(c('dplyr', 
              'ggplot2',
              'stringi',
              'tidyr',
              'readr'), 
            attach = TRUE)

############ SOURCE ############ 

# fill in R/Rmd-files in chronological order
instructions(input_src = c('in/src/load.R', 
                          'in/src/report.Rmd'), 
             spin_index = 'all', 
             cache_index = 'all')

execute_instructions() # do not edit

# Optionally render Rmd-files as a website
# website(Rmd_input = c('.cache/docs/load.spin.Rmd', 
#                        'in/src/report.Rmd'), 
#          target_dir = 'out/website')

############ SUPPLEMENT ############   

# save all data frames (within .GlobalEnv)
write_dataframe(file_format = 'csv')

# write session_info
session_info()

# backup (optionally change target directory and excluded files/dir)
backup(exclude_directories = 'packrat|.git|in/data|out|.cache',
       exclude_files = '*.RData|*.Rhistory', delete_target = TRUE)

# print reminder to console
reminder()

", file = 'make.R')
    } else {
      file.copy(from = custom_makeR, to = 'make.R', overwrite = FALSE)
    }
    
    #### write template_Rmd ####
    framework::template_R(file = 'in/src/load.R')
    framework::template_Rmd(file = 'in/src/report.Rmd')

  #### write README.md ####
  cat('# Readme of the project: ',basename(getwd()),'\n\nThis project was created from **',Sys.info()['user'],'** at **',as.character(Sys.time()),'**\n\n## Outline\nGive an outline of your project.\n\n## To Do\nList your ideas.\n\n## Work Log\nWrite log entries.', file = 'README.md', sep = '')

  #### write how-to-guide.md
  htm <- readLines(con = "https://raw.githubusercontent.com/sachserf/framework/vignettes/README.md")
  cat(htm, file = "how-to-guide.md", sep = "\n")
  }



