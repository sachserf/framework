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
  function(custom_makeR = NULL,
           target_makeR = 'make.R',
           fun_dir = 'in/fun',
           source_files = c('load.R',
                            'report.Rmd'),
           cache_dir = '.cache',
           source_dir = 'in/src',
           data_dir = 'in/data',
           target_dir_figure = 'out/figure',
           target_dir_docs = 'out/docs',
           target_dir_data = 'out/data') {
    #### create basic directories ####
    basic_dirs <-
      list(
        file.path(data_dir),
        file.path(source_dir),
        file.path(fun_dir, 'sachserf_framework'),
        file.path(target_dir_figure),
        file.path(target_dir_data),
        file.path(target_dir_docs)
      )
    lapply(X = basic_dirs,
           FUN = dir.create,
           recursive = TRUE)
    
    #### write fun ####
    # write local copy of functions
    framework::dput_function(
      pkg_fun = framework::backup,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::pkg_install,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::session_info,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::template_Rmd,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::template_R,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::write_dataframe,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::instructions,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::prepare_instructions,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::implement_instructions,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::check_instructions,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::specify_instructions,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::execute_instructions,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::summary_instructions,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    framework::dput_function(
      pkg_fun = framework::prepare_site,
      target_dir = file.path(fun_dir, 'sachserf_framework'),
      rm_pattern = 'framework::'
    )
    
    
    #### create make.R ####
    if (is.null(custom_makeR) == TRUE) {
      template_make(
        target_makeR,
        fun_dir,
        source_files,
        cache_dir,
        source_dir,
        data_dir,
        target_dir_figure,
        target_dir_docs,
        target_dir_data
      )
    } else {
      file.copy(from = custom_makeR,
                to = target_makeR,
                overwrite = FALSE)
    }
    
    #### write templates for source-files ####
    source_files <- file.path(source_dir, source_files)
    source_files_R <-
      source_files[which(tools::file_ext(source_files) == "R")]
    source_files_Rmd <-
      source_files[which(tools::file_ext(source_files) == "Rmd")]
    if (length(source_files_R) > 0) {
      lapply(X = source_files_R, FUN = framework::template_R)
    }
    if (length(source_files_Rmd) > 0) {
      lapply(X = source_files_Rmd, FUN = framework::template_Rmd)
    }
    
    
    #### write README.md ####
    cat(
      '# Readme of the project: ',
      basename(getwd()),
      '\n\nThis project was created from **',
      Sys.info()['user'],
      '** at **',
      as.character(Sys.time()),
      '**\n\n## Outline\nGive an outline of your project.\n\n## To Do\nList your ideas.\n\n## Work Log\nWrite log entries.',
      file = 'README.md',
      sep = ''
    )
    
    #### write how-to-guide.md
    htm <-
      readLines(con = "https://raw.githubusercontent.com/sachserf/framework/vignettes/README.md")
    cat(htm, file = "how-to-guide.md", sep = "\n")
  }
