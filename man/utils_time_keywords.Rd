% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils_time_keywords.R
\name{utils_time_keywords}
\alias{utils_time_keywords}
\title{Valid Aggregation Keywords}
\usage{
utils_time_keywords(tsl = NULL)
}
\arguments{
\item{tsl}{(required, list) Time series list. Default: NULL}
}
\value{
Character string, aggregation keyword, or "none".
}
\description{
Internal function to obtain valid aggregation keywords from a zoo object or a time series list.
}
\examples{
#one minute time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.time() - 60,
    Sys.time()
  )
)

#valid keywords for aggregation and/or resampling
utils_time_keywords(
  tsl = tsl
)

#10 minutes time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.time() - 600,
    Sys.time()
  )
)

utils_time_keywords(
  tsl = tsl
)

#10 hours time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.time() - 6000,
    Sys.time()
  )
)

utils_time_keywords(
  tsl = tsl
)

#10 days time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.Date() - 10,
    Sys.Date()
  )
)

utils_time_keywords(
  tsl = tsl
)

#10 years time series
#-----------------------------------
tsl <- tsl_simulate(
  time_range = c(
    Sys.Date() - 3650,
    Sys.Date()
  )
)

utils_time_keywords(
  tsl = tsl
)
}
\seealso{
Other internal_time_handling: 
\code{\link{utils_as_time}()},
\code{\link{utils_coerce_time_class}()},
\code{\link{utils_is_time}()},
\code{\link{utils_new_time}()},
\code{\link{utils_time_keywords_dictionary}()},
\code{\link{utils_time_keywords_translate}()},
\code{\link{utils_time_units}()}
}
\concept{internal_time_handling}
