#' Time Delay Between Time Series
#'
#' @description
#' This function computes an approximation to the time-delay between pairs of time series as the difference between observations connected by the dynamic time warping path.
#'
#' Given a pair of time series `x` and `y`, and the time of their samples in the dynamic time warping `time(x)` and `time(y)`, when the argument `directional` is `TRUE`, the time delay is computed as follows:
#'\itemize{
#' \item Time delay from `x` to `y`: `time(y) - time(x)`.
#' \item Time delay from `y` to `x`: `time(x) - time(y)`
#'}
#' In such case, two rows per pair of time series are returend. Otherwise, the time delay is computed as `abs(time(y) - time(x))`, and only one row per pair of time series is returned.
#'
#' If the time series have more than 30 observations, a 5% of the cases are omitted at each extreme of the warping path to avoid overestimating time delays due to early misalignments.
#'
#' The function returns a data frame with the names of the time series in the columns *x* and *y*, and the stats of the time-delay. The modal and the median are the most generally accurate time-delay metrics
#'
#' This function requires scaled and detrended time series. Still, it might yield non-sensical results in case of degenerate warping paths. Plotting dubious results with [distantia_dtw_plot())] is always a good approach to identify these cases.
#'
#' @inheritParams distantia
#' @param directional (optional, logical) If TRUE, a directional time-delay is computed as `x to y` and `y to x`, resulting in two rows per pair of time series. Otherwise, the absolute magnitude of de delay between `x` and `y` is returned a a single row per pair. Default: TRUE
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
#' df_shift <- distantia_time_delay(
#'   tsl = tsl,
#'   directional = TRUE
#' )
#'
#' df_shift
#' @family distantia_support
distantia_time_delay <- function(
    tsl = NULL,
    distance = "euclidean",
    bandwidth = 1,
    directional = FALSE
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
  delay_modal <- function(x) {
    ux <- unique(na.omit(x))
    y <- ux[which.max(tabulate(match(x, ux)))][1]
    class(y) <- class(x)
    attr(x = y, which = "units") <- attributes(x)$units
    y
  }

  iterations <- seq_len(nrow(df))

  p <- progressr::progressor(along = iterations)

  #iterate over pairs of time series
  df_delay <- foreach::foreach(
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

    #apply padding when 30 or more cases
    if(n >= 30){

      cost_path.i <- cost_path.i[padding:(nrow(cost_path.i) - padding),]

    }

    #check time series units
    delay.units.x <- zoo_time(x = tsl[[df.i[["x"]]]])$units
    delay.units.y <- zoo_time(x = tsl[[df.i[["y"]]]])$units

    #compare by sample if units do not match
    if(delay.units.x != delay.units.y){

      warning(
        "distantia::distantia_time_delay(): time series '",
        df[["x"]], "' and '", df[["y"]], "' have different time units (",
        delay.units.x,
        " vs ",
        delay.units.y,
        ". Computing time delay with units 'samples'."
      )

      #change default units
      delay.units <- "samples"

      #sample columns
      colname_x <- "x"
      colname_y <- "y"

    } else {

      #create time columns
      cost_path.i[["x_time"]] <- zoo::index(
        x = tsl[[df.i[["x"]]]]
      )[cost_path.i[["x"]]]

      cost_path.i[["y_time"]] <- zoo::index(
        x = tsl[[df.i[["y"]]]]
      )[cost_path.i[["y"]]]

      #default delay units
      delay.units <- delay.units.x

      #default time column names
      colname_x <- "x_time"
      colname_y <- "y_time"

    }

    #time difference from x to y
    if(directional == FALSE){

      delay.x_to_y <- abs(as.numeric(cost_path.i[[colname_x]] - cost_path.i[[colname_y]]))

    } else {

      delay.x_to_y <- as.numeric(cost_path.i[[colname_y]] - cost_path.i[[colname_x]])

      delay.y_to_x <- as.numeric(cost_path.i[[colname_x]] - cost_path.i[[colname_y]])

    }

    #add units
    df.i[["units"]] <- delay.units

    df.i[["min"]] <- min(
      x = delay.x_to_y,
      na.rm = TRUE
    )

    df.i[["q1"]] <- stats::quantile(
      x = delay.x_to_y,
      na.rm = TRUE,
      probs = 0.25
    )

    #compute stats x to y
    df.i[["median"]] <- stats::median(
      x = delay.x_to_y,
      na.rm = TRUE
    )

    df.i[["modal"]] <- delay_modal(x = delay.x_to_y)

    df.i[["mean"]] <- mean(
      x = delay.x_to_y,
      na.rm = TRUE
    )

    df.i[["q3"]][1] <- stats::quantile(
      x = delay.x_to_y,
      na.rm = TRUE,
      probs = 0.75
    )

    df.i[["max"]] <- max(
      x = delay.x_to_y,
      na.rm = TRUE
    )

    #compute stats y to x
    if(directional == TRUE){

      df.j <- df.i
      df.j$x <- df.i$y
      df.j$y <- df.i$x


      df.j[["min"]] <- min(
        x = delay.y_to_x,
        na.rm = TRUE
      )

      df.j[["q1"]] <- stats::quantile(
        x = delay.y_to_x,
        na.rm = TRUE,
        probs = 0.25
      )

      df.j[["median"]] <- stats::median(
        x = delay.y_to_x,
        na.rm = TRUE
      )

      df.j[["modal"]] <- delay_modal(x = delay.y_to_x)


      df.j[["mean"]] <- mean(
        x = delay.y_to_x,
        na.rm = TRUE
      )

      df.j[["q3"]] <- stats::quantile(
        x = delay.y_to_x,
        na.rm = TRUE,
        probs = 0.75
      )

      df.j[["max"]] <- max(
        x = delay.y_to_x,
        na.rm = TRUE
      )

      df.i <- rbind(
        df.i,
        df.j
      )

    }

    df.i

  }

  rownames(df_delay) <- NULL

  #add type
  attr(
    x = df_delay,
    which = "type"
  ) <- "time_delay_df"

  df_delay

}
