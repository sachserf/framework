#' dsfrrgroodsgh
#' 
#' @description aswgarsg swegoo
#' @author Frederik Sachser
#' @export
write_index_Rmd <- 
function (target_index_Rmd = ".cache/website/index.Rmd") 
{
    if (file.exists(target_index_Rmd) == TRUE) {
        warning("index.Rmd does exist.")
    }
  else {
    cat("# This website is a collection of compiled notebooks of the project: \"`r basename(dirname(dirname(getwd())))`\". \n            \n            Compiled at `r Sys.time()`\n            \n            The following files have been compiled:\n            \n            `r list.files('.cache', pattern = 'Rmd')`\n            \n            ```{r, echo = FALSE}\n            list.files(pattern = 'Rmd')\n            if ('devtools' %in% installed.packages() == TRUE) {\n            devtools::session_info()\n            } else {\n            sessionInfo()\n            }\n            ```\n            \n            ", 
        file = target_index_Rmd)
  }
}
