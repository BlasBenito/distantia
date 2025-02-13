% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsl_subset.R
\name{tsl_subset}
\alias{tsl_subset}
\title{Subset Time Series Lists by Time Series Names, Time, and/or Column Names}
\usage{
tsl_subset(
  tsl = NULL,
  names = NULL,
  colnames = NULL,
  time = NULL,
  numeric_cols = TRUE,
  shared_cols = TRUE
)
}
\arguments{
\item{tsl}{(required, list) Time series list. Default: NULL}

\item{names}{(optional, character or numeric vector) Character vector of names or numeric vector with list indices. If NULL, all time series are kept. Default: NULL}

\item{colnames}{(optional, character vector) Column names of the zoo objects in \code{tsl}. If NULL, all columns are returned. Default: NULL}

\item{time}{(optional, numeric vector) time vector of length two used to subset rows by time. If NULL, all rows in \code{tsl} are preserved. Default: NULL}

\item{numeric_cols}{(optional, logical) If TRUE, only the numeric columns of the zoo objects are returned. Default: TRUE}

\item{shared_cols}{(optional, logical) If TRUE, only columns shared across all zoo objects are returned. Default: TRUE}
}
\value{
time series list
}
\description{
Subset Time Series Lists by Time Series Names, Time, and/or Column Names
}
\examples{
#initialize time series list
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

#checking available dimensions

#names
tsl_names_get(
  tsl = tsl
)

#colnames
tsl_colnames_get(
  tsl = tsl
)

#time
tsl_time(
  tsl = tsl
)[, c("name", "begin", "end")]

#subset
tsl_new <- tsl_subset(
  tsl = tsl,
  names = c("Sweden", "Germany"),
  colnames = c("rainfall", "temperature"),
  time = c("2010-01-01", "2015-01-01")
)

#check new dimensions

#names
tsl_names_get(
  tsl = tsl_new
)

#colnames
tsl_colnames_get(
  tsl = tsl_new
)

#time
tsl_time(
  tsl = tsl_new
)[, c("name", "begin", "end")]
}
\seealso{
Other tsl_management: 
\code{\link{tsl_burst}()},
\code{\link{tsl_colnames_clean}()},
\code{\link{tsl_colnames_get}()},
\code{\link{tsl_colnames_prefix}()},
\code{\link{tsl_colnames_set}()},
\code{\link{tsl_colnames_suffix}()},
\code{\link{tsl_count_NA}()},
\code{\link{tsl_diagnose}()},
\code{\link{tsl_handle_NA}()},
\code{\link{tsl_join}()},
\code{\link{tsl_names_clean}()},
\code{\link{tsl_names_get}()},
\code{\link{tsl_names_set}()},
\code{\link{tsl_names_test}()},
\code{\link{tsl_ncol}()},
\code{\link{tsl_nrow}()},
\code{\link{tsl_repair}()},
\code{\link{tsl_time}()},
\code{\link{tsl_to_df}()}
}
\concept{tsl_management}
