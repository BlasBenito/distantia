% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zoo_names.R
\name{zoo_name_get}
\alias{zoo_name_get}
\title{Get Name of a Zoo Time Series}
\usage{
zoo_name_get(x = NULL)
}
\arguments{
\item{x}{(required, zoo object) Zoo time series to analyze. Default: NULL.}
}
\value{
character string
}
\description{
Just a convenient wrapper of \code{attributes(x)$name}.
}
\examples{
#simulate zoo time series
x <- zoo_simulate()

#get current name
zoo_name_get(x = x)

#change name
x <- zoo_name_set(
  x = x,
  name = "My.New.name"
)

zoo_name_get(x = x)

#clean name
x <- zoo_name_clean(
  x = x,
  lowercase = TRUE
)

zoo_name_get(x = x)
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
\code{\link{zoo_name_set}()},
\code{\link{zoo_to_tsl}()},
\code{\link{zoo_vector_to_matrix}()}
}
\concept{data_preparation}
