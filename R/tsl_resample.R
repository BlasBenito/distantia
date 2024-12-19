#' Resample Time Series Lists to a New Time
#'
#' @description
#'
#'
#' \strong{Objective}
#'
#' Time series resampling interpolates new values for time steps not available in the original time series. This operation is useful to:
#' \itemize{
#'   \item Transform irregular time series into regular.
#'   \item Align time series with different temporal resolutions.
#'   \item Increase (upsampling) or decrease (downsampling) the temporal resolution of a time series.
#' }
#'
#' Time series resampling \strong{should not be used} to extrapolate new values outside of the original time range of the time series, or to increase the resolution of a time series by a factor of two or more. These operations are known to produce non-sensical results.
#'
#' \strong{Warning}: This function resamples time series lists \strong{with overlapping times}. Please check such overlap by assessing the columns "begin" and "end " of the data frame resulting from `df <- tsl_time(tsl = tsl)`. Resampling will be limited by the shortest time series in your time series list. To resample non-overlapping time series, please subset the individual components of `tsl` one by one either using [tsl_subset()] or the syntax `tsl = my_tsl[[i]]`.
#'
#' \strong{Methods}
#'
#' This function offers three methods for time series interpolation:
#'
#' \itemize{
#'   \item "linear" (default): interpolation via piecewise linear regression as implemented in [zoo::na.approx()].
#'   \item "spline": cubic smoothing spline regression as implemented in [stats::smooth.spline()].
#'   \item "loess": local polynomial regression fitting as implemented in [stats::loess()].
#' }
#'
#' These methods are used to fit models `y ~ x` where `y` represents the values of a univariate time series and `x` represents a numeric version of its time.
#'
#' The functions [utils_optimize_spline()] and [utils_optimize_loess()] are used under the hood to optimize the complexity of the methods "spline" and "loess" by finding the configuration that minimizes the root mean squared error (RMSE) between  observed and predicted `y`. However, when the argument `max_complexity = TRUE`, the complexity optimization is ignored, and a maximum complexity model is used instead.
#'
#' \strong{New time}
#'
#' The argument `new_time` offers several alternatives to help define the new time of the resulting time series:
#'
#' \itemize{
#'   \item `NULL`: the target time series (`x`) is resampled to a regular time within its original time range and number of observations.
#'   \item `zoo object`: a zoo object to be used as template for resampling. Useful when the objective is equalizing the frequency of two separate zoo objects.
#'   \item `time series list`: a time series list to be used as template. The range of overlapping dates and the average resolution are used to generate the new resampling time. This method cannot be used to align two time series lists, unless the template is resampled beforehand.
#'   \item `time vector`: a time vector of a class compatible with the time in `x`.
#'   \item `keyword`: character string defining a resampling keyword, obtained via `zoo_time(x, keywords = "resample")$keywords`..
#'   \item `numeric`: a single number representing the desired interval between consecutive samples in the units of `x` (relevant units can be obtained via `zoo_time(x)$units`).
#' }
#'
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
#'    \item If `max_complexity == TRUE` and `method = "spline"` or `method = "loess"`, the first valid model closest to a maximum complexity is returned.
#'
#'   }
#'   \item The fitted model is predicted over `new_time` to generate the resampled time series.
#' }
#'
#'
#' \strong{Other Details}
#'
#' Please use this operation with care, as there are limits to the amount of resampling that can be done without distorting the data. The safest option is to keep the distance between new time points within the same magnitude of the distance between the old time points.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param new_time (required, zoo object, time series list, character string, time vector, numeric) New time to resample to. If a time vector is provided, it must be of a class compatible with the time of `tsl`.  If a zoo object or time series list is provided, its time is used as a template to resample `tsl`. Valid resampling keywords (see [tsl_time()]) are allowed. Numeric values are interpreted as interval widths in the time units of the time series. If NULL, irregular time series are predicted into a regular version of their own time. Default: NULL
#' @param method (optional, character string) Name of the method to resample the time series. One of "linear", "spline" or "loess". Default: "linear".
#' @param max_complexity (required, logical). Only relevant for methods "spline" and "loess". If TRUE, model optimization is ignored, and the a model of maximum complexity (an overfitted model) is used for resampling. Default: FALSE
#'
#' @return time series list
#' @export
#' @autoglobal
#' @seealso [zoo_resample()]
#' @examples
#'
#' #generate irregular time series
#' tsl <- tsl_simulate(
#'   n = 2,
#'   rows = 100,
#'   irregular = TRUE
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl)
#' }
#'
#'
#' #range of times between samples
#' tsl_time_summary(tsl)[
#'   c(
#'     "units",
#'     "resolution_min",
#'     "resolution_max"
#'     )
#'   ]
#'
#' #resample to regular using linear interpolation
#' tsl_regular <- tsl_resample(
#'   tsl = tsl
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl_regular)
#' }
#'
#' #check new resolution
#' tsl_time_summary(tsl_regular)[
#'   c(
#'     "units",
#'     "resolution_min",
#'     "resolution_max"
#'   )
#' ]
#'
#' #resample using keywords
#'
#' #valid resampling keywords
#' tsl_time_summary(
#'   tsl = tsl,
#'   keywords = "resample"
#' )$keywords
#'
#' #by month
#' tsl_months <- tsl_resample(
#'   tsl = tsl,
#'   new_time = "months"
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl_months)
#' }
#'
#' #by week
#' tsl_weeks <- tsl_resample(
#'   tsl = tsl,
#'   new_time = "weeks"
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl_weeks)
#' }
#'
#' #resample using time interval
#'
#' #get relevant units
#' tsl_time(tsl)$units
#'
#' #resampling to 15 days intervals
#' tsl_15_days <- tsl_resample(
#'   tsl = tsl,
#'   new_time = 15 #days
#' )
#'
#' tsl_time_summary(tsl_15_days)[
#'   c(
#'     "units",
#'     "resolution_min",
#'     "resolution_max"
#'   )
#' ]
#'
#' if(interactive()){
#'   tsl_plot(tsl_15_days)
#' }
#'
#' #aligning two time series listsç
#'
#' #two time series lists with different time ranges
#' tsl1 <- tsl_simulate(
#'   n = 2,
#'   rows = 80,
#'   time_range = c("2010-01-01", "2020-01-01"),
#'   irregular = TRUE
#' )
#'
#' tsl2 <- tsl_simulate(
#'   n = 2,
#'   rows = 120,
#'   time_range = c("2005-01-01", "2024-01-01"),
#'   irregular = TRUE
#' )
#'
#' #check time features
#' tsl_time_summary(tsl1)[
#'   c(
#'     "begin",
#'     "end",
#'     "resolution_min",
#'     "resolution_max"
#'   )
#' ]
#'
#' tsl_time_summary(tsl2)[
#'   c(
#'     "begin",
#'     "end",
#'     "resolution_min",
#'     "resolution_max"
#'   )
#' ]
#'
#' #tsl1 to regular
#' tsl1_regular <- tsl_resample(
#'   tsl = tsl1
#' )
#'
#' #tsl2 resampled to time of tsl1_regular
#' tsl2_regular <- tsl_resample(
#'   tsl = tsl2,
#'   new_time = tsl1_regular
#' )
#'
#' #check alignment
#' tsl_time_summary(tsl1_regular)[
#'   c(
#'     "begin",
#'     "end",
#'     "resolution_min",
#'     "resolution_max"
#'   )
#' ]
#'
#' tsl_time_summary(tsl2_regular)[
#'   c(
#'     "begin",
#'     "end",
#'     "resolution_min",
#'     "resolution_max"
#'   )
#' ]
#'
#' @family tsl_processing
tsl_resample <- function(
    tsl = NULL,
    new_time = NULL,
    method = "linear",
    max_complexity = FALSE
){

  old_time <- tsl_time(
    tsl = tsl,
    keywords = "resample"
  )

  #process new_time
  new_time <- utils_new_time(
    tsl = tsl,
    new_time = new_time,
    keywords = "resample"
  )

  #subset to original range
  new_time <- new_time[
    new_time >= min(old_time$begin) &
      new_time <= max(old_time$end)
  ]

  #compare old and new new_time intervals
  time_interval <- as.numeric(mean(diff(new_time)))
  old_time_interval <- as.numeric(mean(old_time$resolution))

  if(
    time_interval < (old_time_interval/10) ||
    time_interval > (old_time_interval*10)
  ){
    warning("The time intervals of 'new_time' and 'x' differ in one order of magnitude or more. The output time series might be highly distorted.")
  }

  #progress bar
  p <- progressr::progressor(along = tsl)

  #resample
  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x){

      p()

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
