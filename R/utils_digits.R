#' Number of Decimal Places
#'
#' @param x (required, numeric) Default: NULL
#'
#' @return Integer, number of decimal places
#' @export
#' @autoglobal
#' @examples
#' utils_digits(x = 0.234)
utils_digits <- function(
    x = NULL
    ){

  out <- 0

  if(abs(x - round(x)) > .Machine$double.eps^0.5){

    #remove terminal zeros
    x <- sub(
      pattern = '0+$',
      replacement = '',
      x = as.character(x)
    )

    #number of decimals
    out <- nchar(
      x = strsplit(
        x = x,
        split = ".",
        fixed = TRUE
      )[[1]][[2]]
    )

  }

  out

}
