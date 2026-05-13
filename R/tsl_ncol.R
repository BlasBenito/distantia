#' Get Number of Columns in Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return list
#' @export
#' @examples
#' #Initialize time series list
#' tsl <- tsl_simulate(
#'   n = 2,
#'   cols = 6
#' )
#'
#' #Number of columns per zoo object
#' tsl_ncol(tsl = tsl)
#' @autoglobal
#' @family tsl_management
tsl_ncol <- function(
    tsl = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  lapply(
    X = tsl,
    FUN = function(x){
      ncol(x)
    }
  )

}
