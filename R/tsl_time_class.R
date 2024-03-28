#' Time Class of Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#'
#' @return A list if each time series has a different range, and a character string with the class name otherwise.
#' @export
#' @examples
#' @autoglobal
tsl_time_class <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  lapply(
    X = tsl,
    FUN = zoo_time_class
  ) |>
    utils_simplify_list()

}
