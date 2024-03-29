#' Time Summary of a Time Series List
#'
#' @param tsl (required, list of zoo objects) Time series list. Default: NULL
#' @param keywords (optional, logical) If TRUE, the output list contains the slot keywords with valid aggregation keywords. Default: FALSE
#'
#' @return List with class, range, units, and resolution of the time in `tsl`.
#' @export
#' @autoglobal
#' @examples
tsl_time_summary <- function(
    tsl = NULL,
    keywords = FALSE
){

  # EXAMPLES
  # #######################################

  #Date
  tsl <- tsl_simulate(
    time_range = c(
      "0100-02-08",
      "2024-12-31"
    )
  )

  #POSIXct
  tsl <- tsl_simulate(
    time_range = c(
      "0100-01-01 12:00:25",
      "2024-12-31 11:15:45"
    )
  )

  #numeric
  tsl <- tsl_simulate(
    time_range = c(-123120, 1200)
  )

  #decimal
  tsl <- tsl_simulate(
    time_range = c(0.01, 0.09)
  )

  ######################################

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  tsl_time_list <- lapply(
    X = tsl,
    FUN = zoo_time,
    keywords = keywords
  )

  #TODO: modify function to simplify time list
  utils_simplify_list(x = tsl_time_list)

}
