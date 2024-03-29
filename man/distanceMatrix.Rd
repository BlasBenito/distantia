% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distanceMatrix.R
\name{distanceMatrix}
\alias{distanceMatrix}
\title{Computes distance matrices among the samples of two or more multivariate time-series.}
\usage{
distanceMatrix(
  sequences = NULL,
  grouping.column = NULL,
  time.column = NULL,
  exclude.columns = NULL,
  method = "manhattan",
  parallel.execution = TRUE
  )
}
\arguments{
\item{sequences}{dataframe with multiple sequences identified by a grouping column. Generally the ouput of \code{\link{prepareSequences}}.}

\item{grouping.column}{character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.}

\item{time.column}{character string, name of the column with time/depth/rank data. The data in this column is not modified.}

\item{exclude.columns}{character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.}

\item{method}{character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.}

\item{parallel.execution}{boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.}
}
\value{
A list with named slots containing the the distance matrices of every possible combination of sequences according to \code{grouping.column}.
}
\description{
Computes distance matrices among the samples of two or more multivariate time-series provided in a single dataframe (generally produced by \code{\link{prepareSequences}}), identified by a grouping column (argument \code{grouping.column}). Distances can be computed with the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}. The function uses the packages \code{\link[parallel]{parallel}}, \code{\link[foreach]{foreach}}, and \code{\link[doParallel]{doParallel}} to compute distances matrices among different sequences in parallel. It is configured to use all processors available minus one.
}
\details{
Distances are computed as:
\itemize{
\item \code{manhattan}: \code{d <- sum(abs(x - y))}
\item \code{euclidean}: \code{d <- sqrt(sum((x - y)^2))}
\item \code{chi}: \code{
    xy <- x + y
    y. <- y / sum(y)
    x. <- x / sum(x)
    d <- sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))}
\item \code{hellinger}: \code{d <- sqrt(1/2 * sum(sqrt(x) - sqrt(y))^2)}
}
Note that zeroes are replaced by 0.00001 whem \code{method} equals "chi" or "hellinger".
}
\examples{

#loading data
data(sequenceA)
data(sequenceB)

#preparing datasets
AB.sequences <- prepareSequences(
 sequence.A = sequenceA,
 sequence.A.name = "A",
 sequence.B = sequenceB,
 sequence.B.name = "B",
 merge.mode = "complete",
 if.empty.cases = "zero",
 transformation = "hellinger"
 )

#computing distance matrix
AB.distance.matrix <- distanceMatrix(
 sequences = AB.sequences,
 grouping.column = "id",
 method = "manhattan",
 parallel.execution = FALSE
 )


#plot
if(interactive()){
 plotMatrix(distance.matrix = AB.distance.matrix)
}


}
\seealso{
\code{\link{distance}}
}
\author{
Blas Benito <blasbenito@gmail.com>
}
