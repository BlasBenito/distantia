#' Valid Aggregation Keywords
#'
#' @description
#' Internal function to obtain valid aggregation keywords from a zoo object or a time series list.
#'
#'
#' @param tsl (required, time series list) Default: NULL
#'
#' @return Character string, aggregation keyword, or "none".
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
utils_time_keywords <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

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
