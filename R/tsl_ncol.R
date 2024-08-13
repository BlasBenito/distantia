#' Number of Columns in Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return list
#' @export
#' @examples
#' TODO: complete example
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
