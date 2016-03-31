\name{project_skeleton}
\alias{project_skeleton}
\title{
Create an empty project skeleton
}
\description{
The function creates directories, a few empty files, a template for a report and a make-like file. 
}
\usage{
project_skeleton()
}
\value{
The output are several files and directories within your working directory.
}
\references{
By calling the function a latex title page will be created ('/reports/Rmd_pdf/preamble/title_page.tex'), which was adapted from http://www.latextemplates.com/template/minimalist-book-title-page. The original template as well as the modified document is licensed under CC Attribution-NC-SA (http://creativecommons.org/licenses/by-nc-sa/3.0/).
}
\author{
Frederik Sachser
}
\note{
The files and directories will not overwrite existing files or directories.
}
\examples{
project_skeleton()
}
\keyword{ project_skeleton }
\keyword{ project_framework }
