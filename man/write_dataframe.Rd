\name{write_dataframe}
\alias{write_dataframe}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
write multiple dataframes to rds or csv 
}
\description{
Function to write multiple dataframes as rds or csv.
}
\usage{
write_dataframe(listofdf = "GlobalEnv", output_dir = "standard", file_format = "rds")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{listofdf}{
List of dataframes provided as names (character). Unless otherwise specified the funtion includes all data frames of the Globel Environment. 
}
  \item{output_dir}{
Target directory. Unless otherwise specified this would be a subdirectory 'data/output' of the current working directory.
}
  \item{file_format}{
Character. Choose between 'rds' (default) and 'csv'.
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
write_dataframe()
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ write_dataframe }
