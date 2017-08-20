#' Tree-view a directory structure
#' 
#' @description This function will summarize a given directory structure as a tree.
#' @param tree_directory Character. Specify a path to a directory. default: current working directory.
#' @param tree_target Character. Optionally specify a file path to write the output to a file. default: stdout.
#' @param include_hidden Logical. If set to false: all hidden directories and files will be omitted.
#' @author Frederik Sachser
#' @export
treedir <- function(tree_directory = getwd(), tree_target, include_hidden = FALSE) {
  
  if (missing(tree_target) == TRUE) {
    tree_target <- stdout()
  }
  
  thefiles <- list.files(path = tree_directory, recursive = TRUE, all.files = TRUE, full.names = TRUE)
  thedir <- list.dirs(path = tree_directory, recursive = TRUE, full.names = TRUE)
  
  # remove hidden dirs and files
  if (include_hidden == FALSE) {
    grephiddenfiles <- grep(pattern = paste0(.Platform$file.sep, "."), x = thefiles, fixed = TRUE)
    grephiddendir <- grep(pattern = paste0(.Platform$file.sep, "."), x = thedir, fixed = TRUE)
    
    if (length(grephiddenfiles) > 0) {
      thefiles <- thefiles[-grephiddenfiles]
    }
    
    if (length(grephiddendir) > 0) {
      thedir <- thedir[-grephiddendir]
    }
  }
  
  nfiles_recursive <- c()
  ndir_recursive <- c()
  dirnames <- list()
  ndir <- c()
  nfiles <- c()
  
  for (i in 1:length(thedir)) {
    # nfiles_recursive
    # recursive = TRUE, include_dirs = FALSE
    nfiles_recursive[i] <- length(list.files(path = thedir[i], include.dirs = FALSE, all.files = include_hidden, recursive = TRUE, full.names = TRUE, no.. = TRUE))
    # ndir_recursive
    # recursive = TRUE, include_dirs = TRUE
    ndir_recursive[i] <- length(list.files(path = thedir[i], include.dirs = TRUE, all.files = include_hidden, recursive = TRUE, full.names = TRUE, no.. = TRUE)) - nfiles_recursive[i]
    # ndir
    dirnames[[i]] <- list.dirs(path = thedir[i], full.names = TRUE, recursive = FALSE)
    if (include_hidden == FALSE) {
      bar <- grep(pattern = paste0(.Platform$file.sep, "."), x = dirnames[[i]], fixed = TRUE)
      ndir[i] <- length(dirnames[[i]]) - length(bar)
    } else {
      ndir[i] <- length(dirnames[[i]])
    }
    # nfiles
    # recursive = FALSE, include_dirs = FALSE
    nfiles[i] <- length(list.files(path = thedir[i], include.dirs = FALSE, all.files = include_hidden, recursive = FALSE, full.names = TRUE, no.. = TRUE)) - ndir[i]
  }
  
  # remove path of directory
  nchar_dir <- nchar(tools::file_path_as_absolute(tree_directory))
  thedir <- substr(thedir, start = (nchar_dir + 1), stop = nchar(thedir))
  thefiles <- substr(thefiles, start = (nchar_dir + 1), stop = nchar(thefiles))
  
  # format output
  dirname <- c()
  for (i in 1:length(thedir)) {
    nr_subdir <- nchar(thedir[i]) - nchar(gsub(.Platform$file.sep, "", thedir[i]))
    dirname[i] <- paste0(paste0(rep("   ", nr_subdir), collapse = ""), "|__ ", basename(thedir[i]))
  }
  #
  dirname[1] <- basename(tree_directory)
  
  writeLines(c("Dirname (ndir_recursive - ndir - nfiles_recursive - nfiles)", "-----------------------------------------------------------", paste0(dirname, " (", ndir_recursive, "-", ndir, "-", nfiles_recursive, "-", nfiles, ")")), sep = "\n", con = tree_target)
}
