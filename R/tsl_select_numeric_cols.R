#' Select Numeric Columns from a Time Series List
#'
#' @description
#' Returns a time series list with only the numeric columns in all zoo time series.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
tsl_select_numeric_cols <- function(
    tsl = NULL
){

  #validity check
  tsl <- tsl_is_valid(
    tsl = tsl
  )

  tsl <- lapply(
    X = tsl,
    FUN = function(x){
      x[, sapply(X = x, FUN = is.numeric)]
    }
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
