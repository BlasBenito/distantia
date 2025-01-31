% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsl_colnames.R
\name{tsl_colnames_get}
\alias{tsl_colnames_get}
\title{Get Column Names from a Time Series Lists}
\usage{
tsl_colnames_get(tsl = NULL, names = c("all", "shared", "exclusive"))
}
\arguments{
\item{tsl}{(required, list) Time series list. Default: NULL}

\item{names}{(optional, character string) Three different sets of column names can be requested:
\itemize{
\item "all" (default): list with the column names in each zoo object in \code{tsl}. Unnamed columns are tagged with the string "unnamed".
\item "shared": character vector with the shared column names in at least two zoo objects in \code{tsl}.
\item "exclusive": list with names of exclusive columns (if any) in each zoo object in \code{tsl}.
}}
}
\value{
list
}
\description{
Get Column Names from a Time Series Lists
}
\examples{
#generate example data
tsl <- tsl_simulate()

#list all column names
tsl_colnames_get(
  tsl = tsl,
  names = "all"
)

#change one column name
names(tsl[[1]])[1] <- "new_column"

#all names again
tsl_colnames_get(
  tsl = tsl,
  names = "all"
)

#shared column names
tsl_colnames_get(
  tsl = tsl,
  names = "shared"
)

#exclusive column names
tsl_colnames_get(
  tsl = tsl,
  names = "exclusive"
)
}
\seealso{
Other tsl_management: 
\code{\link{tsl_burst}()},
\code{\link{tsl_colnames_clean}()},
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
\code{\link{tsl_subset}()},
\code{\link{tsl_time}()},
\code{\link{tsl_to_df}()}
}
\concept{tsl_management}
