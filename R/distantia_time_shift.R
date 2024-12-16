#' Time Shift Between Time Series
#'
#' @description
#' This function applies dynamic time warping to compute the least cost path between pairs of time series in a TSL and assess their time shift. Thime shift is computed as the absolute time difference between pairs of observations connected by the least cost path.
#'
#' The function returns a data frame with the mean, median, minimum, maximum, quantiles 0.25 and 0.75, and standard deviation of the time shift.
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
#'     names = c("Paris", "London", "Kinshasa"),
#'     time = c("2000-01-01", "2010-01-01")
#'   ) |>
#'   tsl_transform(
#'     f = f_scale_local
#'   )
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
#' @family dissimilarity_analysis
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

  #to silence loading messages
  `%iterator%` <- suppressPackageStartupMessages(doFuture::`%dofuture%`)

  for_each <- suppressPackageStartupMessages(foreach::foreach)

  #iterate over pairs of time series
  df_shift <- for_each(
    i = iterations,
    .combine = "rbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    p()

    df.i <- df[i, ]

    cost_path.i <- cost_path_cpp(
      x = tsl[[df.i$x]],
      y = tsl[[df.i$y]],
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
