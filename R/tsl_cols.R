#' Number of Columns of a Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#'
#' @return A list if each time series has a different number of columns, and a integer otherwise.
#' @export
#' @examples
#' @autoglobal
tsl_cols <- function(
    tsl = NULL,
    tsl_test = FALSE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  cols <- lapply(
    X = tsl,
    FUN = function(x){
      ncol(x)
    }
  )

  cols_unique <- cols |>
    unique()

  if(length(cols_unique) == 1){
    cols <- cols_unique[[1]]
  }

  cols

}
