#' Transform Values of a Time Series List
#'
#' @description
#' Transform values of the zoo objects within a time series list using transformation functions.
#'
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param tsl_test (optional, logical) If TRUE, a validity test on the argument `tsl` is performed by [tsl_is_valid()]. It might be useful to set it to TRUE if something goes wrong while executing this function. Default: FALSE
#' @param f (required, transformation function) name of a function taking a matrix as input. Currently, the following options are implemented:
#' \itemize{
#'   \item f_proportion: proportion computed by row.
#'   \item f_percentage: percentage computed by row.
#'   \item f_hellinger: Hellinger transformation computed by row
#'   \item f_scale: Centering and scaling computed by column using the overall mean and standard deviation across all zoo objects within `tsl`.
#' }
#' @param ... (optional, additional arguments of `f`) Optional arguments for the transformation function.
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
tsl_transform <- function(
    tsl = NULL,
    tsl_test = FALSE,
    f = NULL,
    ...
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    tsl_test = tsl_test
  )

  na.count <- tsl_count_NA(
    tsl = tsl,
    tsl_test = tsl_test,
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

  na.count <- tsl_count_NA(
    tsl = tsl,
    tsl_test = FALSE,
    verbose = TRUE
  )

  tsl

}
