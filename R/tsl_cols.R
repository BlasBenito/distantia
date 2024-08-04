#' Number of Columns of a Time Series List
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#'
#' @return A list if each time series has a different number of columns, and a integer otherwise.
#' @export
#' @examples
#' TODO: complete example
#' @autoglobal
tsl_cols <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
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
