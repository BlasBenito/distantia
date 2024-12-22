#' Time Shift Between Time Series
#'
#' @description
#' This function computes an approximation to the time-shift between pairs of time series as the absolute time difference between pairs of observations connected by the time warping path. It returns a data frame with the mean, median, minimum, maximum, quantiles 0.25 and 0.75, and standard deviation of the time shift.
#'
#' This function requires scaled and detrended time series. Still, it might yield non-sensical results.
#'
#'
#' @inheritParams distantia
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' #load three time series
#' tsl <- tsl_init(
#'   x = cities_temperature,
#'   name = "name",
#'   time = "time"
#' ) |>
#'   tsl_subset(
#'     names = c("London", "Kinshasa"),
#'     time = c("2000-01-01", "2010-01-01")
#'   ) |>
#'   tsl_transform(
#'     f = f_scale_local
#'   )
#'
#' #the data has a polynomial trend
#' tsl_trend <- tsl_transform(
#'   tsl = tsl,
#'   f = f_trend_poly
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl_trend
#'   )
#' }
#'
#' #polynomial detrending
#' tsl <- tsl_transform(
#'   tsl = tsl,
#'   f = f_detrend_poly
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl
#'   )
#' }
#'
#' #compute shifts
#' df_shift <- distantia_time_shift(
#'   tsl = tsl,
#'   distance = "euclidean"
#' )
#' df_shift
#'
#' #check alignment
#' distantia_plot(
#'   tsl = tsl[c("Kinshasa", "London")]
#' )
#' @family distantia_support
distantia_time_shift <- function(
    tsl = NULL,
    distance = "euclidean",
    bandwidth = 1
){

  #check input arguments
  args <- utils_check_args_distantia(
    tsl = tsl,
    distance = distance
  )

  tsl <- args$tsl
  distance <- args$distance

  #tsl pairs
  df <- utils_tsl_pairs(
    tsl = tsl,
    args_list = list(
      distance = distance
    )
  )

  iterations <- seq_len(nrow(df))

  p <- progressr::progressor(along = iterations)

  #iterate over pairs of time series
  df_shift <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %dofuture% {

    p()

    df.i <- df[i, ]

    x <- tsl[[df.i$x]]
    y <- tsl[[df.i$y]]

    cost_path.i <- cost_path_cpp(
      x = x,
      y = y,
      distance = df[i, "distance"],
      diagonal = TRUE,
      weighted = TRUE,
      ignore_blocks = FALSE,
      bandwidth = bandwidth
    )

    #remove duplicates
    cost_path.i <- cost_path.i[
      !(duplicated(cost_path.i$x) |
          duplicated(cost_path.i$y)),
      c("x", "y")
    ]

    #add time
    cost_path.i$x_time <- zoo::index(
      x = tsl[[df.i$x]]
    )[cost_path.i$x]

    cost_path.i$y_time <- zoo::index(
      x = tsl[[df.i$y]]
    )[cost_path.i$y]

    #compute shift
    shift.i <- abs(cost_path.i$x_time - cost_path.i$y_time)

    #store shift stats
    df.i$mean <- mean(shift.i, na.rm = TRUE)
    df.i$min <- min(shift.i, na.rm = TRUE)
    df.i$q1 <- stats::quantile(shift.i, probs = 0.25, na.rm = TRUE)
    df.i$median <- stats::median(shift.i, na.rm = TRUE)
    df.i$q3 <- stats::quantile(shift.i, probs = 0.75, na.rm = TRUE)
    df.i$max <- max(shift.i, na.rm = TRUE)
    df.i$sd <- stats::sd(shift.i, na.rm = TRUE)

    df.i

  }

  #add type
  attr(
    x = df_shift,
    which = "type"
  ) <- "time_shift_df"

  df_shift

}
