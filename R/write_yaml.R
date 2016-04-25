write_yaml <-
function (Rmd_basename_web = 'auto', target_dir_yaml = '.cache/website', target_dir_website = 'out/auto/docs/notebooks/website') 
{
  if (Rmd_basename_web == 'auto') {
    html_files <- c(basename(readRDS(".cache/df_cache_R.rds")$notebooks_cache_html))
    Rmd_files <- gsub(pattern = "html", replacement = "Rmd", 
        x = html_files, ignore.case = TRUE)
    list_files <- list.files(path = target_dir_yaml, pattern = ".Rmd")
    rf <- Rmd_files[Rmd_files %in% list_files]
    Rmd_basename_web <- c("index.Rmd", rf)
  }
  # hf = html file
    hf <- gsub(pattern = "Rmd", replacement = "html", x = Rmd_basename_web)
    # ne = no extension
    ne <- gsub(pattern = ".Rmd", replacement = "", x = Rmd_basename_web)
    print_lines <- function() {
        for (i in seq_along(ne)) {
            cat("    - text: ", "'", ne[i], "'", "\n", "      href: ", 
                hf[i], "\n", sep = "")
        }
    }
    # edit target_dir_website
    nr_subdir <- nchar(target_dir_yaml) - nchar(gsub(pattern = "/", replacement = "", 
                                          x = target_dir_yaml))
    # correct subdir
    nr_subdir <- nr_subdir + 1 
    paste_nr_subdir <- paste(rep("..", nr_subdir), collapse = "/")
    target_dir_web <- file.path(paste_nr_subdir, target_dir_website)
    # specify filename yaml 
    target_yaml <- file.path(target_dir_yaml, '_site.yml')
    # write yaml with corresponding output directory for website
    sink(target_yaml)
    c(cat("name: '", basename(getwd()), "'\noutput_dir: '", target_dir_web, "'\nnavbar:\n  title: '", 
        basename(getwd()), "'\n  left:\n", sep = ""), print_lines(), 
        cat("output:\n  html_document:\n    theme: cosmo\n    highlight: textmate\n"))
    sink()
}
#../../out/auto/docs/notebooks/website
