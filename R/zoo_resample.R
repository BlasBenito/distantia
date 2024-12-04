#' Resample Zoo Objects to a New Time
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
#' \strong{Methods}
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
#'   \item `time vector`: a time vector of a class compatible with the time in `x`.
#'   \item `keyword`: character string defining a resampling keyword, obtained via `zoo_time(x, keywords = "resample")$keywords`..
#'   \item `numeric`: a single number representing the desired interval between consecutive samples in the units of `x` (relevant units can be obtained via `zoo_time(x)$units`).
#' }
#'
#' \strong{Step by Step}
#'
#' The steps to resample a time series list are:
#'
#' \enumerate{
#'   \item The time interpolation range taken from the index of the zoo object. This step ensures that no extrapolation occurs during resampling.
#'   \item If `new_time` is provided, any values of `new_time` outside of the minimum and maximum interpolation times are removed to avoid extrapolation. If `new_time` is not provided, a regular time within the interpolation time range of the zoo object is generated.
#'   \item For each univariate time time series, a model `y ~ x`, where `y` is the time series and `x` is its own time coerced to numeric is fitted.
#'   \itemize{
#'    \item If `max_complexity == FALSE` and `method = "spline"` or `method = "loess"`, the model with the complexity that minimizes the root mean squared error between the observed and predicted `y` is returned.
#'    \item If `max_complexity == TRUE` and `method = "spline"` or `method = "loess"`, the first valid model closest to a maximum complexity is returned.
#'   }
#'   \item The fitted model is predicted over `new_time` to generate the resampled time series.
#' }
#'
#' \strong{Other Details}
#'
#' Please use this operation with care, as there are limits to the amount of resampling that can be done without distorting the data. The safest option is to keep the distance between new time points within the same magnitude of the distance between the old time points.
#'
#' @param x (required, zoo object) Time series to resample. Default: NULL
#' @param new_time (optional, zoo object, keyword, or time vector) New time to resample `x` to. The available options are:
#' \itemize{
#'   \item NULL: a regular version of the time in `x` is generated and used for resampling.
#'   \item zoo object: the index of the given zoo object is used as template to resample `x`.
#'   \item time vector: a vector with new times to resample `x` to. If time in `x` is of class "numeric", this vector must be numeric as well. Otherwise, vectors of classes "Date" and "POSIXct" can be used indistinctly.
#'   \item keyword: a valid keyword returned by `zoo_time(x)$keywords`, used to generate a time vector with the relevant units.
#'   \item numeric of length 1: interpreted as new time interval, in the highest resolution units returned by `zoo_time(x)$units`.
#' }
#' @param method (optional, character string) Name of the method to resample the time series. One of "linear", "spline" or "loess". Default: "linear".
#' @param max_complexity (required, logical). Only relevant for methods "spline" and "loess". If TRUE, model optimization is ignored, and the a model of maximum complexity (an overfitted model) is used for resampling. Default: FALSE
#'
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' #simulate irregular time series
#' x <- zoo_simulate(
#'   cols = 2,
#'   rows = 50,
#'   time_range = c("2010-01-01", "2020-01-01"),
#'   irregular = TRUE
#'   )
#'
#' #plot time series
#' if(interactive()){
#'   zoo_plot(x)
#' }
#'
#' #intervals between samples
#' x_intervals <- diff(zoo::index(x))
#' x_intervals
#'
#' #create regular time from the minimum of the observed intervals
#' new_time <- seq.Date(
#'   from = min(zoo::index(x)),
#'   to = max(zoo::index(x)),
#'   by = floor(min(x_intervals))
#' )
#'
#' new_time
#' diff(new_time)
#'
#' #resample using piecewise linear regression
#' x_linear <- zoo_resample(
#'   x = x,
#'   new_time = new_time,
#'   method = "linear"
#' )
#'
#' #resample using max complexity splines
#' x_spline <- zoo_resample(
#'   x = x,
#'   new_time = new_time,
#'   method = "spline",
#'   max_complexity = TRUE
#' )
#'
#' #resample using max complexity loess
#' x_loess <- zoo_resample(
#'   x = x,
#'   new_time = new_time,
#'   method = "loess",
#'   max_complexity = TRUE
#' )
#'
#'
#' #intervals between new samples
#' diff(zoo::index(x_linear))
#' diff(zoo::index(x_spline))
#' diff(zoo::index(x_loess))
#'
#' #plotting results
#' if(interactive()){
#'
#'   par(mfrow = c(4, 1), mar = c(3,3,2,2))
#'
#'   zoo_plot(
#'     x,
#'     guide = FALSE,
#'     title = "Original"
#'     )
#'
#'   zoo_plot(
#'     x_linear,
#'     guide = FALSE,
#'     title = "Method: linear"
#'   )
#'
#'   zoo_plot(
#'     x_spline,
#'     guide = FALSE,
#'     title = "Method: spline"
#'     )
#'
#'   zoo_plot(
#'     x_loess,
#'     guide = FALSE,
#'     title = "Method: loess"
#'   )
#'
#' }
#' @family zoo_functions
zoo_resample <- function(
    x = NULL,
    new_time = NULL,
    method = "linear",
    max_complexity = FALSE
){


  if(zoo::is.zoo(x) == FALSE){
    stop("distantia::zoo_resample(): argument 'x' must be a zoo object.", call. = FALSE)
  }

  method <- match.arg(
    arg = method,
    choices = c(
      "linear",
      "spline",
      "loess"
    ),
    several.ok = FALSE
  )

  # handle new time ----
  old_time <- zoo_time(
    x = x,
    keywords = "resample"
    )

  #new_time is NULL
  if(is.null(new_time)){

    #create regular new_time from x
    new_time <- seq(
      from = old_time$begin,
      to = old_time$end,
      length.out = old_time$rows
    )

  }

  #process new_time
  new_time <- utils_new_time(
    tsl = zoo_to_tsl(x = x),
    new_time = new_time,
    keywords = "resample"
  )

  #subset to original range
  new_time <- new_time[
    new_time >= old_time$begin &
      new_time <= old_time$end
  ]

  #compare old and new new_time intervals
  time_interval <- as.numeric(mean(diff(new_time)))
  old_time_interval <- as.numeric(mean(diff(zoo::index(x))))

  if(
    time_interval <= (old_time_interval/10) ||
    time_interval >= (old_time_interval*10)
  ){
    warning("The time intervals of 'new_time' and 'x' differ in one order of magnitude or more. The output time series might be highly distorted.")
  }

  #default method
  if(method == "linear"){

    y <- zoo::na.approx(
      object = x,
      xout = new_time
    )

    y <- zoo_name_set(
      x = y,
      name = attributes(x)$name
    )

    return(y)

  }

  #convert times to numeric
  new_time_numeric <- utils_coerce_time_class(
    x = new_time,
    to = "numeric"
  )

  old_time <- zoo::index(x)

  old_time_numeric <- utils_coerce_time_class(
    x = old_time,
    to = "numeric"
  )

  #interpolate
  `%iterator%` <- foreach::`%do%`

  y <- foreach::foreach(
    i = seq_len(ncol(x)),
    .combine = "cbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    x.i <- as.numeric(x[, i])

    if(method == "spline"){
      f <- utils_optimize_spline
    }

    if(method == "loess"){
      f <- utils_optimize_loess
    }

    interpolation.model <- f(
      x = old_time_numeric,
      y = x.i,
      max_complexity = max_complexity
    )


    #if model fails, return NA
    if(
      inherits(
        x = interpolation.model,
        what = "loess"
      ) == FALSE &&
      inherits(
        x = interpolation.model,
        what = "smooth.spline"
      ) == FALSE
    ){

      return(rep(x = NA, times = length(new_time)))

    }

    #predict model
    if(method == "spline"){

      y.i <- stats::predict(
        object = interpolation.model,
        x = new_time_numeric
      )$y

    } else {

      y.i <- stats::predict(
        object = interpolation.model,
        newdata = data.frame(
          x = new_time_numeric
        )
      )

    }

    #set bounds
    y.i[y.i > max(x.i)] <- max(x.i)
    y.i[y.i < min(x.i)] <- min(x.i)

    return(y.i)

  }

  #rename columns
  colnames(y) <- colnames(x)

  #convert to zoo
  y <- zoo::zoo(
    x = y,
    order.by = new_time
  )

  #reset name
  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}
