% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/workflowNullPsi.R
\name{workflowNullPsi}
\alias{workflowNullPsi}
\title{Computes the dissimilarity measure \emph{psi} on restricted permutations of two or more sequences.}
\usage{
workflowNullPsi(
  sequences = NULL,
  grouping.column = NULL,
  time.column = NULL,
  exclude.columns = NULL,
  method = "manhattan",
  diagonal = FALSE,
  paired.samples = FALSE,
  same.time = FALSE,
  ignore.blocks = FALSE,
  parallel.execution = TRUE,
  repetitions = 9
  )
}
\arguments{
\item{sequences}{dataframe with multiple sequences identified by a grouping column generated by \code{\link{prepareSequences}}.}

\item{grouping.column}{character string, name of the column in \code{sequences} to be used to identify separates sequences within the file.}

\item{time.column}{character string, name of the column with time/depth/rank data.}

\item{exclude.columns}{character string or character vector with column names in \code{sequences} to be excluded from the analysis.}

\item{method}{character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.}

\item{diagonal}{boolean, if \code{TRUE}, diagonals are included in the computation of the least cost path. Defaults to \code{FALSE}, as the original algorithm did not include diagonals in the computation of the least cost path. If \code{paired.samples} is \code{TRUE}, then \code{diagonal} is irrelevant.}

\item{paired.samples}{boolean, if \code{TRUE}, the sequences are assumed to be aligned, and distances are computed for paired-samples only (no distance matrix required). Default value is \code{FALSE}.}

\item{same.time}{boolean. If \code{TRUE}, samples in the sequences to compare will be tested to check if they have the same time/age/depth according to \code{time.column}. This argument is only useful when the user needs to compare two sequences taken at different sites but same time frames.}

\item{ignore.blocks}{boolean. If \code{TRUE}, the function \code{\link{leastCostPathNoBlocks}} analyzes the least-cost path of the best solution, and removes blocks (straight-orthogonal sections of the least-cost path), which happen in highly dissimilar sections of the sequences, and inflate output psi values.}

\item{parallel.execution}{boolean, if \code{TRUE} (default), execution is parallelized, and serialized if \code{FALSE}.}

\item{repetitions}{integer, number of null psi values to obtain.}
}
\value{
A list with two slots:
\itemize{
\item \emph{psi}: a dataframe. The first two columns contain the names of the sequences being compared, the third column contains the real \code{psi} value, and the rest of the column contain \code{psi} values computed on permutated versions of the datasets.
\item \emph{p}: a dataframe. The first two columns are as above, the third column contains the probability of obtaining a \code{random psi} lower than the real \code{psi} by chance.
}
}
\description{
The function first computes psi on the observed sequences, and then computes it on permutations of the input sequences by the \code{repetitions} argument. The data is randomized as follows: within each column, each data-point can be: 1) left as is; 2) replaced by the previous case; 3) replaced by the next case. The action applied to each data-point is selected randomly, and independently from the actions applied to other data-points. This type of randomization generates versions of the dataset that have the same general structure as the original one, but small local and independent changes only ocurring within the immediate neighborhood (one row up or down) of each case in the table. The method should generate very conservative random values of \code{psi}.
}
\examples{

\donttest{
#load data
data("sequencesMIS")

#prepare sequences
MIS.sequences <- prepareSequences(
  sequences = sequencesMIS,
  grouping.column = "MIS",
  transformation = "hellinger"
  )

#execute workflow to compute psi
MIS.null.psi <- workflowNullPsi(
 sequences = MIS.sequences[MIS.sequences$MIS \%in\% c("MIS-1", "MIS-2"), ],
 grouping.column = "MIS",
 method = "manhattan",
 repetitions = 3,
 parallel.execution = FALSE
 )

MIS.null.psi
}

}
\author{
Blas Benito <blasbenito@gmail.com>
}
