#' Insert text to source make.R
#'
#' Call this function as an addin to insert preformatted text at the cursor position.
#'
#' @export
insert_srcmake_addin <- function() {
  rstudioapi::insertText("source('make.R')")
}