backup <-
  function(target_dir = 'project_subdir', source_dir = file.path(getwd()), overwrite = FALSE){
    projname <- paste('BACKUP_', unlist(strsplit(source_dir, split = '/'))[length(unlist(strsplit(source_dir, split = '/')))], sep = '')
    if(target_dir == 'project_subdir') {
      target_dir <- file.path(getwd(), projname)
    } else { 
      target_dir <- file.path(target_dir, projname)
    }
    stime <- format(Sys.time(), format(Sys.time(), format='%Y%m%d-%A-%H%M%S'))
    target_dir_stime <- file.path(target_dir, stime)
    sub_directories <- list.dirs(source_dir, full.names = FALSE)
    project_files <- list.files(source_dir, all.files = TRUE, no.. = TRUE, recursive = TRUE)
    # exclude backup directory and files if it is within the project directory
    dir_exclude <- grep(pattern = target_dir, x = file.path(source_dir, sub_directories))
    if(length(dir_exclude) != 0){
      sub_directories <- file.path(sub_directories)[-dir_exclude]
    }
    project_files_full <- list.files(source_dir, full.names = TRUE, all.files = TRUE, no.. = TRUE, recursive = TRUE)
    file_exclude <- grep(pattern = target_dir, x = project_files_full)
    if(length(file_exclude) != 0){
      project_files <- file.path(project_files)[-file_exclude]
    }
    # function to create directories
    dir_create_or_exist <- function(thedirectory) {
      if(dir.exists(thedirectory) == FALSE) {
        dir.create(thedirectory, recursive = TRUE)
      }
    }
    if (overwrite == TRUE) unlink(target_dir, recursive = TRUE)
    # create directories
    dir_create_or_exist(target_dir)
    lapply(file.path(target_dir_stime, sub_directories), dir_create_or_exist)
    # copy files
    file.copy(from = file.path(source_dir, project_files), to = file.path(target_dir_stime, project_files),  recursive = FALSE)
  }
