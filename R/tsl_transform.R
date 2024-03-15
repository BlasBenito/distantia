#' Transform Values of a Time Series List
#'
#' @description
#' Transforms values of the zoo objects within a time series list. Generally, functions introduced via the argument `f` should not change the dimensions of the output time series list. However, there are glaring exceptions. For example, [f_center()] and [f_scale()] compute the overall mean and standard deviation across all zoo objects in the time series list to apply a common transformation. This requires removing exclusive columns from the zoo objects via [tsl_remove_exclusive_cols()].
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param f (required, transformation function) name of a function taking a matrix as input. Currently, the following options are implemented, but any other function taking a matrix as input (for example, [scale()]) should work as well:
#' \itemize{
#'   \item f_proportion: proportion computed by row.
#'   \item f_percentage: percentage computed by row.
#'   \item f_hellinger: Hellinger transformation computed by row
#'   \item f_center: Centering computed by column using the column mean across all zoo objects within `tsl`.
#'   \item f_scale: Centering and scaling using the column mean and standard deviation across all zoo objects within `tsl`.
#'   \item f_smooth: Time series smoothing with a user defined rolling window.
#'   \item f_detrend_difference: Differencing detrending of time series via [diff()].
#'   \item f_detrend_linear: Detrending of seasonal time series via linear modeling.
#'   \item f_detrend_gam: Detrending of seasonal time series via Generalized Additive Models.
#' }
#' @param ... (optional, additional arguments of `f`) Optional arguments for the transformation function.
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
tsl_transform <- function(
    tsl = NULL,
    f = NULL,
    ...
){

  if(is.function(f) == FALSE){

    stop(
      "Argument 'f' must be a function name with no quotes. Valid options are: ",
      paste(
        f_list(),
        collapse = ", "
      ),
      "."
    )

  }

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  na.count <- tsl_count_NA(
    tsl = tsl,
    verbose = FALSE
  ) |>
    suppressWarnings()

  if(na.count > 0){
    stop("There are ", na.count, " NA, NaN, or Inf cases in argument 'tsl', Please handle these cases with distantia::tsl_handle_NA() before applying a transformation.")
  }


  #handle scaling
  scaling_params <- scaling_parameters(
    tsl = tsl,
    f = f,
    ... = ...
  )

  #apply transformation
  if(!is.null(scaling_params)){

    tsl <- tsl_subset(
      tsl = tsl,
      colnames = lapply(
        X = scaling_params,
        FUN = names
      ) |>
        unlist() |>
        unique()
    )

    tsl <- lapply(
      X = tsl,
      FUN = f,
      center = scaling_params$center,
      scale = scaling_params$scale
    )

  } else{

    tsl <- lapply(
      X = tsl,
      FUN = f,
      ... = ...
    )

  }


  #reset names of zoo objects
  tsl <- tsl_names_set(
    tsl = tsl,
    tsl_test = FALSE
  )

  if(tsl_test == TRUE){
    na.count <- tsl_count_NA(
      tsl = tsl,
      verbose = TRUE
    )
  }


  tsl

}
