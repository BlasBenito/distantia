#' Aggregates Time Series List
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param breaks (required, numeric, numeric vector, Date vector, POSIXct vector, or keyword) breakpoints defining aggregation groups. Options are:
#' \itemize{
#'   \item numeric vector: only for the "numeric" time class, defines the breakpoints for time series aggregation.
#'   \item "Date" or "POSIXct" vector: as above, but for the time classes "Date" and "POSIXct." In any case, the input vector is coerced to the time class of the `tsl` argument.
#'   \item numeric: defines fixed with time intervals for time series aggregation. Used as is when the time class is "numeric", and coerced to integer and interpreted as days for the time classes "Date" and "POSIXct".
#'   \item keyword (see [utils_time_units()]): the common options for the time classes "Date" and "POSIXct" are: "millennia", "centuries", "decades", "years", "quarters", "months", and "weeks". Exclusive keywords for the "POSIXct" time class are: "days", "hours", "minutes", and "seconds". The time class "numeric" accepts keywords coded as scientific numbers, from "1e8" to "1e-8".
#' }
#' @param f (required, function) name without quotes and parenthesis of a standard or user-defined function to aggregate a vector series. Typical examples are `mean`, `max`,`min`, `median`, and `sd`, but others such as [f_slope()] are available as well. Default: `mean`.
#' @param ... (optional) further arguments for `f`.
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

  breaks <- utils_time_breaks(
    tsl = tsl,
    breaks = breaks
  )

  tsl <- lapply(
    X = tsl,
    FUN = function(x, ...){

      # x <- tsl[[1]]

      x <- zoo_aggregate(
        x = x,
        breaks = breaks,
        f = f,
        ... = ...
      )

    },
    ... = ...
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
