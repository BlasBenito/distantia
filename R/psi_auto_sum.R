#' Auto Sum
#'
#' @description Computes the sum of distances between consecutive samples in two multivariate time-series under comparison. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985).
#'
#' @param y (required, data frame) a sequence. Default: NULL.
#' @param x (required, data frame) a sequence. Default: NULL.
#' @param path (required, data frame) dataframe produced by [psi_cost_path()]. Only required when [psi_cost_path_trim_blocks()] has been applied to `path`. Default: NULL.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @return Named vector with the auto sums of `y` and `x`.
#' @examples
#'
#' xy_sum <- psi_auto_sum(
#'   y = y,
#'   x = x,
#'   distance = "manhattan"
#' )
#'
#' xy_sum
#'
#' @export
#' @autoglobal
psi_auto_sum <- function(
    y = NULL,
    x = NULL,
    path = NULL,
    distance = "euclidean"
    ){

  #managing distance method
  distance <- utils_check_distance_args(
    distance = distance
  )[1]


  if(!is.null(path)){

    path <- utils_check_path_args(
      path = path
    )

    xy_sum <- auto_sum_path_cpp(
      x = x,
      y = y,
      path = path,
      distance = distance
    )

  } else {

    xy_sum <- auto_sum_no_path_cpp(
      y = x,
      x = y,
      distance = distance
    )

  }

 xy_sum

}
