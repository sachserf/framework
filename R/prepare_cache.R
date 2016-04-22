prepare_cache <- 
function (input_R, write_cache) 
{
    filename_full <- paste0(input_R)
    filename_R <- basename(input_R)
    filename_no_ext <- substr(filename_R, start = 1, stop = nchar(filename_R) - 
        2)
    dirname_source <- dirname(input_R)
    dirname_cache_source <- paste0(".cache/", dirname_source)
    mtime_current <- file.mtime(input_R)
    filename_image <- paste0(dirname_cache_source, "/", filename_no_ext, 
        "_image.RData")
    filename_mtime <- paste0(".cache/", dirname_source, "/", filename_no_ext, 
        "_mtime.rds")
    dirfile_no_ext <- strtrim(filename_full, width = nchar(filename_full) - 
        2)
    scriptname_object <- gsub(pattern = "/", replacement = "_", 
        x = dirfile_no_ext)
    notebooks_cache_no_ext <- paste0(".cache/notebooks/", substr(basename(input_R), 
        start = 1, stop = (nchar(basename(input_R)) - 2)))
    notebooks_cache_html <- paste0(notebooks_cache_no_ext, ".html")
    notebooks_cache_Rmd <- paste0(notebooks_cache_no_ext, ".Rmd")
    df_cache_R <- data.frame(filename_full, filename_no_ext, 
        notebooks_cache_html, notebooks_cache_Rmd, dirname_source, 
        dirname_cache_source, dirfile_no_ext, scriptname_object, 
        filename_image, filename_mtime, mtime_current, stringsAsFactors = FALSE)
    cache_files_mtime <- list.files(path = df_cache_R$dirname_cache_source, 
        pattern = "*_mtime.rds", recursive = TRUE, full.names = TRUE)
    cache_files_image <- list.files(path = df_cache_R$dirname_cache_source, 
        pattern = "*_image.RData", recursive = TRUE, full.names = TRUE)
    image_del <- cache_files_image[!cache_files_image %in% df_cache_R$filename_image]
    mtime_del <- cache_files_mtime[!cache_files_mtime %in% df_cache_R$filename_mtime]
    unlink(image_del, recursive = TRUE)
    unlink(mtime_del, recursive = TRUE)
    df_cache_R$file_exist_mtime <- file.exists(df_cache_R$filename_mtime)
    if (any(df_cache_R$file_exist_mtime == TRUE) == FALSE) {
        load_me <- NA
        source_me <- 1:nrow(df_cache_R)
    }
    else {
        df_cache_R$mtime_source <- as.POSIXct(x = "1970-01-02")
        add_mtime_source <- function(row_id) {
            x <- readRDS(df_cache_R$filename_mtime[row_id])
            df_cache_R$mtime_source[row_id] <<- x
        }
        df_cache_R_cache <- as.integer(which(df_cache_R$file_exist_mtime == 
            TRUE))
        lapply(X = df_cache_R_cache, FUN = add_mtime_source)
        df_cache_R$mtime_source <- as.POSIXct(df_cache_R$mtime_source)
        df_cache_R$difftime <- as.integer(df_cache_R$mtime_current) - 
            as.integer(df_cache_R$mtime_source)
        if (file.exists(".cache/df_cache_R.rds")) {
            df_cache_R_old <- readRDS(".cache/df_cache_R.rds")
            df_cache_R$row_names <- row.names(df_cache_R)
            df_cache_R_old$row_names <- row.names(df_cache_R_old)
            df_cache_R_both <- merge(x = df_cache_R, y = df_cache_R_old[, 
                c("filename_full", "row_names")], by = "filename_full", 
                all.x = TRUE)
            df_cache_R_both <- df_cache_R_both[order(df_cache_R_both$row_names.x), 
                ]
            df_cache_R_both$pos_match <- as.numeric(df_cache_R_both$row_names.x) - 
                as.numeric(df_cache_R_both$row_names.y)
            df_cache_R$difftime[which(df_cache_R_both$pos_match != 
                0)] <- 9999
        }
        if (any(df_cache_R$difftime == 0) == FALSE) {
            load_me <- NA
            source_me <- 1:nrow(df_cache_R)
        }
        else if (any(df_cache_R$difftime != 0) == FALSE) {
            load_me <- 1:nrow(df_cache_R)
            source_me <- NA
        }
        else {
            load_me <- 1:(min(which(df_cache_R$difftime != 0)) - 
                1)
            if (any(load_me == 0)) {
                load_me <- NA
            }
            source_me <- min(which(df_cache_R$difftime != 0)):nrow(df_cache_R)
        }
    }
    df_cache_R$source <- 1
    df_cache_R$source[load_me] <- 0
    load_me <- df_cache_R$filename_image[load_me]
    source_me <- df_cache_R$filename_full[source_me]
    for (i in seq_along(dirname_cache_source)) {
        if (dir.exists(dirname_cache_source[i]) == FALSE) 
            dir.create(dirname_cache_source[i], recursive = TRUE)
    }
    input_data <- sapply(X = list.files("in/data", full.names = TRUE, 
        recursive = TRUE), FUN = file.info)
    saveRDS(object = load_me, file = ".cache/load_me.rds")
    saveRDS(object = source_me, file = ".cache/source_me.rds")
    saveRDS(object = df_cache_R, file = ".cache/df_cache_R.rds")
    saveRDS(object = write_cache, file = ".cache/cache_status.rds")
    saveRDS(object = input_data, file = ".cache/input_data.rds")
}
