#' Cumulative Sum of Distances Between Consecutive Cases in a Time Series
#'
#' @description
#' Demonstration function to compute the sum of distances between consecutive cases in a time series.
#'
#' @param x (required, zoo object or matrix) univariate or multivariate time series with no NAs. Default: NULL
#' @param path (optional, data frame) result of [psi_cost_path_ignore_blocks()], only required if blocks in the least cost path were ignored. Default: NULL
#' @inheritParams distantia
#'
#' @return numeric value
#' @export
#' @autoglobal
#' @examples
#' #distance metric
#' d <- "euclidean"
#'
#' #simulate zoo time series
#' x <- zoo_simulate(
#'   name = "x",
#'   rows = 100,
#'   seasons = 2,
#'   seed = 1
#' )
#'
#' #sum distance between consecutive samples
#' psi_auto_distance(
#'   x = x,
#'   distance = d
#' )
#' @family psi_demo
psi_auto_distance <- function(
    x = NULL,
    path = NULL,
    distance = "euclidean"
    ){

  #check x
  x <- utils_check_args_zoo(
    x = x,
    arg_name = "x"
  )

  #check distance
  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  #subset time series using path
  if(!is.null(path)){

    path <- utils_check_args_path(
      path = path
    )

    #rename path columns
    colnames(path)[colnames(path) == "x"] <- attributes(path)$x_name

    colnames(path)[colnames(path) == "y"] <- attributes(path)$y_name

    #error if path does not correspond to the sequences
    if(
      !(attributes(x)$name %in% names(path)[c(1, 2)])
    ){
      stop(
        "distantia::psi_auto_distance(): argument 'path' was computed for the sequences ",
        paste(
          colnames(path)[c(1, 2)],
          collapse =  " and "
        ),
        ", but time series 'x' is named ",
        attributes(x)$name,
        ".",
        call. = FALSE
        )
    }

    #subset time series
    x.path <- subset_matrix_by_rows_cpp(
      m = x,
      rows = path[[attributes(x)$name]]
    )

  }

  #auto sum
  x.auto_distance <- auto_distance_cpp(
    x = x,
    distance = distance
  )

  x.auto_distance

}
