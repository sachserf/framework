#' write a log entry
#' 
#' @description This function will summarize the information of a specific
#'   log-file.
#' @return A list of dataframes including information about duration of work per
#'   day, per nodename and both.
#' @note The results are not necessarily as intended: It is assumed that you work once a day without breaks. Optionally adjust the logfile as well as the function log_summary to fit your needs.
#' @inheritParams project_framework
#' @seealso \code{\link{log_entry}}
#' @author Frederik Sachser
#' @export
log_summary <-
  function(log_filepath = "log.csv") {
    # read table
    df <-
      utils::read.table(log_filepath, header = TRUE, row.names = NULL)
    # convert posix
    df$POSIX <- as.POSIXct(df$POSIX)
    # create log summary
    per_DATE_NODENAME <- df %>%
      dplyr::group_by(NODENAME, DATE, WEEKDAY) %>%
      dplyr::summarise(MIN = min(POSIX), MAX = max(POSIX)) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(
        DIFF_HOURS = difftime(MAX, MIN, units = "hours"),
        DIFF_MINS = difftime(MAX, MIN, units = "mins")
      ) %>%
      dplyr::arrange(MIN)
    per_NODENAME <- per_DATE_NODENAME %>%
      dplyr::group_by(NODENAME) %>%
      dplyr::summarise(SUM_HOURS = sum(DIFF_HOURS), SUM_MINS = sum(DIFF_MINS), N_DATE = length(unique(DATE))) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(SUM_MINS)
    
    per_DATE <- per_DATE_NODENAME %>%
      dplyr::group_by(DATE, WEEKDAY) %>%
      dplyr::summarise(SUM_HOURS = sum(DIFF_HOURS), SUM_MINS = sum(DIFF_MINS), N_NODENAME = length(unique(NODENAME))) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(DATE)
    
    log_summaries <- list("per_DATE_NODENAME" = per_DATE_NODENAME, "per_NODENAME" = per_NODENAME, "per_DATE" = per_DATE)
    
    print(log_summaries)
    invisible(log_summaries)
  }