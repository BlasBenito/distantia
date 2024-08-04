#' Counts NA and Inf Cases in Time Series
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#'
#' @return Integer, sum of NA cases
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
tsl_count_NA <- function(
    tsl = NULL,
    verbose = TRUE
){

  #replaces Inf with Na
  tsl <- tsl_Inf_to_NA(
    tsl = tsl
    )

  #replaces NaN with NA
  tsl <- tsl_NaN_to_NA(
    tsl = tsl
  )

  na_per_ts <- lapply(
    X = tsl,
    FUN = function(tsl) sum(is.na(tsl))
  ) |>
    utils::stack()

  na_per_ts <- na_per_ts[, c("ind", "values")]
  names(na_per_ts) <- c("name", "NAs")

  na_sum <- sum(na_per_ts$NAs)

  if(na_sum > 0){

    if(verbose == TRUE){
      warning(
        "There are NA, NaN, or Inf cases in 'x': \n",
        paste(utils::capture.output(print(na_per_ts)), collapse = "\n"),
        "\nPlease impute, replace, or remove them with tsl_handle_NA().",
        call. = FALSE
      )
    }

  }

  na_sum

}
