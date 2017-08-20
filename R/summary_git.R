summary_git <- function(git_repo) {
#  git2r::summary(git2r::repository(git_repo))
  if ("git2r" %in% installed.packages()) {
  sink("meta/git_summary.txt")
  git2r::summary(git2r::repository(git_repo))
  sink()
  git2r::summary(git2r::repository(git_repo))
  }
}


