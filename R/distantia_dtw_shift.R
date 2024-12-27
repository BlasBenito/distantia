#' Time Shift Between Time Series
#'
#' @description
#' This function computes an approximation to the time-shift between pairs of time series as the absolute time difference between pairs of observations in the time series *x* and *y* connected by the dynamic time warping path.
#'
#' If the time series are long enough, the extremes of the warping path are trimmed (5% of the total path length each) to avoid artifacts due to early misalignments.
#'
#' It returns a data frame with the modal, mean, median, minimum, maximum, quantiles 0.25 and 0.75, and standard deviation. The modal and the median are the most generally accurate time-shift descriptors.
#'
#' This function requires scaled and detrended time series. Still, it might yield non-sensical results in case of degenerate warping paths. Plotting dubious results with [distantia_dtw_plot())] is always a good approach to identify these cases.
#'
#'
#' @inheritParams distantia
#' @param two_way (optional, logical) If TRUE, the time shift between the time series pairs *y* and *x* is added to the results
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' #load two long-term temperature time series
#' #local scaling to focus in shape rather than values
#' #polynomial detrending to make them stationary
#' tsl <- tsl_init(
#'   x = cities_temperature[
#'     cities_temperature$name %in% c("London", "Kinshasa"),
#'     ],
#'   name = "name",
#'   time = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_local
#'   ) |>
#'   tsl_transform(
#'     f = f_detrend_poly,
#'     degree = 35 #data years
#'   )
#'
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     guide = FALSE
#'   )
#' }
#'
#' #compute shifts
#' df_shift <- distantia_dtw_shift(
#'   tsl = tsl,
#'   two_way = TRUE
#' )
#'
#' df_shift
#' #positive shift values indicate that the samples in Kinshasa are aligned with older samples in London.
#' @family distantia_support
distantia_dtw_shift <- function(
    tsl = NULL,
    distance = "euclidean",
    bandwidth = 1,
    two_way = FALSE
){

  #check input arguments
  args <- utils_check_args_distantia(
    tsl = tsl,
    distance = distance[1]
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

  #function to compute modal of differences
  shift_modal <- function(x) {
    ux <- unique(na.omit(x))
    y <- ux[which.max(tabulate(match(x, ux)))][1]
    class(y) <- class(x)
    attr(x = y, which = "units") <- attributes(x)$units
    y
  }

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

    #compute least cost path
    cost_path.i <- cost_path_cpp(
      x = tsl[[df.i[["x"]]]],
      y = tsl[[df.i[["y"]]]],
      distance = distance,
      diagonal = TRUE,
      weighted = TRUE,
      ignore_blocks = FALSE,
      bandwidth = bandwidth
    )

    #remove duplicates
    cost_path.i <- cost_path.i[
      !(duplicated(cost_path.i[["x"]]) |
          duplicated(cost_path.i[["y"]])),
      c("x", "y")
    ]

    #compute 5% padding
    padding <- ceiling(nrow(cost_path.i)/100) * 5

    #compute n to assess if we apply padding
    n <- nrow(cost_path.i) - (padding * 2)

    if(n >= 30){

      cost_path.i <- cost_path.i[padding:(nrow(cost_path.i)-padding),]

    }

    #check time series units
    shift.time.i.units.x <- zoo_time(x = tsl[[df.i[["x"]]]])$units

    shift.time.i.units.y <- zoo_time(x = tsl[[df.i[["y"]]]])$units

    if(shift.time.i.units.x != shift.time.i.units.y){

      warning(
        "distantia::distantia_dtw_shift(): time series '",
        df[["x"]], "' and '", df[["y"]], "' have different time units (",
        shift.time.i.units.x,
        " vs ",
        shift.time.i.units.y,
        ". Computing time shift with units 'samples'."
      )

      shift.time.i.units <- "samples"

      #time difference
      shift.time.i <- cost_path.i[["x"]] - cost_path.i[["y"]]

    } else {

      shift.time.i.units <- shift.time.i.units.x

      #add time
      cost_path.i[["x_time"]] <- zoo::index(
        x = tsl[[df.i[["x"]]]]
      )[cost_path.i[["x"]]]

      cost_path.i[["y_time"]] <- zoo::index(
        x = tsl[[df.i[["y"]]]]
      )[cost_path.i[["y"]]]

      #time difference
      shift.time.i <- cost_path.i[["x_time"]] - cost_path.i[["y_time"]]

    }

    #convert to numeric to remove units
    shift.time.i <- as.numeric(shift.time.i)

    df.i[["path_length"]] <- nrow(cost_path.i)

    df.i[["units"]] <- shift.time.i.units

    df.i[["min"]] <- min(
      x = shift.time.i,
      na.rm = TRUE
    )

    df.i[["q1"]] <- stats::quantile(
      x = shift.time.i,
      probs = 0.25,
      na.rm = TRUE
    )

    df.i[["median"]] <- stats::median(
      x = shift.time.i,
      na.rm = TRUE
    )

    df.i[["mean"]] <- mean(
      x = shift.time.i,
      na.rm = TRUE
    )

    df.i[["modal"]] <- shift_modal(x = shift.time.i)

    df.i[["q3"]] <- stats::quantile(
      x = shift.time.i,
      probs = 0.75,
      na.rm = TRUE
    )

    df.i[["max"]] <- max(
      x = shift.time.i,
      na.rm = TRUE
    )

    df.i[["sd"]] <- stats::sd(
      x = shift.time.i,
      na.rm = TRUE
    )

    #add tow way df
    if(two_way == TRUE){

      df.j <- df.i

      df.j[["x"]] <- df.i[["y"]]
      df.j[["y"]] <- df.i[["x"]]

      df.j[["min"]] <- - df.i[["min"]]
      df.j[["q1"]] <- - df.i[["q1"]]
      df.j[["median"]] <- - df.i[["median"]]
      df.j[["mean"]] <- - df.i[["mean"]]
      df.j[["modal"]] <- - df.i[["modal"]]
      df.j[["q3"]] <- - df.i[["q3"]]
      df.j[["max"]] <- - df.i[["max"]]

      df.i <- rbind(
        df.i,
        df.j
      )

    }

    df.i

  }

  #add type
  attr(
    x = df_shift,
    which = "type"
  ) <- "time_shift_df"

  df_shift

}
