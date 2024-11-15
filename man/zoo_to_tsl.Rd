% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zoo_to_tsl.R
\name{zoo_to_tsl}
\alias{zoo_to_tsl}
\title{Convert Individual Zoo Objects to Time Series List}
\usage{
zoo_to_tsl(x = NULL)
}
\arguments{
\item{x}{(required, zoo object) Time series. Default: NULL}
}
\value{
time series list of length one.
}
\description{
Internal function to wrap a zoo object into a time series list.
}
\examples{
#create zoo object
x <- zoo_simulate()
class(x)

#to time series list
tsl <- zoo_to_tsl(
  x = x
)

class(tsl)
class(tsl[[1]])
names(tsl)
attributes(tsl[[1]])$name
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
\code{\link{tsl_names_test}()},
\code{\link{tsl_repair}()},
\code{\link{tsl_time_class_set}()},
\code{\link{zoo_name_clean}()},
\code{\link{zoo_name_get}()},
\code{\link{zoo_name_set}()},
\code{\link{zoo_vector_to_matrix}()}
}
\concept{data_preparation}
