#' check_instructions
#' @description check_instructions
#' @export
check_instructions <-
    function(cache_dir = '.cache')
    {
        # check prerequisites
        if (any(file.exists(
            file.path(cache_dir, 'df_source_files_temp.rds'),
            file.path(cache_dir, "instructions.RData")
        )) == FALSE) {
            stop(
                "Required files in cache are missing. Recall function prepare_instructions() and implement_instructions() and retry."
            )
        }
        # reload instructions
        load(file.path(cache_dir, "instructions.RData"))
        # reload temporary df_source_files
        df_source_files <-
            readRDS(file = file.path(cache_dir, 'df_source_files_temp.rds'))
        
        # check snapshot of data-dir
        
        # if snapshot is missing: do not use cache
        if (file.exists(path_snapshot_data_dir) == FALSE) {
            df_source_files$use_cache_qualified <- FALSE
        } else {
            if (length(list.files(data_dir)) > 0) {
                # check file changes
                # specify changed files
                snapshot_data_dir <-
                    readRDS(file = path_snapshot_data_dir)
                changed_files <-
                    utils::changedFiles(snapshot_data_dir, md5sum = TRUE)$changed
                if (length(changed_files) > 0) {
                    df_source_files$use_cache_qualified <- FALSE
                    message("Cache will be ignored because files in data_dir have changed.")
                }
            }
        }
        
        # check snapshot of source-dir
        
        # if snapshot is missing: do not use cache
        if (file.exists(path_snapshot_source_dir) == FALSE) {
            df_source_files$use_cache_qualified <- FALSE
        } else {
            df_source_files$use_cache_qualified <- TRUE
            # check file changes
            # specify changed files
            snapshot_source_dir <-
                readRDS(file = path_snapshot_source_dir)
            changed_files <-
                utils::changedFiles(snapshot_source_dir, md5sum = TRUE)$changed
            changed_files <- file.path(source_dir, changed_files)
            # specify changed files within source_files
            changed_files_index <- source_files %in% changed_files
            # if there are files that did not change - use cache
            if (any(changed_files_index == TRUE)) {
                df_source_files$use_cache_qualified[which(changed_files_index == TRUE)] <-
                    FALSE
            }
        }
        
        # check image
        
        # make sure not to use the cache if image of the file is missing
        image_exists <- file.exists(df_source_files$image_cache)
        if (any(image_exists == FALSE)) {
            df_source_files$use_cache_qualified[which(image_exists == FALSE)] <-
                FALSE
        }
        
        # check cache-files
        
        # make sure not to use the cache if required files in cache are missing
        ## problem bei R-files die nicht gespinnt werden!
        cache_docs <-
            sapply(lapply(X = df_source_files$docs_cache, FUN = list.files),
                   length)
        if (any(cache_docs == 0)) {
            df_source_files$use_cache_qualified[which(cache_docs == 0 &&
                                                          df_source_files$file_ext != "R")] <-
                FALSE
        }
        
        # check order of source-files
        
        # check if order of df_cache has changed
        if (file.exists(file.path(cache_dir, "df_source_files.rds"))) {
            df_source_files_old <-
                readRDS(file.path(cache_dir, "df_source_files.rds"))
            #            df_source_files$row_names <- row.names(df_source_files)
            #            df_source_files_old$row_names <-
            #                row.names(df_source_files_old)
            df_source_files_both <-
                merge(
                    x = df_source_files,
                    y = df_source_files_old[,
                                            c("filename", "row_names", "instruction_no_cache")],
                    by = "filename",
                    all.x = TRUE
                )
            df_source_files_both <-
                df_source_files_both[order(df_source_files_both$row_names.x),]
            df_source_files_both$pos_match <-
                as.numeric(df_source_files_both$row_names.x) -
                as.numeric(df_source_files_both$row_names.y)
            df_source_files$use_cache_qualified[which(df_source_files_both$pos_match != 0)] <-
                FALSE
            # make sure not to use cache if instruction changed
            df_source_files$instruction_equal <- ifelse(df_source_files_both$instruction_no_cache.x == df_source_files_both$instruction_no_cache.y, TRUE, FALSE) 
            if (any(which(df_source_files$instruction_equal == FALSE) > 0)) {
                df_source_files$use_cache_qualified[which(df_source_files$instruction_equal == FALSE & df_source_files$instruction_no_cache != "source")] <- FALSE
            }
        } else {
            df_source_files$use_cache_qualified <- FALSE
        }
        
#        # do not use cache if instruction changed 
#        if (file.exists(file.path(cache_dir, "df_source_files.rds"))) {
#            df_source_files_old <-
#                readRDS(file.path(cache_dir, "df_source_files.rds"))
#            df_source_files$filename[c(1,2,3)] %in% df_source_files_old$filename[1:2]
#            grep()
#        }
        
        # do not use cache if a file has been executed before
        if (length(which(df_source_files$use_cache_qualified == FALSE)) > 0) {
            df_source_files$use_cache_qualified[min(which(df_source_files$use_cache_qualified == FALSE)):nrow(df_source_files)] <- FALSE
        }
        
        # add final instructions
        df_source_files$instruction <-
            df_source_files$instruction_no_cache
        # edit instruction according to use-cache
        if (any(df_source_files$use_cache_input == TRUE)) {
            use_cache_index <-
                which(
                    df_source_files$use_cache_input == TRUE &
                        df_source_files$use_cache_qualified == TRUE
                )
            
            df_source_files$instruction[use_cache_index] <-
                "nothing"
        }
        
        # delete deprecated files in cache
        deprecated_cache <-
            dirname(df_source_files$docs_cache[df_source_files$instruction != "nothing"])
        if (length(deprecated_cache) > 0) {
            lapply(X = deprecated_cache,
                   FUN = unlink,
                   recursive = TRUE)
        }
        
        # make sure the most recent file in cache will be loaded
        if (any(df_source_files$instruction == "nothing")) {
            df_source_files$instruction[max(which(df_source_files$instruction == "nothing"))] <-
                "load"
        }
        # overwrite df_source_files_temp.rds
        saveRDS(object = df_source_files,
                file = file.path(cache_dir, 'df_source_files_temp.rds'))
        
    }
