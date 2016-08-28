#' execute_instructions
#' @description execute_instructions
#' @export
execute_instructions <-
    function(cache_dir = ".cache")
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
        
        # create all required directories in cache and output
        new_directories <-
            unique(
                c(
                    df_source_files$figure_cache,
                    df_source_files$docs_cache,
                    dirname(df_source_files$figure_out),
                    dirname(df_source_files$docs_out),
                    df_source_files$temp_docs_out
                )
            )
        sapply(
            X = new_directories,
            FUN = dir.create,
            recursive = TRUE,
            showWarnings = FALSE
        )
        
        # list all files of source_dir before rendering
        if (file.exists(file.path(cache_dir, "source_dir_files_pre.rds")) == FALSE) {
            source_dir_files_pre <-
                list.files(
                    source_dir,
                    full.names = TRUE,
                    recursive = TRUE,
                    all.files = TRUE
                )
            saveRDS(object = source_dir_files_pre,
                    file = file.path(cache_dir, 'source_dir_files_pre.rds'))
        }
        
        # call specify_instructions()
        for (i in 1:nrow(df_source_files)) {
            specify_instructions(
                filename = df_source_files$filename[i],
                image_cache = df_source_files$image_cache[i],
                instruction = df_source_files$instruction[i]
            )
        }
        
        # delete docs and figures for files that should not be rendered/spinned
        deprecated_render_docs <- which(df_source_files$file_ext == "R" & df_source_files$use_spin == FALSE)
        for (i in deprecated_render_docs) {
            unlink(df_source_files$figure_cache[i], recursive = TRUE)
            unlink(df_source_files$docs_cache[i], recursive = TRUE)
        }

        # copy new rendered figures to cache and delete from source
        for (i in 1:nrow(df_source_files)) {
            if (dir.exists(df_source_files$figure_source[i])) {
                source_figures <-
                    list.files(path = df_source_files$figure_source[i],
                               full.names = TRUE)
                #                cache_figures <- file.path(df_source_files$figure_cache[i], basename(source_figures))
                file.copy(
                    from = source_figures,
                    to = df_source_files$figure_cache[i],
                    recursive = TRUE
                )
                unlink(df_source_files$figure_source[i], recursive = TRUE)
            }
        }
        
        # copy all figures from cache to output
        for (i in 1:nrow(df_source_files)) {
            if (length(list.files(df_source_files$figure_cache[i])) > 0) {
                cache_figures <-
                    list.files(df_source_files$figure_cache[i], full.names = TRUE, recursive = TRUE)
                figure_out_files <-
                    paste0(df_source_files$figure_out[i],
                           "_",
                           basename(cache_figures))
                file.copy(from = cache_figures, to = figure_out_files)
            }
        }
        
        
        # list all files of source_dir after rendering (without figures)
        source_dir_files_post <-
            list.files(
                source_dir,
                full.names = TRUE,
                recursive = TRUE,
                all.files = TRUE
            )
        # subset new source_files
        source_dir_files_pre <- readRDS(file = file.path(cache_dir, 'source_dir_files_pre.rds'))
        new_files <-
            source_dir_files_post[!source_dir_files_post %in% source_dir_files_pre]
        file.remove(file.path(cache_dir, 'source_dir_files_pre.rds'))
        
        # copy new rendered files to cache and delete them from input
        for (i in 1:nrow(df_source_files)) {
            new_files_subset <-
                new_files[grep(pattern = paste0(df_source_files$filename_noxt[i], '.'),
                               x = new_files,
                               fixed = TRUE)]
            file.copy(from = new_files_subset,
                      to = file.path(df_source_files$docs_cache[i]))
            file.remove(new_files_subset)
        }
        
        # copy all rendered files from cache to output
        for (i in 1:nrow(df_source_files)) {
            all_files <-
                list.files(df_source_files$docs_cache[i], full.names = TRUE)
            html_files <-
                all_files[grep(pattern = ".html",
                               x = all_files,
                               fixed = TRUE)]
            pdf_files <-
                all_files[grep(pattern = ".pdf",
                               x = all_files,
                               fixed = TRUE)]
            docx_files <-
                all_files[grep(pattern = ".docx",
                               x = all_files,
                               fixed = TRUE)]
            html_pdf_docx <- c(html_files, pdf_files, docx_files)
            out_docs <-
                paste0(df_source_files$docs_out[i],
                       "_",
                       basename(html_pdf_docx))
            file.copy(from = html_pdf_docx,
                      to = out_docs)
            temp_files <-
                all_files[!all_files %in% html_pdf_docx]
            file.copy(from = temp_files, to = df_source_files$temp_docs_out[i])
        }
        
        # delete df_source_files_temp.rds and instructions.RData from cache
        file.remove(
            file.path(cache_dir, 'df_source_files_temp.rds'),
            file.path(cache_dir, "instructions.RData")
        )
        # write current df_source_files
        saveRDS(object = df_source_files,
                file = file.path(cache_dir, 'df_source_files.rds'))
        
        # delete snapshots
        if (file.exists(path_snapshot_source_dir) == TRUE) {
            file.remove(path_snapshot_source_dir)
        }
        if (file.exists(path_snapshot_data_dir) == TRUE) {
            file.remove(path_snapshot_data_dir)
        }
        
        # write new file-snapshot of the files within the source-dir
        snapshot_source_dir <-
            utils::fileSnapshot(path = source_dir,
                                md5sum = TRUE,
                                recursive = TRUE)
        saveRDS(object = snapshot_source_dir, file = path_snapshot_source_dir)
        
        # write new file-snapshot of the files within the data-dir
        snapshot_data_dir <-
            utils::fileSnapshot(path = data_dir,
                                md5sum = TRUE,
                                recursive = TRUE)
        saveRDS(object = snapshot_data_dir, file = path_snapshot_data_dir)
#        cat("\n--------------------------------------------\nSummary of executed instructions:\n\n")
#        print(data.frame(filename = df_source_files$filename, 
#                         instruction = df_source_files$instruction))
#        cat("\n--------------------------------------------\n")
        if (file.exists("summary_instructions.csv")) {
            unlink("summary_instructions.csv")
        }
        write.csv(data.frame(filename = df_source_files$filename, instruction = df_source_files$instruction), file = "summary_instructions.csv", row.names = FALSE)

    }
