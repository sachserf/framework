#' Summarize a git repository
#'
#' @description This function is an alias for git2r::summary. It will print the output to the console as well as redirect it to a file.
#' @inheritParams project_framework
#' @param git_repo Character. File path to your repository.
#' @author Frederik Sachser
#' @export
summary_git <- function(git_repo, filepath_git_summary) {
#  git2r::summary(git2r::repository(git_repo))
  if ("git2r" %in% utils::installed.packages()) {
  sink(filepath_git_summary)
  git2r::summary(git2r::repository(git_repo))
  sink()
  git2r::summary(git2r::repository(git_repo))
  }
}


