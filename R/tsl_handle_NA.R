#' Handle NA data in Time Series
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param na_action (required, character) Action to handle NA data in `x`. Current options are:
#' \itemize{
#'   \item "none" (default): No transformation is applied. If this option is selected and the data has NA cases, the function returns a warning.
#'   \item "impute" : NA cases are interpolated against time via splines with [zoo::na.spline()].
#'   \item "omit": rows with NA cases are removed.
#'   \item "fill": NA cases are replaced with the value in `na_fill`.
#' }
#' @param na_fill (optional, numeric) Only relevant when `na_action = "fill"`, defines the value used to replace NAs with. Ideally, a small number different from zero (pseudo-zero). Default: 0.0001
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#'
#' @return time series list
#' @export
#'
#' @examples
tsl_handle_NA <- function(
    tsl = NULL,
    na_action = "none",
    na_fill = 0.0001,
    tsl_test = FALSE,
    verbose = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_tsl_test
  )

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

    tsl <- lapply(
      X = tsl,
      FUN = na.omit
    )

  }

  if(na_action == "impute"){

    if(verbose == TRUE){
      message("NA cases imputed as a function of time via zoo::na.spline()")
    }

    tsl <- lapply(
      X = tsl,
      FUN = function(x){

        x.integer <- is.integer(x)

        x <- zoo::na.spline(object = x)

        if(x.integer == TRUE){
          mode(x) <- "integer"
        }

        x

      }
    )

  }

  if(na_action == "fill"){

    if(verbose == TRUE){
      message("NA data was filled with ", na_fill)
    }

    tsl <- lapply(
      X = tsl,
      FUN = zoo::na.fill,
      fill = na_fill
    )

  }

  tsl <- tsl_names_set(
    tsl = tsl,
    tsl_test = FALSE
  )

  tsl

}
