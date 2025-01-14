% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsl_colnames.R
\name{tsl_colnames_suffix}
\alias{tsl_colnames_suffix}
\title{Append Suffix to Column Names of Time Series List}
\usage{
tsl_colnames_suffix(tsl = NULL, suffix = NULL)
}
\arguments{
\item{tsl}{(required, list) Time series list. Default: NULL}

\item{suffix}{(optional, character string) String to append to the column names. Default: NULL.}
}
\value{
time series list
}
\description{
Append Suffix to Column Names of Time Series List
}
\examples{
tsl <- tsl_simulate()

tsl_colnames_get(tsl = tsl)

tsl <- tsl_colnames_suffix(
  tsl = tsl,
  suffix = "_my_suffix"
)

tsl_colnames_get(tsl = tsl)
}
\seealso{
Other tsl_management: 
\code{\link{tsl_burst}()},
\code{\link{tsl_colnames_clean}()},
\code{\link{tsl_colnames_get}()},
\code{\link{tsl_colnames_prefix}()},
\code{\link{tsl_colnames_set}()},
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
\code{\link{tsl_subset}()},
\code{\link{tsl_time}()},
\code{\link{tsl_to_df}()}
}
\concept{tsl_management}
