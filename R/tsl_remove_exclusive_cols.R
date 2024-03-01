#' Remove Exclusive Columns from Time Series List
#'
#' @description
#' Removes columns that are not shared across all zoo objects within a time series list.
#'
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
tsl_remove_exclusive_cols <- function(
    tsl = NULL,
    tsl_test = FALSE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  tsl.exclusive <- tsl_colnames(
    tsl = tsl,
    names = "exclusive",
    tsl_test = FALSE
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
    tsl = tsl,
    tsl_test = FALSE
  )

  tsl

}
