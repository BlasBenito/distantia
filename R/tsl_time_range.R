#' Time Range of Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#'
#' @return A list if each time series has a different range, and a vector of length two otherwise.
#' @export
#' @examples
#' @autoglobal
tsl_time_range <- function(
    tsl = NULL,
    tsl_test = FALSE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  time <- lapply(
    X = tsl,
    FUN = function(x){
      range(stats::time(x))
    }
  )

  time_unique <- time |>
    unique()

  if(length(time_unique) == 1){
    time <- time_unique[[1]]
  }

  time

}
