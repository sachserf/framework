% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/template_rmd.R
\name{template_rmd}
\alias{template_rmd}
\title{Create a template script-file}
\usage{
template_rmd(file, Author = Sys.info()["effective_user"],
  Date = "`r Sys.Date()`", open = TRUE, doctype = "html",
  knitr_sidecar = FALSE)
}
\arguments{
\item{file}{Character. Specify the path to save the new file. Use relative
file paths and specify the file extension; e.g. 'filesnew_dir/myfile.Rmd'.
or 'in/src/new_dir/myfile.R'. If the extension is neither .R nor .Rmd (e.g.
no extension) an .R-extension will be added by default.}

\item{Author}{Character. Optionally customize the name of the Author (used
for the YAML header). Default is the effective user of the system info.}

\item{Date}{Character. Optionally customize the date (used for the YAML
header). Default is the current Date (format YYYY-MM-DD).}

\item{open}{Logical. If TRUE the file will be opened (via `file.edit``).}

\item{doctype}{Character. Specify file extension for different output formats
of Rmd-files (pdf, html, docx).}

\item{knitr_sidecar}{Logical. Write sidecar file for knitr-setup?}
}
\description{
This function will create an R or Rmd-file (depending on the
  file extension of the input) including some predefined lines. The function
  is designed to save some time writing the same input again and again (e.g.
  Author, date and other things). By using this template all warnings and
  messages will be written to a file ('filename_warnings.Rout') and errors
  will interupt rendering.
}
\note{
Missing directories will be created recursively.

It is not possible to overwrite existing files.

Other YAML header options will be choosen automatically. Edit the
  resulting file to customize the YAML header.

R files will be ready to be spinned via knitr. Therefore the script
  contains some preceding roxygen comments.
}
\author{
Frederik Sachser
}
