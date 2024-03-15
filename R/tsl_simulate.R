#' Simulated Time Series List
#'
#' @description
#' Generates a simulated time series list
#'
#' @param n (optional, integer) Number of time series to simulate.
#' @param cols (optional, integer) Number of columns of each time series. Default: 5
#' @param rows (optional, integer) Length of each time series. Minimum is 10, but maximum is not limited. Very large numbers might crash the R session. Default: 100
#' @param time_range (optional character or numeric vector) Time interval of the time series. Either a character vector with dates in format YYYY-MM-DD or or a numeric vector. If there is a mismatch between `time_range` and `rows` (for example, the number of days in `time_range` is smaller than `rows`), the upper value in `time_range` is adapted to `rows`. Default: c("2010-01-01", "2020-01-01")
#' @param data_range (optional, numeric vector of length 2) Extremes of the time series values. Default: c(0, 1)
#' @param na_fraction (optional, numeric between 0 and 0.5) Fraction of NA data in the simulated time series. Default: 0.
#' @param independent (optional, logical) If TRUE, the zoo object is made of independent time series. Otherwise, each new time-series in the zoo object results from the addition of the previous ones. Irrelevant when `cols <= 2`. Default: TRUE
#' @param irregular (optional, logical) If TRUE, the time series is created with an additional 20% rows, and a random 20% of rows is removed. Default: TRUE
#' @param seed (optional, integer) Random seed used to simulate the zoo object. Default: NULL
#'
#' @return Simulated time series list.
#' @export
#' @autoglobal
#' @examples
#'
#' tsl_plot(tsl_simulate())
#'
tsl_simulate <- function(
    n = 2,
    cols = 5,
    rows = 100,
    time_range = c("2010-01-01", "2020-01-01"),
    data_range = c(0, 1),
    na_fraction = 0,
    independent = TRUE,
    irregular = TRUE,
    seed = NULL
){

  # n ----
  n <- as.integer(n)[1]
  if(n < 2){
    n <- 2
  }

  # seed ----
  if(is.null(seed)){
    seed <- sample.int(2^31 - 1, 1) - 2^30
  }

  # generate tsl ----
  tsl <- list()
  for(i in seq_len(n)){

    simulated.i <- zoo_simulated(
      cols = cols,
      rows = rows,
      time_range = time_range,
      data_range = data_range,
      na_fraction = na_fraction/n,
      independent = independent,
      irregular = FALSE,
      seed = seed + i
    )

    if(i == 1){
      tsl[[i]] <- simulated.i
    } else {
      tsl[[i]] <- simulated.i + tsl[[i - 1]]
    }

  }

  #irregular ----
  if(irregular == TRUE){

    time_range <- sort(time_range[c(1, 2)])

    if(is.character(time_range)){
      time_range <- as.Date(time_range)
      time_range_days <- as.numeric(diff(time_range))
      if(time_range_days < rows){
        time_range[which.max(time_range)] <- max(time_range) + (rows - time_range_days)
      }
    }

    time_names <- seq(
      from = min(time_range),
      to = max(time_range),
      length.out = rows * 2
    )

    for(i in seq_len(n)){

      set.seed(seed + i)

      time_names.i <- sort(
        sample(
          x = time_names,
          size = rows
          )
        )

      tsl[[i]] <- zoo::zoo(
        x = as.matrix(tsl[[i]]),
        order.by = time_names.i
      )

    }

  }

  # names ----
  if(length(tsl) <= length(LETTERS)){
    names_tsl <- LETTERS[seq_len(length(tsl))]
  } else {
    names_tsl <- as.vector(outer(LETTERS, LETTERS, paste0))[seq_len(length(tsl))]
  }
  names(tsl) <- names_tsl

  tsl <- tsl_names_set(
    tsl = tsl,
    names = names_tsl
  )

  # rescale ----
  tsl <- tsl_transform(
    tsl = tsl,
    f = f_rescale,
    new_min = min(data_range),
    new_max = max(data_range)
  )

  tsl

}
