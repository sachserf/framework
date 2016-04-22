make_source <- 
function (..., use_cache) 
{
    if (use_cache == TRUE) {
        if (file.exists(".cache/input_data.rds") == TRUE) {
            input_data_current <- sapply(X = list.files("input/data", 
                full.names = TRUE, recursive = TRUE), FUN = file.info)
            input_data_source <- readRDS(file = ".cache/input_data.rds")
            if (all.equal(target = input_data_source, input_data_current) == 
                TRUE) {
                local_fun$prepare_cache(input_R = ..., write_cache = use_cache)
                local_fun$source_or_load()
            }
            else {
                warning("files in directory <<input/data>> changed - use option <<use_cache = FALSE>> and retry.")
            }
        }
        else {
            unlink(x = ".cache", recursive = TRUE)
            local_fun$prepare_cache(input_R = ..., write_cache = use_cache)
            local_fun$source_or_load()
        }
    }
    else {
        unlink(x = ".cache", recursive = TRUE)
        local_fun$prepare_cache(input_R = ..., write_cache = use_cache)
        lapply(X = ..., FUN = source)
    }
}
