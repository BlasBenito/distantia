#' Aggregates Time Series List
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param breaks (required, numeric, numeric vector, or keyword) definition of the aggregation groups across time. Valid options, arranged per time class, are:
#' \itemize{
#'   \item keyword:
#'   \itemize{
#'     \item Date (ISO 8601 standard YYYY-MM-DD): "millennia", "centuries", "decades", "years", "quarters", "months", and "weeks".
#'     \item POSIXct (ISO 8601 standard YYYY-MM-DD): All of the above plus "hours", "mins", and "secs".
#'     \item numeric (arbitrary time):
#'   \item POSIXct (ISO 8601 standard YYYY-MM-DD):
#'   \item numeric:
#'
#'   keyword: For class Date in format "YYYY-MM-DD" or POSIXct "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
#' }
#' @param stat (required, function) name without quotes and parenthesis of a standard function to smooth a time series. Typical examples are `mean` (default), `max`,`min`, `median`, and `sd`. Default: `mean`.
#'
#' @return time series list
#' @export
#'
#' @examples
tsl_aggregate <- function(
    tsl = NULL,
    breaks = NULL,
    f = mean,
    quiet = TRUE,
    ...
){

  breaks <- utils_time_breaks(
    tsl = tsl,
    breaks = breaks
  )

  if(quiet == FALSE){
    message(
      "Aggregation breaks: ",
      paste(breaks, collapse = ", ")
      )
  }

  tsl <- lapply(
    X = tsl,
    FUN = function(x){

      # x <- tsl[[1]]

      x <- zoo_aggregate(
        x = x,
        breaks = breaks,
        f = f#,
        # ... = ...
      )

    }
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
