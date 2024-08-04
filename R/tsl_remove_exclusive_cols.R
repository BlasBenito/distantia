#' Remove Exclusive Columns from Time Series List
#'
#' @description
#' Removes columns that are not shared across all zoo objects within a time series list.
#'
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
tsl_remove_exclusive_cols <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  tsl.exclusive <- tsl_colnames(
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
