#' Resamples Zoo Time Series to a New Time
#'
#' @description
#'
#' Given a zoo object and a time vector, this function uses Generalized Additive Models (GAM) to resample a zoo object to a new time. This operation is useful to align time series with different frequencies, or to transform irregular time series into regular.
#'
#' The new time vector must be of the same class as the time of the zoo object (either  numeric, Date, or POSIXct). This new time vector can be either created from scratch, or can be extracted from another zoo object with [zoo::index()].
#'
#' Each time series within the zoo object is modelled as a function of the original time of the zoo object with [mgcv::gam()], and then predicted to te new time.
#'
#' Please use this operation with care, as there are limits to the amount of resampling that can be done without distorting the data. The safest option is to keep the distance between new time points within the same magnitude of the distance between the old time points.
#'
#'
#' @param x (required, zoo object) Time series to resample Default: NULL
#' @param new_time (required, zoo object, or vector of the classes numeric, Date, or POSIXct) New time of the resampled zoo object. Must be of the same class of the time in `x`. If one of them is "numeric" and the other is not, an error is returned. If a zoo object is provided, its time is used as a template to resample `x`. If NULL, irregular time series are predicted into a regular version of their own time, and regular time series are returned as is. Default: NULL
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
zoo_aggregate <- function(
    x = NULL,
    new_time = NULL
){

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo object.")
  }

  #extract time from x
  old_time <- zoo::index(x)

  #if no new_time
  if(is.null(new_time)){

    if(zoo::is.regular(
      x = x,
      strict = TRUE
    ) == TRUE
    ){
      message("Argument 'x' is a regular time series, and 'new_time' is NULL. Nothing to do.")
      return(x)
    }

    #create regular new_time from x
    new_time <- seq(
      from = min(old_time),
      to = max(old_time),
      length.out = length(old_time)
    )

  }

  #new_time is a zoo object
  if(zoo::is.zoo(new_time)){
    new_time <- zoo::index(new_time)
  }

  #compare old and new time classes
  new_time_class <- class(new_time)
  old_time_class <- class(old_time)

  if(
    "numeric" %in% new_time_class &&
    !("numeric" %in% new_time_class)
  ){
    stop("The time classes of arguments 'x' and 'new_time' do not match.")
  }


  #compare old and new time intervals
  new_time_interval <- as.numeric(mean(diff(new_time)))
  old_time_interval <- as.numeric(mean(diff(new_time)))

  if(
    new_time_interval < (old_time_interval/10) ||
     new_time_interval > (old_time_interval*10)
     ){
    warning("The intervals of 'new_time' and 'x' differ in one order of magnitude or more. The output time series might be highly distorted.")
  }

  #TODO: continue with resampling from here
  #check utils_optimize_gam()


  #reset name
  attr(
    x = y,
    which = "name"
  ) <- attributes(x)$name

  y

}
