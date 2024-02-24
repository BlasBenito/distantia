#' Counts NA Cases in Time Series
#'
#' @param x (required, list of zoo objects) List of time series. Default: NULL
#' @param verbose (optional, logical) If FALSE, all messages are suppressed. Default: TRUE
#'
#' @return Integer, sum of NA cases
#' @export
#' @autoglobal
#' @examples
ts_count_NA <- function(
    x = NULL,
    verbose = TRUE
    ){

  x <- check_args_x(
    x = x,
    arg_name = "x"
  )

  if(inherits(x = x, what = "list")){

    na_per_ts <- lapply(
      X = x,
      FUN = function(x) sum(is.na(x))
    ) |>
      utils::stack()

    na_per_ts <- na_per_ts[, c("ind", "values")]
    names(na_per_ts) <- c("name", "NAs")

    na_sum <- sum(na_per_ts$NAs)

  }

  if(inherits(x = x, what = "zoo")){

    na_sum <- na_per_ts <- sum(is.na(x))

  }

  if(na_sum > 0){

    if(verbose == TRUE){
      warning(
        "There are NA cases in 'x': \n",
        paste(capture.output(print(na_per_ts)), collapse = "\n"),
        "\nPlease impute, replace, or remove them with ts_handle_NA().",
        call. = FALSE
        )
    }

  }

  na_sum

}
