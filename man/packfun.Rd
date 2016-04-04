\name{packfun}
\alias{packfun}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
install and load packages
}
\description{
Function to install packages if needed and optionally loads them.
}
\usage{
packfun(packlist = ..., NAMESPACE_only = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{packlist}{
list of packages that should be installed and optionally loaded
}
  \item{NAMESPACE_only}{
logical. If TRUE the packages will be installed but not loaded. 
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
packfun(packlist = list('dplyr', 'ggplot2'))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ packfun }
