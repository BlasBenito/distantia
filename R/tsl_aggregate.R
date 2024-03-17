#' Aggregates Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param breaks (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
#' \itemize{
#'   \item keyword: Only when time in tsl is either a date "YYYY-MM-DD" or a datetime "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
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
    ...
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  if(is.function(f) == FALSE){

    stop(
      "Argument 'f' must be a function name. A few valid options are 'mean', 'median', 'max', 'min', and 'sd', among others.")

  }

  breaks <- utils_time_breaks(
    tsl = tsl,
    breaks = breaks
  )

  #aggregate here


  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
