% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/autoSum.R
\name{autoSum}
\alias{autoSum}
\title{Computes sum of distances between consecutive samples in a multivariate time-series.}
\usage{
autoSum(
  sequences = NULL,
  least.cost.path = NULL,
  time.column = NULL,
  grouping.column = NULL,
  exclude.columns = NULL,
  method = "manhattan",
  parallel.execution = TRUE
  )
}
\arguments{
\item{sequences}{dataframe with one or several multivariate time-series identified by a grouping column.}

\item{least.cost.path}{a list usually resulting from either \code{\link{leastCostPath}} or \code{\link{leastCostPathNoBlocks}}.}

\item{time.column}{character string, name of the column with time/depth/rank data. The data in this column is not modified.}

\item{grouping.column}{character string, name of the column in \code{sequences} to be used to identify separates sequences within the file. This argument is ignored if \code{sequence.A} and \code{sequence.B} are provided.}

\item{exclude.columns}{character string or character vector with column names in \code{sequences}, or \code{squence.A} and \code{sequence.B} to be excluded from the analysis.}

\item{method}{character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.}

\item{parallel.execution}{boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.}
}
\value{
A list with slots named according \code{grouping.column} if there are several sequences in \code{sequences} or a number if there is only one sequence.
}
\description{
Computes the sum of distances between consecutive samples in a multivariate time-series. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed through the methods "manhattan", "euclidean", "chi", and "hellinger", and are implemented in the function \code{\link{distance}}.
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

\donttest{
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

#computing least cost matrix
AB.least.cost.matrix <- leastCostMatrix(
 distance.matrix = AB.distance.matrix,
 diagonal = FALSE,
 parallel.execution = FALSE
 )

AB.least.cost.path <- leastCostPath(
 distance.matrix = AB.distance.matrix,
 least.cost.matrix = AB.least.cost.matrix,
 parallel.execution = FALSE
 )

#autosum
AB.autosum <- autoSum(
 sequences = AB.sequences,
 least.cost.path = AB.least.cost.path,
 grouping.column = "id",
 parallel.execution = FALSE
 )
AB.autosum

}

}
\seealso{
\code{\link{distance}}
}
\author{
Blas Benito <blasbenito@gmail.com>

\itemize{
\item Birks, H.J.B.  and Gordon, A.D. (1985) Numerical Methods in Quaternary Pollen Analysis. Academic Press.
}
}
