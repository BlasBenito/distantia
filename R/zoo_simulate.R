#' Simulate Zoo Time Series
#'
#' @description
#' Generates a simulated zoo time series.
#'
#' @param cols (optional, integer) Number of time series. Default: 5
#' @param rows (optional, integer) Length of the time series. Minimum is 10, but maximum is not limited. Very large numbers might crash the R session. Default: 100
#' @param time_range (optional character or numeric vector) Interval of the time series. Either a character vector with dates in format YYYY-MM-DD or or a numeric vector. If there is a mismatch between `time_range` and `rows` (for example, the number of days in `time_range` is smaller than `rows`), the upper value in `time_range` is adapted to `rows`. Default: c("2010-01-01", "2020-01-01")
#' @param data_range (optional, numeric vector of length 2) Extremes of the simulated time series values. The simulated time series are independently adjusted to random values within the provided range. Default: c(0, 1)
#' @param na_fraction (optional, numeric between 0 and 0.5) Fraction of NA data in the simulated time series. Default: 0.
#' @param independent (optional, logical) If TRUE, the zoo object is made of independent time series. Otherwise, each new time-series in the zoo object results from the addition of the previous ones. Irrelevant when `cols <= 2`. Default: TRUE
#' @param irregular (optional, logical) If TRUE, the time series is created with 20 percent more rows, and a random 20 percent of rows are removed at random. Default: TRUE
#' @param seed (optional, integer) Random seed used to simulate the zoo object. Default: NULL
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#'
#' #generates a different time series on each execution
#' x <- zoo_simulate()
#'
#' #returns a zoo object
#' class(x)
#'
#' #time series names are uppercase letters
#' #this attribute is not defined in the zoo class and might be lost during data transformations
#' attributes(x)$name
#'
#' #column names are lowercase letters
#' names(x)
#'
#' #plotting methods
#' if(interactive()){
#'
#'   #plot time series with default zoo method
#'   plot(x)
#'
#'   #plot time series with distantia
#'   distantia::zoo_plot(
#'     x = x,
#'     xlab = "Date",
#'     ylab = "Value",
#'     title = "My time series"
#'   )
#'
#' }
zoo_simulate <- function(
    cols = 5,
    rows = 100,
    time_range = c("2010-01-01", "2020-01-01"),
    data_range = c(0, 1),
    na_fraction = 0,
    independent = TRUE,
    irregular = TRUE,
    seed = NULL
){

  # columns ----
  cols <- as.integer(cols[1])

  if(cols > length(letters)){

    cols.names <- c(
      letters,
      as.vector(
        outer(
          X = letters,
          Y = letters,
          FUN = paste0
        )
      )
    )[seq_len(cols)]

  } else {

    cols.names <- letters[seq_len(cols)]

  }

  # rows ----
  rows <- as.integer(rows[1])

  rows <- ifelse(
    test = rows < 10,
    yes = 10,
    no = rows
  )

  # irregular ----
  if(!is.logical(irregular)){
    irregular <- FALSE
  }

  # irregular ----
  if(length(time_range) != 2){
    stop("Argument 'time_range' must be a vector of length 2.")
  }

  # handling time range

  #computing range
  time_range <- utils_as_time(
    x = time_range
  ) |>
    range()

  #converting to regular or irregular
  time_vector <- seq(
    from = min(time_range),
    to = max(time_range),
    length.out = rows * ifelse(
      test = irregular == TRUE,
      yes = 2,
      no = 1
      )
    ) |>
    sample(size = rows) |>
    sort()

  # data_range ----
  if(!is.numeric(data_range)){
    data_range <- c(0, 1)
  }

  data_range_min <- min(data_range)
  data_range_max <- max(data_range)

  # na_fraction ----
  na_fraction <- as.numeric(na_fraction[1])
  if(na_fraction < 0){
    na_fraction <- 0
  }
  if(na_fraction > 0.5){
    na_fraction <- 0.5
  }

  # independent ----
  if(!is.logical(independent)){
    independent <- TRUE
  }

  # seed ----
  if(is.null(seed)){
    seed <- sample.int(2^31 - 1, 1) - 2^30
  } else {
    set.seed(as.integer(seed[1]))
  }

  # create empty matrix
  m <- matrix(
    data = NA,
    nrow = rows,
    ncol = cols,
    dimnames = list(
      as.character(time_vector),
      cols.names
    )
  )

  #create copy to store unaltered values
  m_copy <- m

  #distribution of sd for rnorm
  sd_vector <- seq(from = 0.01, to = 1, by = 0.01)

  #iterate over columns of the empty matrix
  for(i in seq_len(ncol(m))){

    #generate values from a cumulative normal distribution
    values.i <- stats::rnorm(
      n = rows,
      sd = sample(
        x = sd_vector,
        size = 1
      )
    ) |>
      cumsum()

    #create dependence with previous values
    if(independent == FALSE && i > 1){

      #store them in unaltered copy for next iteration
      m_copy[, i] <- values.i

      #create dependency
      values.i <- (values.i + m_copy[, i - 1]) / 2

    }

    #generate new data range within data_range
    data_range.i <- stats::runif(
      n = 2,
      min = data_range_min,
      max = data_range_max
    )

    #rescale within data range
    values.i <- utils_rescale_vector(
      x = values.i,
      new_min = stats::runif(
        n = 1,
        min = data_range_min,
        max = data_range_max/3
        ),
      new_max = stats::runif(
        n = 1,
        min = data_range_max - (data_range_max/3),
        max = data_range_max
        ),
    )

    #save values in matrix column
    m[, i] <- values.i

  }

  #apply na_fraction
  m[
    sample.int(
      n = length(m),
      size = floor(length(m) * na_fraction)
    )
  ] <- NA

  #to zoo
  m <- zoo::zoo(
    x = m,
    order.by = time_vector
  )

  attr(
    x = m,
    which = "name"
  ) <- "A"

  m

}
