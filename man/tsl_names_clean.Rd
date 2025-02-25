% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsl_names.R
\name{tsl_names_clean}
\alias{tsl_names_clean}
\title{Clean Time Series Names in a Time Series List}
\usage{
tsl_names_clean(
  tsl = NULL,
  lowercase = FALSE,
  separator = "_",
  capitalize_first = FALSE,
  capitalize_all = FALSE,
  length = NULL,
  suffix = NULL,
  prefix = NULL
)
}
\arguments{
\item{tsl}{(required, list) Time series list. Default: NULL}

\item{lowercase}{(optional, logical) If TRUE, all names are coerced to lowercase. Default: FALSE}

\item{separator}{(optional, character string) Separator when replacing spaces and dots. Also used to separate \code{suffix} and \code{prefix} from the main word. Default: "_".}

\item{capitalize_first}{(optional, logical) Indicates whether to capitalize the first letter of each name Default: FALSE.}

\item{capitalize_all}{(optional, logical) Indicates whether to capitalize all letters of each name Default: FALSE.}

\item{length}{(optional, integer) Minimum length of abbreviated names. Names are abbreviated via \code{\link[=abbreviate]{abbreviate()}}. Default: NULL.}

\item{suffix}{(optional, character string) Suffix for the clean names. Default: NULL.}

\item{prefix}{(optional, character string)  Prefix for the clean names. Default: NULL.}
}
\value{
time series list
}
\description{
Combines \code{\link[=utils_clean_names]{utils_clean_names()}} and \code{\link[=tsl_names_set]{tsl_names_set()}} to help clean, abbreviate, capitalize, and add a suffix or a prefix to time series list names.
}
\examples{
#initialize time series list
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

#original names
tsl_names_get(
  tsl = tsl
)

#abbreviate names
#---------------------------
tsl_clean <- tsl_names_clean(
  tsl = tsl,
  capitalize_first = TRUE,
  length = 4 #abbreviate to 4 characters
)

#new names
tsl_names_get(
  tsl = tsl_clean
)

#suffix and prefix
#---------------------------
tsl_clean <- tsl_names_clean(
  tsl = tsl,
  capitalize_all = TRUE,
  separator = "_",
  suffix = "fagus",
  prefix = "country"
)

#new names
tsl_names_get(
  tsl = tsl_clean
)
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
