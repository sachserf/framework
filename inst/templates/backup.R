#' Copy a directory into timestamp-dir
#'
#' @description The function will copy the specified directory and create a
#'   directory at the target. The target directory will be named after the
#'   current date and time.
#' @param target_dir_backup Character. Path to the target directory. Alternatively use
#'   'project_subdir' to point to a subfolder of your current working directory.
#' @param source_dir_backup Character. Path to the source directory. Default is the
#'   current working directory.
#' @param rebuild_target_dir_backup Logical. If TRUE all directories within the target
#'   directory will be deleted! Only the current version of your backup will be
#'   existent.
#' @param exclude_dir_backup Character. Specify directories to exclude from
#'   backup. If you want to exclude multiple directories use | as separator.
#'   Choose FALSE if you don not want to exclude any directories. E.g. 'packrat|.git|in/data|out|.cache'
#' @param exclude_files_backup Character. Specify files to exclude from backup. If you
#'   want to exclude multiple directories use | as separator. Choose FALSE if
#'   you don not want to exclude any files. E.g. '*.RData|*.Rhistory'
#' @note Beware! If you choose an existing target directory and option
#'   rebuild_target_dir_backup = TRUE: ALL EXISTING FILES WILL BE DELETED!
#' @author Frederik Sachser
#' @export
backup <-
function(target_dir_backup = "project_subdir", source_dir_backup = file.path(getwd()),
    rebuild_target_dir_backup = FALSE, exclude_dir_backup = FALSE, exclude_files_backup = FALSE)
{
    projname <- paste0("BACKUP_", basename(getwd()))
    if (target_dir_backup == "project_subdir") {
        target_dir_backup <- file.path(getwd(), projname)
    }
    else {
        target_dir_backup <- file.path(target_dir_backup, projname)
    }
    stime <- format(Sys.time(), format(Sys.time(), format = "%Y%m%d-%A-%H%M%S"))
    target_dir_stime <- file.path(target_dir_backup, stime)
    sub_directories <- list.dirs(source_dir_backup, full.names = FALSE)
    project_files <- list.files(source_dir_backup, all.files = TRUE,
        no.. = TRUE, recursive = TRUE)
    dir_exclude <- grep(pattern = target_dir_backup, x = file.path(source_dir_backup,
        sub_directories))
    if (length(dir_exclude) != 0) {
        sub_directories <- file.path(sub_directories)[-dir_exclude]
    }
    if (exclude_dir_backup != FALSE) {
        dir_exclude_custom <- grep(pattern = exclude_dir_backup,
            x = file.path(source_dir_backup, sub_directories))
        if (length(dir_exclude_custom) != 0) {
            sub_directories <- file.path(sub_directories)[-dir_exclude_custom]
        }
    }
    project_files_full <- list.files(source_dir_backup, full.names = TRUE,
        all.files = TRUE, no.. = TRUE, recursive = TRUE)
    file_exclude <- grep(pattern = target_dir_backup, x = project_files_full)
    if (length(file_exclude) != 0) {
        project_files <- file.path(project_files)[-file_exclude]
    }
    if (exclude_dir_backup != FALSE) {
        file_exclude_custom_dir <- grep(pattern = exclude_dir_backup,
            x = project_files)
        if (length(file_exclude_custom_dir) != 0) {
            project_files <- file.path(project_files)[-file_exclude_custom_dir]
        }
    }
    if (exclude_files_backup != FALSE) {
        file_exclude_custom_file <- grep(pattern = exclude_files_backup,
            x = project_files)
        if (length(file_exclude_custom_file) != 0) {
            project_files <- file.path(project_files)[-file_exclude_custom_file]
        }
    }
    dir_create_or_exist <- function(thedirectory) {
        if (dir.exists(thedirectory) == FALSE) {
            dir.create(thedirectory, recursive = TRUE)
        }
    }
    if (rebuild_target_dir_backup == TRUE)
        unlink(target_dir_backup, recursive = TRUE)
    dir_create_or_exist(target_dir_backup)
    lapply(file.path(target_dir_stime, sub_directories), dir_create_or_exist)
    file.copy(from = file.path(source_dir_backup, project_files), to = file.path(target_dir_stime,
        project_files), recursive = FALSE)
}
