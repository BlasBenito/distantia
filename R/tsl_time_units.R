#' Time Units of a Time Series List
#'
#' @description
#' Returns keywords representing the time units available in the 'index' attribute of the zoo time series within a time series list.
#'
#' If the 'index' attribute is of the class "Date", then this function searches for the highest and lowest units of variability in the range of dates, and returns them along with all the units in between. All possible unit keywords are: "millennium", "century", "decade", "year", "quarter", "month", "week", "day", "hour", "minute", "second". For example, if the argument 'tsl' has a range of dates c("2020-02-01" "2023-12-19"), since the difference between years is higher than 1 and the difference between days is higher than one, then the returned units are c("year", "quarter", "month", "week", and "day").
#'
#' If the 'index' attribute is of the class 'numeric', then the then this function searches for the highest and lowest units of variability in the range of dates, and returns them along with all the units in between. All possible unit keywords are: "1e6" (million), "1e5" (one hundred thousand), "1e3" (ten thousand), "1e3" (thousand), "1e2" (hundred), "1e1" (ten). For example, for the range of numeric times c(-100000, 2000), the units returned are c("1e5", "1e4", "1e3", "1e2", "1e1").
#'
#'
#' @param tsl (required, list of zoo objects) Time series list. Default: NULL
#'
#' @return List of character vector or character vector with the time units.
#' @export
#' @examples
#' @autoglobal
tsl_time_units <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  time_units_list <- lapply(
    X = tsl,
    FUN = zoo_time_units
  )

  time_units_unique <- time_units_list |>
    unique()

  if(length(time_units_unique) == 1){
    time_units <- time_units_unique[[1]]
  } else {
    time_units <- time_units_unique
    warning(
      "The time units of all elements in 'tsl' must be the same. Having different time units in a 'tsl' object might cause unintended issues in other functions of this package.",
      call. = FALSE
      )
  }

  time_units

}
