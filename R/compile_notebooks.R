compile_notebooks <- 
function (file_path, target_dir = ".cache/notebooks", figure_output = "figure") 
{
    target_files_no_ext <- paste0(target_dir, "/", substr(basename(file_path), 
        start = 1, stop = (nchar(basename(file_path)) - 2)))
    target_Rmd <- paste0(target_files_no_ext, ".Rmd")
    target_figure <- file.path(dirname(target_Rmd), "figure")[1]
    if (dir.exists(target_figure) == FALSE) {
        dir.create(target_figure, recursive = TRUE)
    }
    for (i in seq_along(file_path)) {
      knitr::spin(hair = file_path[i], 
                  envir = globalenv(),
                  knit = FALSE)
    }
    file.rename(from = paste0(file_path, 'md'), to = target_Rmd)
    if (dir.exists("figure") == TRUE) {
        file.copy(from = list.files("figure", full.names = TRUE), 
            to = paste0(target_figure, "/", list.files("figure")), 
            overwrite = TRUE)
        unlink("figure", recursive = TRUE)
    }
#    unlink(target_Rmd, recursive = TRUE)
    source_fig <- list.files(paste0(target_figure, "/", list.files("figure")), 
        full.names = TRUE)
    target_fig <- paste0(figure_output, "/", basename(source_fig))
    if (length(source_fig) == 0) {
        unlink(target_figure, recursive = TRUE)
    }
    else {
        if (figure_output != "figure") {
            if (dir.exists(figure_output) == FALSE) {
                dir.create(figure_output, recursive = TRUE)
            }
            if (length(source_fig) > 0) {
                file.copy(from = source_fig, to = target_fig, 
                  overwrite = TRUE)
            }
            unlink(dirname(source_fig), recursive = TRUE)
        }
    }
}
