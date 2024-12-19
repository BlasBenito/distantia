#' Smoothing of Time Series Lists
#'
#' @description
#' Rolling-window and exponential smoothing of Time Series Lists.
#'
#' Rolling-window smoothing This computes a statistic over a fixed-width window of consecutive cases and replaces each central value with the computed statistic. It is commonly used to mitigate noise in high-frequency time series.
#'
#' Exponential smoothing computes each value as the weighted average of the current value and past smoothed values. This method is useful for reducing noise in time series data while preserving the overall trend.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @inheritParams zoo_smooth_window
#' @param alpha (required, numeric) Exponential smoothing factor in the range (0, 1]. Determines the weight of the current value relative to past values. If not NULL, the arguments `window` and `f` are ignored, and exponential smoothing is performed instead. Default: NULL
#'
#' @return time series list
#' @export
#' @autoglobal
#' @family tsl_processing
#' @examples
#'
#'
#' tsl <- tsl_simulate(n = 2)
#'
#' #rolling window smoothing
#' tsl_smooth <- tsl_smooth(
#'   tsl = tsl,
#'   window = 5,
#'   f = mean
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl)
#'   tsl_plot(tsl_smooth)
#' }
#'
#' #exponential smoothing
#' tsl_smooth <- tsl_smooth(
#'   tsl = tsl,
#'   alpha = 0.2
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl)
#'   tsl_plot(tsl_smooth)
#' }
#'
tsl_smooth <- function(
    tsl = NULL,
    window = 3,
    f = mean,
    alpha = NULL,
    ...
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  if(!is.null(alpha)){
    if (alpha <= 0 || alpha > 1) stop("distantia::tsl_smooth(): 'alpha' must be in the range (0, 1].")
  }

  #progress bar
  p <- progressr::progressor(along = tsl)

  #parallelized loop
  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x, ...){

      p()

      if(is.null(alpha)){

        x <- zoo_smooth_window(
          x = x,
          window = window,
          f = f,
          ... = ...
        )

      } else {

        x <- zoo_smooth_exponential(
          x = x,
          alpha = alpha
        )

      }

    },
    ... = ...
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
