#' Get Number of Rows in Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return list
#' @export
#' @examples
#' #simulate zoo time series
#' tsl <- tsl_simulate(
#'   rows = 150
#'   )
#'
#' #count rows
#' tsl_nrow(
#'   tsl = tsl
#' )
#' @autoglobal
#' @family data_exploration
tsl_nrow <- function(
    tsl = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  lapply(
    X = tsl,
    FUN = function(x){
      nrow(x)
    }
  )

}
