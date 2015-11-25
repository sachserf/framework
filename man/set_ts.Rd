\name{set_ts}
\alias{set_ts}
\title{
create directory named by timestamp
}
\description{
The function creates a directory named by the current time. Optionally a sub directory containing additional information (history, image, SessionInfo, etc.) is integrated. Furthermore it is possible to copy a specified directory or files. Unless otherwise specified the target directory will be within the current working directory.
}
\usage{
set_ts(target_dir = getwd(), cp = FALSE, info = FALSE, changewd = FALSE)
}
\arguments{
  \item{target_dir}{
  Optional. Character specifying the target directory (recursive). Default is the current working directory.
}
  \item{cp}{
  Optional. Character specifying a directory or file to copy and paste.
}
  \item{info}{
  Optional. Logical value. If TRUE a sub directory containing additional information (history, image, SessionInfo, etc.) is integrated.
}
  \item{changewd}{
  Optional. Logical value. If TRUE the working directory will be changed.
}
}
\value{
The output is a directory within the target directory. Optionally there are two subfolders integrated. These are called 'copy' and 'info'.
}
\author{
Frederik Sachser
}
\examples{
set_ts()
}
\keyword{ set_ts }
