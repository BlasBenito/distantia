% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsl_repair.R
\name{tsl_repair}
\alias{tsl_repair}
\title{Repair Issues in Time Series Lists}
\usage{
tsl_repair(tsl = NULL, full = TRUE)
}
\arguments{
\item{tsl}{(required, list) Time series list. Default: NULL}

\item{full}{(optional, logical) If TRUE, a full repair (structure and values) is triggered. Otherwise, only the data structure is repaired Default: TRUE}
}
\value{
time series list
}
\description{
A Time Series List (\code{tsl} for short) is a list of zoo time series. This type of object, not defined as a class, is used throughout the \code{distantia} package to contain time series data ready for processing and analysis.

The structure and values of a \code{tsl} must fulfill several general conditions:

Structure:
\itemize{
\item The list names match the attributes "name" of the zoo time series
\item All zoo time series must have at least one shared column name.
\item Data in univariate zoo time series (as extracted by \code{zoo::coredata(x)}) must be of the class "matrix". Univariate zoo time series are often represented as vectors, but this breaks several subsetting and transformation operations implemented in this package.
}

Values (optional, when \code{full = TRUE}):
\itemize{
\item All time series have at least one shared numeric column.
\item There are no NA, Inf, or NaN values in the time series.
}

This function analyzes a \code{tsl}, and tries to fix all possible issues to make it comply with the conditions listed above without any user input. Use with care, as it might defile your data.
}
\examples{
#creating three zoo time series

#one with NA values
x <- zoo_simulate(
  name = "x",
  cols = 1,
  na_fraction = 0.1
  )

#with different number of columns
#wit repeated name
y <- zoo_simulate(
  name = "x",
  cols = 2
  )

#with different time class
z <- zoo_simulate(
  name = "z",
  cols = 1,
  time_range = c(1, 100)
  )

#adding a few structural issues

#changing the column name of x
colnames(x) <- c("b")

#converting z to vector
z <- zoo::zoo(
  x = runif(nrow(z)),
  order.by = zoo::index(z)
)

#storing zoo objects in a list
#with mismatched names
tsl <- list(
  a = x,
  b = y,
  c = z
)

#running full diagnose
tsl <- tsl_diagnose(
  tsl = tsl,
  full = TRUE
  )

tsl <- tsl_repair(tsl)
}
\seealso{
Other data_preparation: 
\code{\link{tsl_colnames_clean}()},
\code{\link{tsl_colnames_set}()},
\code{\link{tsl_diagnose}()},
\code{\link{tsl_handle_NA}()},
\code{\link{tsl_initialize}()},
\code{\link{tsl_names_clean}()},
\code{\link{tsl_names_set}()},
\code{\link{tsl_time_class_set}()},
\code{\link{zoo_name_get}()},
\code{\link{zoo_name_set}()},
\code{\link{zoo_to_tsl}()},
\code{\link{zoo_vector_to_matrix}()}
}
\concept{data_preparation}
