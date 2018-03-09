#' Initialize a git repo
#'
#' @description Initialize a git repo within the current working directory.
#' @return Add and commit all existing files to branch master. Afterwards
#'   checkout to a newly created branch 'devel'.
#' @author Frederik Sachser
#' @export
git_init <- function() {
  repo <- git2r::init(path = ".")
  git2r::add(repo, "*")
  git2r::commit(repo, message = "v0.0.0.9000")
  git2r::checkout(object = repo, branch = "devel", create = TRUE)
#  system('git init')
#  system("git add .")
#  system("git commit -m 'v0.0.0.9000'")
#  system('git checkout -b devel')
  message("commit master and checkout devel: done")
}
