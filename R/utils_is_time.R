#' Title
#'
#' @param x (required, vector) Vector to test. If the class of the vector elements is 'numeric', 'POSIXct', or 'Date', the function returns TRUE. Default: NULL.
#'
#' @return Logical
#' @export
#' @autoglobal
#' @examples
utils_is_time <- function(
    x = NULL
    ){

  #valid time class
  time_class <- sapply(
    X = x,
    FUN = class
  ) |>
    unique()

  #x is valid time class
  if(time_class %in% c(
    "numeric",
    "Date",
    "POSIXct"
  )){
    return(TRUE)
  }

  FALSE

}
