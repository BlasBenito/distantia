% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distance_matrix.R
\name{distance_matrix}
\alias{distance_matrix}
\title{Data Frame to Distance Matrix}
\usage{
distance_matrix(df = NULL, name_column = NULL, distance = "euclidean")
}
\arguments{
\item{df}{(required, data frame) Data frame with numeric columns to transform into a distance matrix. Default: NULL}

\item{name_column}{(optional, column name) Column naming individual time series. Numeric names are converted to character with the prefix "X". Default: NULL}

\item{distance}{(optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset \link{distances}. Default: "euclidean".}
}
\value{
square matrix
}
\description{
Data Frame to Distance Matrix
}
\examples{
#compute distance matrix
m <- distance_matrix(
  df = cities_coordinates,
  name_column = "name",
  distance = "euclidean"
)

#get data used to compute the matrix
attributes(m)$df

#check matrix
m

}
\seealso{
Other distances: 
\code{\link{distance}()},
\code{\link{distances}}
}
\concept{distances}
