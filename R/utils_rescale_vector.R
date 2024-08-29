#' Rescale Numeric Vector to a New Data Range
#' @param x (required, numeric vector) Numeric vector. Default: `NULL`
#' @param new_min (optional, numeric) New minimum value. Default: `0`
#' @param new_max (optional_numeric) New maximum value. Default: `1`
#' @param old_min (optional, numeric) Old minimum value. Default: `NULL`
#' @param old_max (optional_numeric) Old maximum value. Default: `NULL`
#' @return numeric vector
#' @examples
#'
#'  out <- utils_rescale_vector(
#'    x = stats::rnorm(100),
#'    new_min = 0,
#'    new_max = 100,
#'    )
#'
#'  out
#'
#' @export
#' @autoglobal
#' @family internal_data_processing
utils_rescale_vector <- function(
    x = NULL,
    new_min = 0,
    new_max = 1,
    old_min = NULL,
    old_max = NULL
){

  if(!is.vector(x) || !is.numeric(x)){
    stop("x must be a numeric vector.")
  }

  if(is.null(old_min)){
    old_min <- min(x, na.rm = TRUE)
  }

  if(is.null(old_max)){
    old_max <- max(x, na.rm = TRUE)
  }

  ((x - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min


}
