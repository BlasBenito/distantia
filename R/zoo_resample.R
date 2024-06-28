#' Resamples Zoo Time Series to a New Time
#'
#' @description
#'
#' Given a zoo object and a time vector, this function uses Generalized Additive Models (GAM) to resample a zoo object to a new time. This operation is useful to align time series with different frequencies, or to transform irregular time series into regular.
#'
#' The new time vector must be of the same class as the time of the zoo object (either  numeric, Date, or POSIXct). This new time vector can be either created from scratch, or can be extracted from another zoo object with [zoo::index()].
#'
#' Each time series within the zoo object is modelled as a function of the original time with [mgcv::gam()], and then predicted to the new time.
#'
#' Please use this operation with care, as there are limits to the amount of resampling that can be done without distorting the data. The safest option is to keep the distance between new time points within the same order of magnitude of the distance between the old time points.
#'
#'
#' @param x (required, zoo object) Time series to resample. Default: NULL
#' @param time (required, zoo object, or vector of the classes numeric, Date, or POSIXct) New time of the resampled zoo object. Must be of the same class of the time in `x`. If one of them is "numeric" and the other is not, an error is returned. If a zoo object is provided, its time is used as a template to resample `x`. If NULL, irregular time series are predicted into a regular version of their own time, and regular time series are returned as is. Default: NULL
#' @param method (optional, string) Name of the method to resample the time series. One of "gam" or "loess". Default: "loess".
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#' #simulate irregular time series
#' x <- zoo_simulate(
#'   cols = 2,
#'   rows = 100,
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
#' diff(zoo::index(x))
#'
#' #create regular time for resampling
#' regular_time <- seq.Date(
#'   from = as.Date("2010-01-01"),
#'   to = as.Date("2020-01-01"),
#'   by = "1 month"
#' )
#'
#' #resample to regular time
#' x_resampled <- zoo_resample(
#'   x = x,
#'   time = regular_time
#' )
#'
#' #notice the loss of detail in the resampled data
#' if(interactive()){
#'   zoo_plot(x_resampled)
#' }
#'
#' #intervals between new samples
#' diff(zoo::index(x_resampled))
zoo_resample <- function(
    x = NULL,
    time = NULL,
    method = "loess"
){

  method <- match.arg(
    arg = method,
    choices = c(
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

  #if no time
  if(is.null(time)){

    #create regular time from x
    time <- seq(
      from = min(old_time),
      to = max(old_time),
      length.out = length(old_time)
    )

  } else {

    #time is a zoo object
    if(zoo::is.zoo(time)){
      time <- zoo::index(time)
    }

    if(utils_is_time(x = time) == FALSE){
      time <- utils_as_time(x = time)
    }

  }

  #stop if only one of the classes is numeric
  if(
    sum(
      is.numeric(
        c(
          class(time),
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
        class(time),
        class(old_time)
        )
      ) == 1
  ){

    zoo::index(x) <- utils_coerce_time_class(
      x =  zoo::index(x),
      to = ifelse(
        test = "POSIXct" %in% class(time),
        yes = "POSIXct",
        no = class(time)
      )
    )

  }

  #coerce time within the bounds of old_time
  time <- time[
    time >= min(old_time) &
      time <= max(old_time)
    ]

  #compare old and new time intervals
  time_interval <- as.numeric(mean(diff(time)))
  old_time_interval <- as.numeric(mean(diff(time)))

  if(
    time_interval < (old_time_interval/10) ||
     time_interval > (old_time_interval*10)
     ){
    warning("The time intervals of 'time' and 'x' differ in one order of magnitude or more. The output time series might be highly distorted.")
  }

  #convert times to numeric
  time_numeric <- utils_coerce_time_class(
    x = time,
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

    if(method == "loess"){
      f <- utils_optimize_loess
    }

    if(method == "gam"){
      f <- utils_optimize_gam
    }

    interpolation.model <- f(
      x = old_time_numeric,
      y = x_old
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
      ) == FALSE
      ){

      return(rep(x = NA, times = length(time)))

    }

    #predict model
    x_new <- stats::predict(
      object = interpolation.model,
      newdata = data.frame(
        x = time_numeric
      )
    )

    # plot(old_time_numeric, x_old, type = "l", col = "red")
    # lines(time_numeric, x_new, type = "l")

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
    order.by = time
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
