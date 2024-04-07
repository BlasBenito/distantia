#' Time Features of a Zoo Object
#'
#' @param x (required, zoo object) Default: NULL.
#'
#' @return List with time features of the zoo object.
#' @export
#' @autoglobal
#' @examples
zoo_time <- function(
    x = NULL
){

  # #centuries and millenia
  # x <- zoo_simulate(
  #   time_range = c(
  #     "0100-02-08",
  #     "2024-12-31"
  #   )
  # )
  #
  # #days
  # x <- zoo_simulate(
  #   time_range = c(
  #     "2024-12-20 10:00:25",
  #     "2024-12-31 11:15:45"
  #   )
  # )
  #
  # #hours
  # x <- zoo_simulate(
  #   time_range = c(
  #     "2024-12-20 10:00:25",
  #     "2024-12-20 11:15:45"
  #   )
  # )
  #
  # #minutes
  # x <- zoo_simulate(
  #   time_range = c(
  #     "2024-12-20 10:00:25",
  #     "2024-12-20 10:27:32"
  #   )
  # )
  #
  # #seconds
  # x <- zoo_simulate(
  #   time_range = c(
  #     "2024-12-20 10:00:25",
  #     "2024-12-20 10:00:55"
  #   )
  # )
  #
  # x <- zoo_simulate(
  #   time_range = c(-123120, 1200)
  # )
  #
  # x <- zoo_simulate(
  #   time_range = c(0.01, 0.09)
  # )

  ################################

  if(zoo::is.zoo(x) == FALSE){
    stop("Argument 'x' must be a zoo time series.")
  }

  x_name <- attributes(x)$name
  if(is.null(x_name)){
    x_name <- ""
  }

  x_time <- stats::time(x)

  #class
  x_class <- class(x_time)
  if("POSIXct" %in% x_class){
    x_class <- "POSIXct"
  }

  #n
  x_n <- length(x_time)

  #range
  x_range <- range(x_time)

  #length
  x_length <- diff(x_range)
  x_length_units <- attributes(x_length)$units
  if(is.null(x_length_units)){
    x_length_units <- x_class
  }
  x_length <- as.numeric(x_length)

  #resolution
  x_time_diff <- diff(x_time)
  if(x_class != "numeric"){
    units(x_time_diff) <- x_length_units
  }
  x_resolution <- as.numeric(mean(x_time_diff))

  #output data frame
  df <- data.frame(
    name = x_name,
    n = x_n,
    class = x_class,
    units = x_length_units,
    begin = min(x_range),
    end = max(x_range),
    length = x_length,
    resolution = x_resolution
  )

  #units
  df_units <- utils_time_units(
    all_columns = TRUE,
    class = x_class
  )

  #subset by x_length_units
  df_units <- df_units[
    seq(
      from = min(which(df_units$base_units == x_length_units)),
      to = nrow(df_units),
      by = 1
    ),
  ]

  df_units <- df_units[
    df_units$threshold <= x_length & df_units$threshold >= x_resolution,
  ]

  if(nrow(df_units) > 0){
    df$keywords <- I(list(df_units$units))
  } else {
    if(x_class != "numeric"){
      df$keywords <- x_length_units
    }
  }

  df

}
