#' Number of rows of a Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#'
#' @return A list if each time series has a different number of rows, and a integer otherwise.
#' @export
#' @examples
#' @autoglobal
tsl_rows <- function(
    tsl = NULL,
    tsl_test = FALSE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  rows <- lapply(
    X = tsl,
    FUN = function(x){
      nrow(x)
    }
  )

  rows_unique <- rows |>
    unique()

  if(length(rows_unique) == 1){
    rows <- rows_unique[[1]]
  }

  rows

}
