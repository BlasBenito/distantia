#' Create Dummy Zoo Time Series
#'
#' @param cols (optional, integer) Number of time series.
#' @param rows (optional, integer) Length of time series.
#' @param time_interval (optional character or numeric vector) Interval of the time series. Either a character vector with dates in format YYYY-MM-DD or or a numeric vector.
#' @param irregular (optional, logical) If TRUE, the time series is created with an additional 20% rows, and a random 20% of rows is removed.
#' @param seed (optional, integer) Random seed to generate the dummy time series.
#'
#' @return zoo object.
#' @export
#' @autoglobal
#' @examples
zoo_random <- function(
    cols = 5,
    rows = 100,
    time_interval = c("2020-01-01", "2024-01-01"),
    irregular = TRUE,
    seed = 1
){

  #handling cols
  cols <- ifelse(
    test = cols > length(letters),
    yes = length(letters),
    no = cols
  )
  cols.names <- letters[seq_len(cols)]

  #handling rows
  rows <- as.integer(rows)
  rows <- ifelse(
    test = rows < 10,
    yes = 10,
    no = rows
  )

  if(irregular == TRUE){
    old.rows <- rows
    rows <- ceiling(rows + rows/20)
  } else {
    old.rows <- rows
  }

  time_interval <- time_interval[c(1, 2)]
  if(is.character(time_interval)){
    time_interval <- as.Date(time_interval)
  }

  rows.names <- seq(
    from = min(time_interval),
    to = max(time_interval),
    length.out = rows
  )

  m <- matrix(
    data = NA,
    nrow = rows,
    ncol = cols,
    dimnames = list(
      as.character(rows.names),
      cols.names
    )
  )

  set.seed(seed)

  m <- apply(
    X = m,
    MARGIN = 2,
    FUN = function(x){
      cumsum(rnorm(n = rows))
    }
  )

  if(irregular == TRUE){

    samples <- sample(
      x = nrow(m),
      size = old.rows
    ) |>
      sort()

    m <- m[samples, ]
    rows.names <- rows.names[samples]
  }

  m <- zoo::zoo(
    x = m,
    order.by = rows.names
  )

  m

}
