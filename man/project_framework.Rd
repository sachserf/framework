\name{project_framework}
\alias{project_framework}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Create a project framework from scratch
}
\description{
The function will create a new directory and change the working directory. Furthermore it is a wrapper for project_skeleton, Rproj_init and git_init. Therefore it is straightforward to create a new project, generate basic directories and initialize a git repository. Optionally you can include packrat.
}
\usage{
project_framework(dirname, init_Rproj = TRUE, init_git = TRUE, init_packrat = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dirname}{
Choose a new or still existing directory for the project. 
}
}
\arguments{
  \item{init_Rproj}{
logical. Default = TRUE. Initializes a Rproj. The name of the target directory (dirname) will be the project name. 
}
}
\arguments{
  \item{init_git}{
logical. Default = TRUE. If TRUE and git is installed a git repository will be created.
}
}
\arguments{
  \item{init_packrat}{
logical. Default = FALSE. If TRUE packrat will be installed and initialized. 
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
project_framework()
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ project_framework }
\keyword{ project_skeleton }
\keyword{ Rproj_init }
\keyword{ git_init }
