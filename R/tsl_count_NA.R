#' Counts NA Cases in Time Series
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param test_valid (optional, logical) If FALSE, the validity test performed by [tsl_is_valid()] is ignored. Useful to improve performance when the user knows that `tsl` is valid. Default: TRUE
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#'
#' @return Integer, sum of NA cases
#' @export
#' @autoglobal
#' @examples
tsl_count_NA <- function(
    tsl = NULL,
    test_valid = TRUE,
    verbose = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    test_valid = test_valid
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
        "There are NA cases in 'x': \n",
        paste(capture.output(print(na_per_ts)), collapse = "\n"),
        "\nPlease impute, replace, or remove them with tsl_handle_NA().",
        call. = FALSE
      )
    }

  }

  na_sum

}
