#' dsfrrgrqqdsgh
#' 
#' @description aswgarsg swegqq
#' @author Frederik Sachser
#' @export
write_yaml <- 
  function (target_dir_yaml = ".cache/website",
            target_dir_website = "out/auto/notebooks/website") 
  {
    Rmd_files <- c(basename(readRDS(".cache/df_cache.rds")$filename_Rmd))
    basename_Rmd <- list.files(path = target_dir_yaml, pattern = ".Rmd")
    rf <- Rmd_files[Rmd_files %in% basename_Rmd]
    Rmd_basename_web <- c("index.Rmd", rf)
    
    basename_html <- gsub(pattern = '.Rmd', replacement = '.html', x = Rmd_basename_web)
    basename_next <- gsub(pattern = '.Rmd', replacement = '', x = Rmd_basename_web)
    
    print_lines <- function() {
      for (i in seq_along(basename_next)) {
        cat("    - text: ", "'", basename_next[i], "'", "\n", "      href: ", 
            basename_html[i], "\n", sep = "")
      }
    }

    nr_subdir <- nchar(target_dir_yaml) - nchar(gsub(pattern = "/", 
                                                     replacement = "", x = target_dir_yaml))
    nr_subdir <- nr_subdir + 1
    paste_nr_subdir <- paste(rep("..", nr_subdir), collapse = "/")
    target_dir_web <- file.path(paste_nr_subdir, target_dir_website)
    target_yaml <- file.path(target_dir_yaml, "_site.yml")

    target_yaml <- file.path(target_dir_yaml, "_site.yml")
    
    sink(target_yaml)
    c(cat("name: '", basename(getwd()), "'\noutput_dir: '", target_dir_web, 
          "'\nnavbar:\n  title: '", basename(getwd()), "'\n  left:\n", 
          sep = ""), print_lines(), cat("output:\n  html_document:\n    theme: cosmo\n    highlight: textmate\n"))
    sink()
  }
