#' Number of Rows in Time Series Lists
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return list
#' @export
#' @examples
#' TODO: complete example
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
