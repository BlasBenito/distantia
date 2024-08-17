#' Number of Rows in a Time Series Lists
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
