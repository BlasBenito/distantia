#' Title
#'
#' @param x (required, vector) Vector to test. If the class of the vector elements is 'numeric', 'POSIXct', or 'Date', the function returns TRUE. Default: NULL.
#'
#' @return Logical
#' @export
#' @autoglobal
#' @examples
#'
#' utils_is_time(
#'   x = c("2024-01-01", "2024-02-01")
#' )
#'
#' utils_is_time(
#'   x = utils_as_time(
#'     x = c("2024-01-01", "2024-02-01")
#'     )
#' )
#' @keywords internal time_handling
utils_is_time <- function(
    x = NULL
    ){

  x_class <- class(x)
  if("POSIXct" %in% x_class){
    x_class <- "POSIXct"
  }

  #x is valid time class
  if(x_class %in% c(
    "integer",
    "numeric",
    "Date",
    "POSIXct"
  )){
    return(TRUE)
  }

  FALSE

}
