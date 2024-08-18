#' Valid Aggregation Keywords
#'
#' @description
#' Internal function to obtain valid aggregation keywords from a zoo object or a time series list.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return Character string, aggregation keyword, or "none".
#' @export
#' @autoglobal
#' @examples
#' #one minute time series
#' #-----------------------------------
#' tsl <- tsl_simulate(
#'   time_range = c(
#'     Sys.time() - 60,
#'     Sys.time()
#'   )
#' )
#'
#' #valid keywords for aggregation and/or resampling
#' utils_time_keywords(
#'   tsl = tsl
#' )
#'
#' #10 minutes time series
#' #-----------------------------------
#' tsl <- tsl_simulate(
#'   time_range = c(
#'     Sys.time() - 600,
#'     Sys.time()
#'   )
#' )
#'
#' utils_time_keywords(
#'   tsl = tsl
#' )
#'
#' #10 hours time series
#' #-----------------------------------
#' tsl <- tsl_simulate(
#'   time_range = c(
#'     Sys.time() - 6000,
#'     Sys.time()
#'   )
#' )
#'
#' utils_time_keywords(
#'   tsl = tsl
#' )
#'
#' #10 days time series
#' #-----------------------------------
#' tsl <- tsl_simulate(
#'   time_range = c(
#'     Sys.Date() - 10,
#'     Sys.Date()
#'   )
#' )
#'
#' utils_time_keywords(
#'   tsl = tsl
#' )
#'
#' #10 years time series
#' #-----------------------------------
#' tsl <- tsl_simulate(
#'   time_range = c(
#'     Sys.Date() - 3650,
#'     Sys.Date()
#'   )
#' )
#'
#' utils_time_keywords(
#'   tsl = tsl
#' )
utils_time_keywords <- function(
    tsl = NULL
){

  time_df <- tsl_time(
    tsl = tsl
  )

  keywords <- time_df$keywords |>
    unlist() |>
    unique()

  if(length(keywords) == 0){
    keywords <- NA
  }

  keywords

}
