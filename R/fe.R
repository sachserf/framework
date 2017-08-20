#' Alias for file.edit()
#'
#' @description This function is just a (shorter) assignment for file.edit().
#' @param ... Arguments passed to file.edit().
#' @seealso \code{\link[utils]{file.edit}}
#' @export
fe <- function(...) {
  utils::file.edit(...)
}