#' Rolling Window Smoothing of Time Series Lists
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @inheritParams zoo_smooth
#'
#' @return time series list
#' @export
#' @autoglobal
#' @family tsl_processing
#' @examples
#'
#' future::plan(
#'   future::multisession,
#'   workers = 2 #set to parallelly::availableCores() - 1
#' )
#'
#' # progress bar (does not work in examples)
#' # progressr::handlers(global = TRUE)
#'
#' tsl <- tsl_simulate(n = 2)
#'
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
#' future::plan(
#'   future::sequential
#' )
tsl_smooth <- function(
    tsl = NULL,
    window = 3,
    f = NULL,
    ...
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #progress bar
  p <- progressr::progressor(along = tsl)

  #parallelized loop
  tsl <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x, ...){

      p()

      x <- zoo_smooth(
        x = x,
        window = window,
        f = f,
        ... = ...
      )

    },
    ... = ...
  )

  tsl <- tsl_names_set(
    tsl = tsl
  )

  tsl

}
