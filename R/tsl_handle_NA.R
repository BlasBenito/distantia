#' Handle NA and Inf data in Time Series
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param na_action (required, character) Action to handle NA data in `x`. Current options are:
#' \itemize{
#'   \item "none" (default): No transformation is applied. If this option is selected and the data has NA cases, the function returns a warning.
#'   \item "impute" : NA cases are interpolated against time using the function introduced in the argument `f`.
#'   \item "omit": rows with NA cases are removed.
#'   \item "fill": NA cases are replaced with the value in `na_fill`.
#' }
#' @param na_fill (optional, numeric) Only relevant when `na_action = "fill"`, defines the value used to replace NAs with. Ideally, a small number different from zero (pseudo-zero). Default: 0.0001
#' @param f (optional, function) Only relevant when `na_action = "impute"`. Function to impute missing cases. Recommended options are [zoo::na.approx()] (default), and [zoo::na.spline()], but any function able to fill NAs in a matrix or zoo object should work. Default: zoo::na.approx
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
    f = zoo::na.approx,
    verbose = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  #replaces Inf with Na
  tsl <- tsl_Inf_to_NA(
    tsl = tsl
  )

  #replaces NaN with NA
  tsl <- tsl_NaN_to_NA(
    tsl = tsl
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
      FUN = stats::na.omit
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

        x.index <- zoo::index(x)

        x.min <- lapply(
          X = x,
          FUN = min,
          na.rm = TRUE
        )

        x.max <- lapply(
          X = x,
          FUN = max,
          na.rm = TRUE
        )

        x.interpolated <- f(
          object = x,
          na.rm = FALSE
          )

        x.interpolated <- as.matrix(x.interpolated)

        for(i in seq_len(length(x.min))){
          x.interpolated[x.interpolated[, i] < x.min[[i]], i] <- x.min[[i]]
          x.interpolated[x.interpolated[, i] > x.max[[i]], i] <- x.max[[i]]
        }

        if(x.integer == TRUE){
          mode(x.interpolated) <- "integer"
        }

        x.interpolated <- zoo::zoo(
          x = x.interpolated,
          order.by = x.index
        )

        x.interpolated

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

  na.count <- tsl_count_NA(
    tsl = tsl,
    verbose = TRUE
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}


#' @rdname tsl_handle_NA
#' @export
#' @autoglobal
tsl_Inf_to_NA <- function(
    tsl = NULL
){

  tsl <- lapply(
    X = tsl,
    FUN = function(x){
      x.index <- zoo::index(x)
      x <- as.matrix(x)
      x[is.infinite(x)] <- NA
      x <- zoo::zoo(
        x = x,
        order.by = x.index
      )
      x
    }
  )

  tsl <- tsl_names_set(tsl = tsl)

  tsl

}

#' @rdname tsl_handle_NA
#' @export
#' @autoglobal
tsl_NaN_to_NA <- function(
    tsl = NULL
){

  tsl <- lapply(
    X = tsl,
    FUN = function(x){
      x[is.nan(x)] <- NA
      x
    }
  )

  tsl <- tsl_names_set(tsl = tsl)

  tsl

}
