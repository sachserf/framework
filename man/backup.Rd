\name{backup}
\alias{backup}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
copy paste a directory 
}
\description{
The function copies directories (including hidden files and subdirectories). It creates a directory called BACKUP_'target_folder' and a subdirectory named by the current date and time. Optionally the target directory is deleted before pasting the source directory. If the target directory is a subdirectory of the source directory the target directory itself will not be copied!}
\usage{
backup(target_dir = "project_subdir", source_dir = file.path(getwd()), overwrite = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{target_dir}{
target directory. Unless otherwise specified this will be a subdirectory of the source directory.
}
  \item{source_dir}{
source directory. Unless otherwise specified this will be the current working directory.
}
  \item{overwrite}{
logical. If TRUE the target directory will be deleted before copying the source directory.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Frederik Sachser
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
backup()
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ backup }
