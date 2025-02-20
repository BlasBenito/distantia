% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsl_names.R
\name{tsl_names_set}
\alias{tsl_names_set}
\title{Set Time Series Names in a Time Series List}
\usage{
tsl_names_set(tsl = NULL, names = NULL)
}
\arguments{
\item{tsl}{(required, list) Time series list. Default: NULL}

\item{names}{(optional, character vector) names to set. Must be of the same length of \code{x}. If NULL, and the list \code{x} has names, then the names of the zoo objects inside of the list are taken from the names of the list elements.}
}
\value{
time series list
}
\description{
Sets the names of a time series list and the internal names of the zoo objects inside, stored in their attribute "name".
}
\examples{
#simulate time series list
tsl <- tsl_simulate(n = 3)

#assess validity
tsl_diagnose(
  tsl = tsl
)

#list and zoo names (default)
tsl_names_get(
  tsl = tsl
)

#list names
tsl_names_get(
  tsl = tsl,
  zoo = FALSE
)

#renaming list items and zoo objects
#------------------------------------
tsl <- tsl_names_set(
  tsl = tsl,
  names = c("X", "Y", "Z")
)

# check new names
tsl_names_get(
  tsl = tsl
)

#fixing naming issues
#------------------------------------

#creating a invalid time series list
names(tsl)[2] <- "B"

# check names
tsl_names_get(
  tsl = tsl
)

#validate tsl
#returns NOT VALID
#recommends a solution
tsl_diagnose(
  tsl = tsl
)

#fix issue with tsl_names_set()
#uses names of zoo objects for the list items
tsl <- tsl_names_set(
  tsl = tsl
)

#validate again
tsl_diagnose(
  tsl = tsl
)

#list names
tsl_names_get(
  tsl = tsl
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
\code{\link{tsl_names_clean}()},
\code{\link{tsl_names_get}()},
\code{\link{tsl_names_test}()},
\code{\link{tsl_ncol}()},
\code{\link{tsl_nrow}()},
\code{\link{tsl_repair}()},
\code{\link{tsl_subset}()},
\code{\link{tsl_time}()},
\code{\link{tsl_to_df}()}
}
\concept{tsl_management}
