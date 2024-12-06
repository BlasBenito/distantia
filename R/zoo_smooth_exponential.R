#' Exponential Smoothing of Zoo Time Series
#'
#' @description
#' Applies exponential smoothing to a zoo time series object, where each value is a weighted average of the current value and past smoothed values. This method is useful for reducing noise in time series data while preserving the general trend.
#'
#' @param x (required, zoo object) time series to smooth Default: NULL
#' @param alpha (required, numeric) Smoothing factor in the range (0, 1]. Determines the weight of the current value relative to past values. A higher value gives more weight to recent observations, while a lower value gives more weight to past observations. Default: 0.2
#'
#' @return zoo object
#' @autoglobal
#' @export
#' @family zoo_functions
#' @examples
#' x <- zoo_simulate()
#'
#' x_smooth <- zoo_smooth_exp(
#'   x = x,
#'   alpha = 0.2
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(x_smooth)
#' }
zoo_smooth_exponential <- function(
    x = NULL,
    alpha = 0.2
){

  if(zoo::is.zoo(x) == FALSE){
    stop("distantia::zoo_smooth_exponential(): argument 'x' must be a zoo object.", call. = FALSE)
  }

  if (alpha <= 0 || alpha > 1) stop("distantia::zoo_smooth_exponential(): 'alpha' must be in the range (0, 1].")

  # recursive exponential smoothing
  y <- apply(
    X = zoo::coredata(x),
    MARGIN = 2,
    FUN = function(col) {
      Reduce(
        f = function(prev, curr) alpha * curr + (1 - alpha) * prev,
        x = col,
        accumulate = TRUE
      )
    }
  )

  y <- zoo::zoo(
    x = y,
    order.by = zoo::index(x)
    )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}
