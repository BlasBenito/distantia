#' Handle NA data in Time Series
#'
#' @param x (required, list of zoo objects) List of time series. Default: NULL
#' @param na_action (required, character) Action to handle NA data in `x`. Current options are:
#' \itemize{
#'   \item "impute" (default): NA cases are interpolated against time via splines with [zoo::na.spline()].
#'   \item "omit": rows with NA cases are removed.
#'   \item "fill": NA cases are replaced with the value in `na_fill`.
#' }
#' @param na_fill (optional, numeric) Only relevant when `na_action = "fill"`, defines the value used to replace NAs with. Ideally, a small number different from zero (pseudo-zero). Default: 0.0001
#'
#' @return
#' @export
#'
#' @examples
ts_handle_NA <- function(
    x = NULL,
    na_action = "impute",
    na_fill = 0.0001
){

  x <- check_args_x(
    x = x,
    arg_name = "x"
    )

  x.class <- class(x)

  #check NA action argument
  na_action <- match.arg(
    arg = na_action,
    choices = c(
      "omit",
      "fill",
      "impute"
    )
  )

  if(na_action == "omit"){
    message("NA data is being omitted.")
    x <- lapply(
      X = x,
      FUN = na.omit
    )
  }

  if(na_action == "impute"){
    message("NA data is being imputed via zoo::na.spline()")
    x <- lapply(
      X = x,
      FUN = zoo::na.spline
    )
  }

  if(na_action == "zero"){
    message("NA data is being replaced with ", na_fill)
    x <- lapply(
      X = x,
      FUN = zoo::na.fill,
      fill = na_fill
    )
  }

  class(x) <- x.class

  x

}
