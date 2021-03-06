% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_log.R
\name{summary_log}
\alias{summary_log}
\title{write a log entry}
\usage{
summary_log(filepath_log = "log.csv")
}
\arguments{
\item{filepath_log}{Character. Specify file path to write the log file.}
}
\value{
A list of dataframes including information about duration of work per
  day, per nodename and both.
}
\description{
This function will summarize the information of a specific
  log-file.
}
\note{
The results are not necessarily as intended: It is assumed that you work once a day without breaks. Optionally adjust the logfile as well as the function log_summary to fit your needs.
}
\seealso{
\code{\link{write_log}}
}
\author{
Frederik Sachser
}
