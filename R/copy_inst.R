#' Copy installed files
#'
#' @param pkg Character. Package name.
#' @param pkgdir Character. Sub directory of "inst".
#' @param targetdir Character. Path to target directory
#'
#' @export
copy_inst <- function(pkg = "framework", pkgdir = "templates", targetdir = "R") {
  require(pkg, character.only = TRUE)
  pkg_df <- utils::installed.packages()[file.path(utils::installed.packages()[, "LibPath"], utils::installed.packages()[, "Package"]) %in% path.package(pkg), , drop = FALSE]
  targetdir <- file.path(targetdir, paste0(pkg, "_", gsub("\\.", "-", pkg_df[, "Version"])))
  dir.create(path = targetdir, showWarnings = FALSE, recursive = TRUE)
  pkg_files <- list.files(system.file(pkgdir, package = pkg), full.names = TRUE)
  lapply(X = pkg_files, FUN = file.copy, to = targetdir, recursive = TRUE)
}
