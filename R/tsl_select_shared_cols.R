#' Select Shared Columns from a Time Series List
#'
#' @description
#' Returns a time series list with only the columns shared across all zoo time series.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
tsl_select_shared_cols <- function(
    tsl = NULL
){

  #validity check
  tsl <- tsl_is_valid(
    tsl = tsl
  )

  tsl.exclusive <- tsl_colnames_get(
    tsl = tsl,
    names = "exclusive"
  ) |>
    unlist() |>
    unique()

  if(is.null(tsl.exclusive)){
    return(tsl)
  }

  tsl <- lapply(
    X = tsl,
    FUN = function(x){
      x[ , !(colnames(x) %in% tsl.exclusive)]
    }
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
