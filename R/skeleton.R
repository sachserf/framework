#' Create a framework-project skeleton
#' 
#' @description The function creates a predefined directory structure and some 
#'   files to enhance project organization. Among other things it is a wrapper
#'   for 'template_make'.
#' @inheritParams project_framework
#' @return The output are several files and directories within your working 
#'   directory. The structure contains a how-to-guide.txt, README.md, 
#'   directories for input and output, some file-templates and several functions
#'   for proper functioning of the project.
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
           source_dir = 'in/docs',
           data_dir = 'in/data',
           target_dir_figure = 'out/figure',
           target_dir_docs = 'out/docs',
           target_dir_data = 'out/data',
           rename_figure = TRUE,
           rename_docs = TRUE,
           log_filepath = 'meta/log.csv',
           session_info_filepath = 'meta/session_info.txt',
           spin_index,
           cache_index, 
           knitr_cache = FALSE) {
    # specify framework_fun directory
    framework_fun <- file.path(fun_dir, "framework")
    
    #### create basic directories ####
    basic_dirs <-
      list(
        file.path(data_dir),
        file.path(source_dir),
        file.path(framework_fun),
        file.path(target_dir_figure),
        file.path(target_dir_data),
        file.path(target_dir_docs),
        file.path(dirname(log_filepath)),
        file.path(dirname(session_info_filepath))
      )
    basic_dirs <- basic_dirs[!basic_dirs %in% "character(0)"]
    lapply(X = basic_dirs,
           FUN = dir.create,
           recursive = TRUE, 
           showWarnings = FALSE)

    invisible(lapply(X = list.files(system.file("templates", package = "framework"), full.names = TRUE), FUN = file.copy, to = framework_fun, recursive = TRUE))
   
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
        target_dir_data,
        rename_figure,
        rename_docs,
        log_filepath,
        session_info_filepath,
        spin_index,
        cache_index,
        knitr_cache
      )
    } else {
      file.copy(from = custom_makeR,
                to = target_makeR,
                overwrite = FALSE)
    }
    
    # write first logfile entry
    log_entry(log_filepath)
    
    #### write templates for source-files ####
    source_files <- file.path(source_dir, source_files)
    source_files_R <-
      source_files[which(tools::file_ext(source_files) == "R")]
    source_files_Rmd <-
      source_files[which(tools::file_ext(source_files) == "Rmd")]
    if (length(source_files_R) > 0) {
      lapply(X = source_files_R, FUN = framework::template_html, open = FALSE)
    }
    if (length(source_files_Rmd) > 0) {
      lapply(X = source_files_Rmd, FUN = framework::template_html, open = FALSE)
    }
    
    #### write README.md ####
    framework_version <- paste0(unlist(utils::packageVersion('framework')), collapse = ".")
    cat(
      '# Readme of the project: ',
      basename(getwd()),
      '\n\nThis project was created from **',
      Sys.info()['user'],
      '** at **',
      as.character(Sys.time()),
      "**\n\n- This project was build by using the package `framework` (v", framework_version, ")
      - visit https://github.com/sachserf/framework/blob/master/README.md for a short introduction
      - visit https://sachserf.github.io for further information and tutorials",
      
      '\n\n## Outline\nGive an outline of your project.\n\n## To Do\nList your ideas.\n\n## Work Log\nWrite log entries.\n\n\n\n',
      file = 'README.md',
      sep = ''
    )
    
    #### write how-to-guide.md
#    htm <-
#      readLines(con = "https://raw.githubusercontent.com/sachserf/framework/vignettes/README.md")
    htg <- readLines(file.path(system.file(package = "framework"), "how_to_guide/README.md"))
    cat(htg, file = "README.md", sep = "\n", append = TRUE)
  }
