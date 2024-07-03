#' Resampling of Time Series Lists
#'
#' @description
#'
#' \strong{Objective}
#'
#' Time series resampling involves interpolating new values for time steps not available in the original time series. This operation is useful to:
#' \itemize{
#'   \item Transform irregular time series into regular.
#'   \item Align time series with different temporal resolutions.
#'   \item Increase (upsampling) or decrease (downsampling) the temporal resolution of a time series.
#' }
#'
#' On the other hand, time series resampling \strong{should not be used} to extrapolate new values outside of the original time range of the time series, or to increase the resolution of a time series by a factor of two or more. These operations are known to produce non-sensical results.
#'
#' \strong{Warning}: This function resamples time series lists \strong{with overlapping times}. Please check such overlap by assessing the columns "begin" and "end " of the data frame resulting from `df <- tsl_time(tsl = tsl)`. Resampling will be limited by the shortest time series in your time series list. To resample non-overlapping time series, please subset the individual components of `tsl` one by one.
#'
#' \strong{Inputs and Methods}
#'
#' This function requires three inputs: a time series list (argument `tsl`), a new time (argument `new_time`), and a method (argument `method`). In brief, the function uses `method` to model each univariate time series in `tsl` as a function of its own time, to then predict the model over `new_time`. This function offers three methods for time series interpolation:
#'
#' \itemize{
#'   \item "spline": cubic smoothing spline regression as implemented in [stats::smooth.spline()].
#'   \item "loess": local polynomial regression fitting as implemented in [stats::loess()].
#'   \item "gam": generalized additive modelling as implemented in [mgcv::gam()].
#' }
#'
#' These methods are used to fit models `y ~ x` (`y ~ s(x, k = ?)` for "gam") where `y` represents the values of a univariate time series and `x` represents a numeric version of its time.
#'
#' The functions [utils_optimize_spline()], [utils_optimize_loess()], and [utils_optimize_gam()] are used under the hood to optimize the complexity of each modelling method by finding the configuration that minimizes the root mean squared error (RMSE) between  observed and predicted `y`. However, when the argument `max_complexity = TRUE`, the complexity optimization is ignored, and a maximum complexity model is used instead.
#'
#' \strong{Step by Step}
#'
#' The steps to resample a time series list are:
#'
#' \enumerate{
#'   \item The time interpolation range is computed from the intersection of all times in `tsl`. This step ensures that no extrapolation occurs during resampling, but it also makes resampling of non-overlapping time series impossible.
#'   \item If `new_time` is provided, any values of `new_time` outside of the minimum and maximum interpolation times are removed to avoid extrapolation. If `new_time` is not provided, a regular time within the interpolation time range with the length of the shortest time series in `tsl` is generated.
#'   \item For each univariate time time series, a model `y ~ x`, where `y` is the time series and `x` is its own time coerced to numeric is fitted.
#'   \itemize{
#'    \item If `max_complexity == FALSE`, the model with the complexity that minimizes the root mean squared error between the observed and predicted `y` is returned.
#'    \item If `max_complexity == TRUE`, the first valid model closest to a maximum complexity is returned. The definitions of the maximum complexity model for each method is shown below:
#'    \itemize{
#'      \item "spline": `df = length(y) - 1, all.knots = TRUE`.
#'      \item "loess": `span = 1/length(x)`.
#'      \item "gam": `y ~ s(x, k = length(y) - 1)`.
#'    }
#'   }
#'   \item The fitted model is predicted over `new_time` to generate the resampled time series.
#' }
#'
#' In general, a maximum complexity splines model should be able to provide optimal results, but may cause artifacts in regions with large intervals between consecutive samples.
#'
#' \strong{Other Details}
#'
#' Please use this operation with care, as there are limits to the amount of resampling that can be done without distorting the data. The safest option is to keep the distance between new time points within the same magnitude of the distance between the old time points.
#'
#' This function accepts a parallelization setup via [future::plan()], but it might only be worth it for very long time series.
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param new_time (required, zoo object or time vector) New time to resample to. If a vector is provided, it must be of a class compatible with the time of `tsl`.  If a zoo object is provided, its time is used as a template to resample `tsl`. If NULL, irregular time series are predicted into a regular version of their own time. Default: NULL
#' @param method (optional, string) Name of the method to resample the time series. One of "spline", "gam", or "loess". Default: "spline".
#' @param max_complexity (required, logical). If TRUE, model optimization is ignored, and the a model of maximum complexity is used for resampling. Default: FALSE
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#'
tsl_resample <- function(
    tsl = NULL,
    new_time = NULL,
    method = "spline",
    max_complexity = FALSE
    ){

  tsl <- tsl_is_valid(tsl = tsl)

  #subset new_time
  old_time <- tsl_time(tsl = tsl)
  old_time_begin <- max(old_time$begin)
  old_time_end <- min(old_time$end)
  old_time_length <- min(old_time$length)

  #if new_time is null, create a regular one
  if(is.null(new_time)){

    new_time <- seq(
      from = old_time_begin,
      to = old_time_end,
      length.out = old_time_length
    )

  } else {

    #new_time is a zoo object
    if(zoo::is.zoo(new_time)){
      new_time <- zoo::index(new_time)
    }

    if(utils_is_time(x = new_time) == FALSE){
      new_time <- utils_as_time(x = new_time)
    }

    new_time <- new_time[new_time >= old_time_begin & new_time <= old_time_end]

  }

  #resample
  tsl <- lapply(
    X = tsl,
    FUN = function(x){

      x <- zoo_resample(
        x = x,
        new_time = new_time,
        method = method,
        max_complexity = max_complexity
      )

    }
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl


}
