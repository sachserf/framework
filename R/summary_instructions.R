#' summary_instructions
#' @description summary_instructions
#' @export
summary_instructions <- function(csv_file = "summary_instructions.csv") {
    cat("\n--------------------------------------------\n\nSummary of executed instructions:\n\n")
    print(read.csv(csv_file))
    cat("\n--------------------------------------------\n")
#    unlink(csv_file)
}
