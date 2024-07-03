#' Resampling of Zoo Objects
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
#' \strong{Inputs and Methods}
#'
#' This function requires three inputs: a zoo object (argument `x`), a new time (argument `new_time`), and a method (argument `method`). In brief, the function uses `method` to model each univariate time series in `x` as a function of its own time, to then predict the model over `new_time`. This function offers three methods for time series interpolation:
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
#'   \item The time interpolation range taken from the index of the zoo object. This step ensures that no extrapolation occurs during resampling.
#'   \item If `new_time` is provided, any values of `new_time` outside of the minimum and maximum interpolation times are removed to avoid extrapolation. If `new_time` is not provided, a regular time within the interpolation time range of the zoo object is generated.
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
#' @param x (required, zoo object) Time series to resample. Default: NULL
#' @param new_time (required, zoo object or time vector) New time to resample to. If a vector is provided, it must be of a class compatible with the index of `x`.  If a zoo object is provided, its time is used as a template to resample `x`. If NULL, irregular time series are predicted into a regular version of their own time. Default: NULL
#' @param method (optional, string) Name of the method to resample the time series. One of "spline", "gam", or "loess". Default: "spline".
#' @param max_complexity (required, logical). If TRUE, model optimization is ignored, and the a model of maximum complexity (an overfitted model) is used for resampling. Default: FALSE
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
#' #parallelization setup
#' #only worth it for zoo objects with many variables and large number of samples when max_complexity = FALSE
#' # future::plan(
#' #   strategy = future::multisession,
#' #   workers = 2
#' # )
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
#' #resample using max complexity gam
#' x_gam <- zoo_resample(
#'   x = x,
#'   new_time = new_time,
#'   method = "gam",
#'   max_complexity = TRUE
#' )
#'
#' #intervals between new samples
#' diff(zoo::index(x_spline))
#' diff(zoo::index(x_loess))
#' diff(zoo::index(x_gam))
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
#'   zoo_plot(
#'     x_gam,
#'     guide = FALSE,
#'     title = "Method: gam"
#'   )
#'
#' }
#'
zoo_resample <- function(
    x = NULL,
    new_time = NULL,
    method = "spline",
    max_complexity = FALSE
){

  method <- match.arg(
    arg = method,
    choices = c(
      "spline",
      "loess",
      "gam"
    ),
    several.ok = FALSE
  )

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo object.")
  }

  #extract time from x
  old_time <- zoo::index(x)

  #if no new_time
  if(is.null(new_time)){

    #create regular new_time from x
    new_time <- seq(
      from = min(old_time),
      to = max(old_time),
      length.out = length(old_time)
    )

  } else {

    #time is a zoo object
    if(zoo::is.zoo(new_time)){
      new_time <- zoo::index(new_time)
    }

    if(utils_is_time(x = new_time) == FALSE){
      new_time <- utils_as_time(x = new_time)
    }

  }

  #stop if only one of the classes is numeric
  if(
    sum(
      is.numeric(
        c(
          class(new_time),
          class(old_time)
          )
        )
      ) == 1
  ){
    stop("The time classes of 'x' and 'time' must either be 'numeric', or any of 'Date' and 'POSIXct'.")
  }

  #coerce class of x to time
  if(
    sum(
      "POSIXct" %in%  c(
        class(new_time),
        class(old_time)
        )
      ) == 1
  ){

    zoo::index(x) <- utils_coerce_time_class(
      x =  zoo::index(x),
      to = ifelse(
        test = "POSIXct" %in% class(new_time),
        yes = "POSIXct",
        no = class(new_time)
      )
    )

  }

  #coerce new_time within the bounds of old_time
  new_time <- new_time[
    new_time >= min(old_time) &
      new_time <= max(old_time)
    ]

  #compare old and new new_time intervals
  time_interval <- as.numeric(mean(diff(new_time)))
  old_time_interval <- as.numeric(mean(diff(new_time)))

  if(
    time_interval < (old_time_interval/10) ||
     time_interval > (old_time_interval*10)
     ){
    warning("The time intervals of 'new_time' and 'x' differ in one order of magnitude or more. The output time series might be highly distorted.")
  }

  #convert times to numeric
  time_numeric <- utils_coerce_time_class(
    x = new_time,
    to = "numeric"
  )

  old_time_numeric <- utils_coerce_time_class(
    x = old_time,
    to = "numeric"
  )

  iterations <- seq_len(ncol(x))

  `%iterator%` <- doFuture::`%dofuture%`

  x_time <- foreach::foreach(
    i = iterations,
    .combine = "cbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    x_old <- as.numeric(x[, i])

    if(method == "spline"){
      f <- utils_optimize_spline
    }

    if(method == "loess"){
      f <- utils_optimize_loess
    }

    if(method == "gam"){
      f <- utils_optimize_gam
    }

    interpolation.model <- f(
      x = old_time_numeric,
      y = x_old,
      max_complexity = max_complexity
    )


    #if model fails, return NA
    if(
      inherits(
        x = interpolation.model,
        what = "gam"
      ) == FALSE &&
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

      x_new <- stats::predict(
        object = interpolation.model,
        x = time_numeric
        )$y

    } else {

      x_new <- stats::predict(
        object = interpolation.model,
        newdata = data.frame(
          x = time_numeric
        )
      )

    }

    #set bounds
    x_new[x_new > max(x_old)] <- max(x_old)
    x_new[x_new < min(x_old)] <- min(x_old)

    return(x_new)

  }

  #rename columns
  colnames(x_time) <- colnames(x)

  #convert to zoo
  x_time <- zoo::zoo(
    x = x_time,
    order.by = new_time
  )

  #reset name
  if(!is.null(attributes(x)$name)){
    attr(
      x = x_time,
      which = "name"
    ) <- attributes(x)$name
  }

  x_time

}
