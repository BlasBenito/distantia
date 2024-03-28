#' Time Resolution of a Time Series List
#'
#' @description
#' For irregular time series it returns the average resolution of each zoo object in the time series list via the expression `mean(diff(stats::time(zoo_object)))`
#'
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#'
#' @return A list if each time series has a different range, and a vector of length two otherwise.
#' @export
#' @examples
#' @autoglobal
tsl_time_resolution <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  lapply(
    X = tsl,
    FUN = zoo_time_resolution
  ) |>
    utils_simplify_list()

}
