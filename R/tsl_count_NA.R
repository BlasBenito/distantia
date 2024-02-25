#' Counts NA Cases in Time Series
#'
#' @param tsl (required, list of zoo objects) List of time series. Default: NULL
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#'
#' @return Integer, sum of NA cases
#' @export
#' @autoglobal
#' @examples
tsl_count_NA <- function(
    tsl = NULL,
    verbose = TRUE
    ){

  tsl <- check_args_x(
    x = tsl,
    arg_name = "TSL"
  )

  if(inherits(x = tsl, what = "list")){

    na_per_ts <- lapply(
      X = tsl,
      FUN = function(tsl) sum(is.na(tsl))
    ) |>
      utils::stack()

    na_per_ts <- na_per_ts[, c("ind", "values")]
    names(na_per_ts) <- c("name", "NAs")

    na_sum <- sum(na_per_ts$NAs)

  }

  if(inherits(x = tsl, what = "zoo")){

    na_sum <- na_per_ts <- sum(is.na(tsl))

  }

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
