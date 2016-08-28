#' specify_instructions
#' @description specify_instructions
#' @export
specify_instructions <-
    function(filename,
             image_cache,
             instruction)
    {
        if (instruction == "load") {
            load(image_cache, envir = .GlobalEnv)
        }
        else if (instruction == "source") {
            source(filename)
            save(list = ls(.GlobalEnv), file = image_cache)
        }
        else if (instruction == "render") {
            rmarkdown::render(
                input = filename,
                envir = globalenv(),
                output_format = "all",
                clean = FALSE
            )
            save(list = ls(.GlobalEnv), file = image_cache)
        }
        else if (instruction == "knit") {
            knitr::knit2pdf(input = filename, envir = globalenv())
            save(list = ls(.GlobalEnv), file = image_cache)
        }
    }
