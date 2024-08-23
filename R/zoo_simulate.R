#' Simulate Zoo Time Series
#'
#' @description
#' Generates simulated zoo time series.
#'
#' @param cols (optional, integer) Number of time series. Default: 5
#' @param rows (optional, integer) Length of the time series. Minimum is 10, but maximum is not limited. Very large numbers might crash the R session. Default: 100
#' @param time_range (optional character or numeric vector) Interval of the time series. Either a character vector with dates in format YYYY-MM-DD or or a numeric vector. If there is a mismatch between `time_range` and `rows` (for example, the number of days in `time_range` is smaller than `rows`), the upper value in `time_range` is adapted to `rows`. Default: c("2010-01-01", "2020-01-01")
#' @param data_range (optional, numeric vector of length 2) Extremes of the simulated time series values. The simulated time series are independently adjusted to random values within the provided range. Default: c(0, 1)
#' @param seasons (optional, integer) Number of seasons in the resulting time series. The maximum number of seasons is computed as `floor(rows/3)`. Default: 0
#' @param na_fraction (optional, numeric) Value between 0 and 0.5 indicating the approximate fraction of NA data in the simulated time series. Default: 0.
#' @param independent (optional, logical) If TRUE, each new column in a simulated time series is averaged with the previous column. Irrelevant when `cols <= 2`, and hard to perceive in the output when `seasons > 0`. Default: FALSE
#' @param irregular (optional, logical) If TRUE, the time series is created with 20 percent more rows, and a random 20 percent of rows are removed at random. Default: TRUE
#' @param seed (optional, integer) Random seed used to simulate the zoo object. Default: NULL
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @examples
#'
#' #generates a different time series on each execution when 'seed = NULL'
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
#' @family zoo_functions
zoo_simulate <- function(
    cols = 5,
    rows = 100,
    time_range = c("2010-01-01", "2020-01-01"),
    data_range = c(0, 1),
    seasons = 0,
    na_fraction = 0,
    independent = FALSE,
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

  # seed ----
  if(is.null(seed)){
    seed <- sample.int(
      n = .Machine$integer.max,
      size = 1
    )
  }
  set.seed(as.integer(seed[1]))

  # data_range ----
  if(length(data_range) == 1 || length(unique(data_range)) == 1){
    stop("Argument 'data_range' must have two different values.")
  }
  if(!is.numeric(data_range)){
    data_range <- c(0, 1)
  }

  data_range_min <- min(data_range)
  data_range_max <- max(data_range)


  # time range ----
  if(length(time_range) != 2){
    stop("Argument 'time_range' must be a vector of length 2.")
  }

  time_range <- utils_as_time(
    x = time_range
  ) |>
    range()

  # irregular ----
  if(!is.logical(irregular)){
    irregular <- FALSE
  }

  #generating regular or irregular time vector
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
    independent <- FALSE
  }

  # create empty matrix
  m <- m_copy <- matrix(
    data = NA,
    nrow = rows,
    ncol = cols,
    dimnames = list(
      as.character(time_vector),
      cols.names
    )
  )

  #distribution of sd for rnorm
  sd_vector <- seq(
    from = ifelse(
      test = independent == TRUE,
      yes = 0.01,
      no = 0.5
    ),
    to = 1,
    by = 0.01
  )

  #generate template
  seasons <- min(
    floor(rows / 3),
    as.integer(abs(seasons))
    )

  template <- if(seasons > 0){
    #seasonal template
    sin(x = 2 * pi * seq_len(rows) / (rows / seasons))
  } else {
    #neutral template
    rep(x = 0, times = rows)
  }

  #iterate over columns of the empty matrix
  for(i in seq_len(ncol(m))){

    #cumulative sum of random values from a normal distribution
    values.i <- stats::rnorm(
      n = rows,
      sd = sample(
        x = sd_vector,
        size = 1
      )
    ) |>
      cumsum()

    #add to template
    values.i <- values.i + (template * 2)

    #store them in unaltered copy for next iteration
    m_copy[, i] <- values.i

    #create dependence with previous values
    if(independent == FALSE && i > 1){

      #create dependency
      values.i <- (values.i + m_copy[, i - 1]) / 2

    }

    # add seasonal component
    if(seasons > 0) {

      values.i <- values.i +
        sin(
          x = 2 * pi * seq_len(rows) / (rows / seasons)
        )

    }

    #rescale to data_range
    #but adding some random variability
    #minimum within the 1/third of the lower range values
    #maximum within the 1/third of the upper range values
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
