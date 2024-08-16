#' Number of Columns in a Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return list
#' @export
#' @examples
#' #initialize time series list
#' tsl <- tsl_simulate(
#'   n = 2,
#'   cols = 6
#' )
#'
#' #number of columns per zoo object
#' tsl_ncol(tsl = tsl)
#' @autoglobal
tsl_ncol <- function(
    tsl = NULL
){

  lapply(
    X = tsl,
    FUN = function(x){
      ncol(x)
    }
  )

}
