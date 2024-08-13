#' Number of rows of a Time Series List
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @return A list if each time series has a different number of rows, and a integer otherwise.
#' @export
#' @examples
#' TODO: complete example
#' @autoglobal
tsl_rows <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
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
