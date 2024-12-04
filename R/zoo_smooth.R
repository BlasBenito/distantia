#' Rolling Window Smoothing of Zoo Time Series
#'
#' @description
#' Just a fancy wrapper of [zoo::rollapply()].
#'
#'
#' @param x (required, zoo object) Time series to smooth Default: NULL
#' @param window (optional, integer) Smoothing window width, in number of cases. Default: 3
#' @param f (optional, quoted or unquoted function name) Name of a standard or custom function to aggregate numeric vectors. Typical examples are `mean`, `max`,`min`, `median`, and `quantile`. Default: `mean`.
#' @param ... (optional, additional arguments) additional arguments to `f`.
#'
#' @return zoo object
#' @autoglobal
#' @export
#' @family zoo_functions
#' @examples
#' x <- zoo_simulate()
#'
#' x_smooth <- zoo_smooth(
#'   x = x,
#'   window = 5,
#'   f = mean
#' )
#'
#' if(interactive()){
#'   zoo_plot(x)
#'   zoo_plot(x_smooth)
#' }
zoo_smooth <- function(
    x = NULL,
    window = 3,
    f = mean,
    ...
){

  if(zoo::is.zoo(x) == FALSE){
    stop("distantia::zoo_aggregate(): argument 'x' must be a zoo object.", call. = FALSE)
  }


  if(is.character(f)){

    f <- tryCatch(
      match.fun(f),
      error = function(e) NULL
    )

  }

  if(is.function(f) == FALSE){
    stop("distantia::zoo_aggregate(): Argument 'f' must be a function name. Examples of valid options are: 'mean', 'median', 'max', 'min', and 'sd'.", call. = FALSE)
  }

  #set window to even
  window <- as.integer(window)
  if((window %% 2) == 0){
    window <- window + 1
  }

  y <- zoo::rollapply(
    data = x,
    width = window,
    fill = rep(x = "extend", times = window),
    FUN = f,
    ... = ...
  )

  zoo_name_set(
    x = y,
    name = attributes(x)$name
  )

}
