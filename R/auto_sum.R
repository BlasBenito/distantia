#' Auto Sum
#'
#' @description Computes the sum of distances between consecutive samples in two multivariate time-series under comparison. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985).
#'
#' @param a (required, data frame) a sequence. Default: NULL.
#' @param b (required, data frame) a sequence. Default: NULL.
#' @param path (required, data frame) dataframe produced by [cost_path()]. Only required when [cost_path_trim()] has been applied to `path`. Default: NULL.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @return Named vector with the auto sums of `a` and `b`.
#' @examples
#' data(sequenceA, sequenceB)
#'
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' ab_sum <- auto_sum(
#'   a = a,
#'   b = b,
#'   distance = "manhattan"
#' )
#'
#' ab_sum
#'
#' @export
#' @autoglobal
auto_sum <- function(
    a = NULL,
    b = NULL,
    path = NULL,
    distance = "euclidean"
    ){

  #managing distance method
  distance <- check_args_distance(
    distance = distance
  )[1]

  ab <- prepare_ab(
    a = a,
    b = b,
    distance = distance
  )

  if(!is.null(path)){

    ab_sum <- auto_sum_path_cpp(
      a = ab[[1]],
      b = ab[[2]],
      path = path,
      distance = distance
    )

  } else {

    ab_sum <- auto_sum_no_path_cpp(
      a = ab[[1]],
      b = ab[[2]],
      distance = distance
    )

  }

 ab_sum

}
