#' Time Shift Between Time Series
#'
#' @description
#' This function computes an approximation to the time-shift between pairs of time series as the absolute time difference between pairs of observations connected by the time warping path. It returns a data frame with the modal, mean, median, minimum, maximum, quantiles 0.25 and 0.75, and standard deviation of the time shift. The modal and the median are the most generally accurate time-shift descriptors.
#'
#' This function requires scaled and detrended time series. Still, it might yield non-sensical results in case of degenerate warping paths. Plotting dubious results with [distantia_dtw_plot())] is always a good approach to identify these cases.
#'
#'
#' @inheritParams distantia
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' #load two long-term temperature time series
#' #local scaling to focus in shape rather than values
#' #polynomial detrending to make them stationary
#' tsl <- tsl_init(
#'   x = cities_temperature,
#'   name = "name",
#'   time = "time"
#' ) |>
#'   tsl_subset(
#'     names = c("London", "Kinshasa")
#'   ) |>
#'   tsl_transform(
#'     f = f_scale_local
#'   ) |>
#'   tsl_transform(
#'     f = f_detrend_poly
#'   )
#'
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl
#'   )
#' }
#'
#' #compute shifts
#' df_shift <- distantia_dtw_shift(
#'   tsl = tsl,
#'   distance = "euclidean"
#' )
#' df_shift
#'
#' #check alignment
#' distantia_dtw_plot(
#'   tsl = tsl
#' )
#' @importFrom doFuture "%dofuture%"
#' @family distantia_support
distantia_dtw_shift <- function(
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

  #function to compute modal of differences
  shift_modal <- function(x) {
    ux <- unique(na.omit(x))
    y <- ux[which.max(tabulate(match(x, ux)))][1]
    class(y) <- class(x)
    attr(x = y, which = "units") <- attributes(x)$units
    y
  }

  #iterate over pairs of time series
  df_shift <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %dofuture% {

    p()

    df.i <- df[i, ]

    x <- tsl[[df.i[["x"]]]]
    y <- tsl[[df.i[["y"]]]]

    #compute least cost path
    cost_path.i <- cost_path_cpp(
      x = x,
      y = y,
      distance = df.i[["distance"]],
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
      x = x
    )[cost_path.i$x]

    cost_path.i$y_time <- zoo::index(
      x = y
    )[cost_path.i$y]

    #difference between aligned cases
    shift.time.i <- abs(cost_path.i$x_time - cost_path.i$y_time)

    #store shift stats
    df.i$modal <- shift_modal(x = shift.time.i)

    df.i$mean <- mean(
      x = shift.time.i,
      na.rm = TRUE
      )

    df.i$min <- min(
      x = shift.time.i,
      na.rm = TRUE
      )

    df.i$q1 <- stats::quantile(
      x = shift.time.i,
      probs = 0.25,
      na.rm = TRUE
      )

    df.i$median <- stats::median(
      x = shift.time.i,
      na.rm = TRUE
      )

    df.i$q3 <- stats::quantile(
      x = shift.time.i,
      probs = 0.75,
      na.rm = TRUE
      )

    df.i$max <- max(
      x = shift.time.i,
      na.rm = TRUE
      )

    df.i$sd <- stats::sd(
      x = shift.time.i,
      na.rm = TRUE
      )

    df.i

  }

  #add type
  attr(
    x = df_shift,
    which = "type"
  ) <- "time_shift_df"

  df_shift

}
