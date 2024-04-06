#' Valid Aggregation Keywords
#'
#' @description
#' Internal function to obtain valid aggregation keywords
#'
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#'
#' @return Character string, aggregation keyword, or "none".
#' @export
#' @autoglobal
#' @examples
utils_time_valid_keywords <- function(
    tsl = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  time_df <- tsl_time(
    tsl = tsl,
    keywords = TRUE
  )

  keywords <- time_df$keywords |>
    unlist() |>
    unique()

  if(length(keywords) == 0){
    keywords <- "none"
  }

  keywords

}
