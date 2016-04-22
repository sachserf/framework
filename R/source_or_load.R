source_or_load <- 
function () 
{
    if (any(file.exists(".cache/load_me.rds", ".cache/source_me.rds", 
        ".cache/df_cache_R.rds") == FALSE) == TRUE) {
        warning("cache files not found: call <<prepare_cache>> and retry")
    }
    else {
        load_me <- readRDS(".cache/load_me.rds")
        source_me <- readRDS(".cache/source_me.rds")
        df_cache_R <- readRDS(".cache/df_cache_R.rds")
        input_R <- df_cache_R$filename_full
        if (identical(file.exists(df_cache_R$filename_image), 
            file.exists(df_cache_R$filename_mtime)) == FALSE) {
            lapply(X = input_R, FUN = framework::source_n_save)
        }
        else {
            if (identical(sum(as.integer(is.na(source_me))), 
                length(source_me))) {
                load(load_me[length(load_me)], envir = .GlobalEnv)
            }
            else if (identical(sum(as.integer(is.na(load_me))), 
                length(load_me))) {
                lapply(X = source_me, FUN = framework::source_n_save)
            }
            else {
                load(load_me[length(load_me)], envir = .GlobalEnv)
                lapply(X = source_me, FUN = framework::source_n_save)
            }
        }
    }
}
