#' Count NA Cases in Time Series Lists
#'
#' @description
#' Converts Inf, -Inf, and NaN to NA (via [tsl_Inf_to_NA()] and [tsl_NaN_to_NA()]), and counts the total number of NA cases in each time series.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return list
#' @export
#' @autoglobal
#' @examples
#' #tsl with no NA cases
#' tsl <- tsl_simulate()
#'
#' tsl_count_NA(tsl = tsl)
#'
#' #tsl with NA cases
#' tsl <- tsl_simulate(
#'   na_fraction = 0.3
#' )
#'
#' tsl_count_NA(tsl = tsl)
#'
#' #tsl with variety of empty cases
#' tsl <- tsl_simulate()
#' tsl[[1]][1, 1] <- Inf
#' tsl[[1]][2, 1] <- -Inf
#' tsl[[1]][3, 1] <- NaN
#' tsl[[1]][4, 1] <- NaN
#'
#' tsl_count_NA(tsl = tsl)
#'
#' @family tsl_management
tsl_count_NA <- function(
    tsl = NULL
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #replaces Inf with Na
  tsl <- tsl_Inf_to_NA(
    tsl = tsl
  )

  #replaces NaN with NA
  tsl <- tsl_NaN_to_NA(
    tsl = tsl
  )

  na_count_list <- future.apply::future_lapply(
    X = tsl,
    FUN = function(x){
      sum(is.na(x))
    }
  )


  na_count_list

}
