#' Prepare and render a local website
#'
#'@description The function will copy the Rmd_input, write a _site.yml and use 
#'  rmarkdown to render a website on your local machine. It is a wrapper for the
#'  function rmarkdown::render_site. The function should fasten the process of
#'  creating webpages by using a predefined template and layout.
#'@param Rmd_input Character. A vector of Rmd-Files, that should be parts of the
#'  website.
#'@param target_dir Character. Path to the output directory.
#'@param ... further options for the function rmarkdown::render_site
#'@note If there is no "index.Rmd" in input_Rmd a template will be used to
#'  create an index_Rmd-file.
#'@note Required Version of the package rmarkdown: v0.9.6
#'@return there will be two output directories: Rmd and html.
#'@references JJ Allaire, Joe Cheng, Yihui Xie, Jonathan McPherson, Winston
#'  Chang, Jeff Allen, Hadley Wickham, Aron Atkins and Rob Hyndman (2016).
#'  rmarkdown: Dynamic Documents for R. 
#'  R package version 1.0. 
#'  https://CRAN.R-project.org/package=rmarkdown
#' @author Frederik Sachser
#' @seealso \code{\link[rmarkdown]{render_site}}
#' @export
website <- 
  function(Rmd_input, target_dir, ...) 
  {
    # specify target directories
    target_Rmd <- file.path(target_dir, "Rmd")
    target_html <- file.path(target_dir, "html")
    # delete and create target directories
    if (dir.exists(target_Rmd) == TRUE) {
      unlink(target_Rmd, recursive = TRUE)
    }
    dir.create(target_Rmd, recursive = TRUE)
    if (dir.exists(target_html) == TRUE) {
      unlink(target_html, recursive = TRUE)
    }
    dir.create(target_html, recursive = TRUE)
    # copy original files to target_Rmd
    filename_target_Rmd <- file.path(target_Rmd, basename(Rmd_input))
    file.copy(from = Rmd_input, to = filename_target_Rmd, overwrite = TRUE)
    # write_index
    index_in_input <- grep(pattern = "index.Rmd", x = Rmd_input, ignore.case = TRUE)
    index_in_input <- isTRUE(index_in_input > 0)
    # specify target_index:
    target_index <- file.path(target_Rmd, "index.Rmd")
    # if index_in_input == FALSE: write index from template
    if (index_in_input == FALSE) {
      cat("# This website is a collection of compiled notebooks of the project: \"`r basename(dirname(dirname(getwd())))`\". \n            \n            Compiled at `r Sys.time()`\n            \n            The following files have been compiled: `r list.files(target_Rmd, pattern = 'Rmd')`\n            \n            ```{r, echo = FALSE}\n            list.files(pattern = 'Rmd')\n            if ('devtools' %in% installed.packages() == TRUE) {\n            devtools::session_info()\n            } else {\n            sessionInfo()\n            }\n            ```\n            \n            ", 
          file = target_index)
    }
    # write yaml
    the_files <- list.files(path = target_Rmd, pattern = '*Rmd', full.names = TRUE)
    basename_html <- basename(gsub(pattern = ".Rmd", replacement = ".html", 
                                   x = the_files))
    basename_next <- basename(gsub(pattern = ".Rmd", replacement = "", 
                                   x = the_files))
    print_lines <- function() {
      for (i in seq_along(basename_next)) {
        cat("    - text: ", "'", basename_next[i], "'", "\n", 
            "      href: ", basename_html[i], "\n", sep = "")
      }
    }
    nr_subdir <- nchar(target_Rmd) - nchar(gsub(pattern = "/", 
                                                replacement = "", x = target_Rmd))
    nr_subdir <- nr_subdir + 1
    paste_nr_subdir <- paste(rep("..", nr_subdir), collapse = "/")
    target_dir_web <- file.path(paste_nr_subdir, target_html)
    target_yaml <- file.path(target_Rmd, "_site.yml")
    sink(target_yaml)
    c(cat("name: '", basename(getwd()), "'\noutput_dir: '", target_dir_web, 
          "'\nnavbar:\n  title: '", basename(getwd()), "'\n  left:\n", 
          sep = ""), print_lines(), cat("output:\n  html_document:\n    theme: cosmo\n    highlight: textmate\n"))
    sink()
    # render site
    rmarkdown::render_site(input = target_Rmd, ...)
  }
