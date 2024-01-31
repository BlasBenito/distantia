#' Auto Sum
#'
#' @description Computes the sum of distances between consecutive samples in two multivariate time-series under comparison. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985).
#'
#' @param y (required, data frame) a sequence. Default: NULL.
#' @param x (required, data frame) a sequence. Default: NULL.
#' @param path (required, data frame) dataframe produced by [cost_path()]. Only required when [cost_path_trim()] has been applied to `path`. Default: NULL.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @return Named vector with the auto sums of `y` and `x`.
#' @examples
#' data(sequenceA, sequenceB)
#'
#' y <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' x <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' xy_sum <- auto_sum(
#'   y = y,
#'   x = x,
#'   distance = "manhattan"
#' )
#'
#' xy_sum
#'
#' @export
#' @autoglobal
auto_sum <- function(
    y = NULL,
    x = NULL,
    path = NULL,
    distance = "euclidean"
    ){

  #check and prepare arguments
  xy <- prepare_xy(
    x = x,
    y = y,
    distance = distance
  )

  #managing distance method
  distance <- check_args_distance(
    distance = distance
  )[1]


  if(!is.null(path)){

    path <- check_args_path(
      path = path
    )

    xy_sum <- auto_sum_path_cpp(
      x = xy[[1]],
      y = xy[[2]],
      path = path,
      distance = distance
    )

  } else {

    xy_sum <- auto_sum_no_path_cpp(
      y = xy[[1]],
      x = xy[[2]],
      distance = distance
    )

  }

 xy_sum

}
