#' Handle NA data in Time Series
#'
#' @param x (required, list of zoo objects) List of time series. Default: NULL
#' @param na_action (required, character) Action to handle NA data in `x`. Current options are:
#' \itemize{
#'   \item "none" (default): No transformation is applied. If this option is selected and the data has NA cases, the function returns a warning.
#'   \item "impute" : NA cases are interpolated against time via splines with [zoo::na.spline()].
#'   \item "omit": rows with NA cases are removed.
#'   \item "fill": NA cases are replaced with the value in `na_fill`.
#' }
#' @param na_fill (optional, numeric) Only relevant when `na_action = "fill"`, defines the value used to replace NAs with. Ideally, a small number different from zero (pseudo-zero). Default: 0.0001
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#'
#' @return
#' @export
#'
#' @examples
ts_handle_NA <- function(
    x = NULL,
    na_action = "none",
    na_fill = 0.0001,
    verbose = TRUE
){

  x <- check_args_x(
    x = x,
    arg_name = "x"
  )

  na_count <- ts_count_NA(
    x = x,
    verbose = FALSE
  )

  if(na_count == 0){

    if(verbose == TRUE){
      message("There are no NA cases in 'x', returning it with no change.")
    }

    return(x)

  } else {

    if(na_action == "none"){

      #here again for the message alone
      na_count <- ts_count_NA(
        x = x,
        verbose = verbose
      )

      return(x)

    }

  }

  na_action <- match.arg(
    arg = na_action,
    choices = c(
      "omit",
      "fill",
      "impute"
    ),
    several.ok = FALSE
  )


  if(na_action == "omit"){

    if(verbose == TRUE){
      message("Rows with NA data removed.")
    }

    x <- lapply(
      X = x,
      FUN = na.omit
    )

  }

  if(na_action == "impute"){

    if(verbose == TRUE){
      message("NA cases imputed as a function of time via zoo::na.spline()")
    }

    x <- lapply(
      X = x,
      FUN = zoo::na.spline
    )

  }

  if(na_action == "zero"){

    if(verbose == TRUE){
      message("NA data was replaced with ", na_fill)
    }

    x <- lapply(
      X = x,
      FUN = zoo::na.fill,
      fill = na_fill
    )
  }

  x <- ts_set_names(
    x = x
  )

  x

}
