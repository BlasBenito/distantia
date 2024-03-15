#' Time Range of Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#'
#' @return A list if each time series has a different range, and a vector of length two otherwise.
#' @export
#' @examples
#' @autoglobal
tsl_time_range <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
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
