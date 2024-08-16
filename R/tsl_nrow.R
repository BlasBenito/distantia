#' Number of Rows in Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return list
#' @export
#' @examples
#' #initialize time series list
#'  <- tsl_simulate(
#'  = 2,
#' ows = 175
#'
#'
#' mber of columns per zoo object
#' _nrow(tsl = tsl)
#' @autoglobal
tsl_nrow <- function(
    tsl = NULL
){

  lapply(
    X = tsl,
    FUN = function(x){
      nrow(x)
    }
  )

}
