source_n_save <- 
function (file_path, target_mtime, target_image, use_cache = TRUE) 
{
    if (use_cache == TRUE) {
        if (file.exists(".cache/df_cache_R.rds")) {
            df_cache_R <- readRDS(".cache/df_cache_R.rds")
            target_mtime <- df_cache_R[grep(file_path, df_cache_R$filename_full), 
                "filename_mtime"]
            target_image <- df_cache_R[grep(file_path, df_cache_R$filename_full), 
                "filename_image"]
        }
        else {
            warning("cache file not found. choose option use_cache = FALSE or call prepare_cache and retry.")
        }
    }
    source(file_path)
    if (dir.exists(dirname(target_mtime)) == FALSE) {
        dir.create(path = dirname(target_mtime), recursive = TRUE)
    }
    x <- strftime(file.mtime(file_path))
    saveRDS(object = x, file = target_mtime)
    rm(x)
    save.image(file = target_image)
}
