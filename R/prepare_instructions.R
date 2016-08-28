#' prepare_instructions
#' @description prepare_instructions
#' @param source_files eg
#' @param spin_index weg
#' @param cache_index wesg
#' @param cache_dir weg
#' @param source_dir weg
#' @param data_dir ewg
#' @param target_dir_figure ew
#' @param target_dir_docs wt
#' @param target_dir_data wetg
#' @export
prepare_instructions <-
    function(source_files,
             spin_index = 0,
             cache_index = 0,
             cache_dir = '.cache',
             source_dir = 'in/src',
             data_dir = 'in/data',
             target_dir_figure = 'out/figure',
             target_dir_docs = 'out/docs',
             target_dir_data = 'out/data') {

        # specify full path to source-files
        source_files <-
            as.character(file.path(source_dir, source_files))
        # Check if source-files exist
        if (any(file.exists(source_files) == FALSE) == TRUE) {
            stop("At least one source_file does not exist. Check file path and retry.")
        }
        
        # delete cache_dir
        if (length(cache_index) == 1 && cache_index == 0) {
            unlink(x = cache_dir, recursive = TRUE)
        }
        if (dir.exists(cache_dir) == FALSE) {
            dir.create(cache_dir)
        }
        
        # specify indices
        if (length(cache_index) == 1 && cache_index == "all") {
            cache_index <- 1:length(source_files)
        }
        if (length(spin_index) == 1 && spin_index == "all") {
            spin_index <- 1:length(source_files)
        }
        
        # specify file path of snapshots
        path_snapshot_source_dir <-
            file.path(cache_dir, 'snapshot_source_dir.rds')
        path_snapshot_data_dir <-
            file.path(cache_dir, 'snapshot_data_dir.rds')
        
        # delete and create output directories
        if (dir.exists(target_dir_figure) == TRUE) {
            unlink(x = target_dir_figure, recursive = TRUE)
        }
        dir.create(path = target_dir_figure, recursive = TRUE)
        
        if (dir.exists(target_dir_docs) == TRUE) {
            unlink(x = target_dir_docs, recursive = TRUE)
        }
        dir.create(path = target_dir_docs, recursive = TRUE)
        
        if (dir.exists(target_dir_data) == TRUE) {
            unlink(x = target_dir_data, recursive = TRUE)
        }
        dir.create(path = target_dir_data, recursive = TRUE)
        
        
        # Make sure that there is no outdated instruction
        if (file.exists(file.path(cache_dir, 'instructions.RData'))) {
            unlink(x = file.path(cache_dir, 'instructions.RData'),
                   recursive = TRUE)
        }
        
        # write instructions
        save(
            source_files,
            spin_index,
            cache_index,
            cache_dir,
            source_dir,
            data_dir,
            target_dir_figure,
            target_dir_docs,
            target_dir_data,
            path_snapshot_source_dir,
            path_snapshot_data_dir,
            file = file.path(cache_dir, 'instructions.RData')
        )
    }
