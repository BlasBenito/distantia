#' Sum of Auto Distances Between Adjacent Cases in a Sequence
#'
#' @param x (required, data frame or matrix) a zoo time series or numeric matrix. Default: NULL
#' @param path (optional, data frame) result of [psi_cost_path_trim_blocks()], only required if blocks in the least cost path were ignored. Default: NULL
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return numeric value
#' @export
#' @autoglobal
#' @examples
#' #simulate two time series
#' tsl <- tsl_simulate(
#'   n = 2
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl)
#' }
#'
#' #step by step computation of psi
#'
#' #common distance method
#' dist_method <- "euclidean"
#'
#' #distance matrix
#' d <- psi_dist_matrix(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   distance = dist_method
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(m = d)
#' }
#'
#' #cost matrix
#' m <- psi_cost_matrix(
#'   dist_matrix = d
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(m = m)
#' }
#'
#' #least cost path
#' path <- psi_cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = m,
#'     path = path
#'     )
#' }
#'
#' #sum of least cost path
#' path_sum <- psi_cost_path_sum(path = path)
#'
#' #auto sum of the time series
#' xy_sum <- psi_auto_sum(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   path = path,
#'   distance = dist_method
#' )
#'
#' #dissimilarity
#' psi <- psi(
#'   path_sum = path_sum,
#'   auto_sum = xy_sum
#' )
#'
#' psi
#'
#' #full computation in one line
#' distantia(
#'   tsl = tsl
#' )$psi
#'
#' #dissimilarity plot
#' distantia_plot(
#'   tsl = tsl
#' )
#' @family psi_demo
psi_auto_distance <- function(
    x = NULL,
    path = NULL,
    distance = "euclidean"
    ){

  #check x
  x <- utils_check_zoo_args(
    x = x,
    arg_name = "x"
  )

  #check distance
  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  #subset time series using path
  if(!is.null(path)){

    path <- utils_check_path_args(
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
        "Argument 'path' was computed for the sequences ",
        paste(
          colnames(path)[c(1, 2)],
          collapse =  " and "
        ),
        ", but time series 'x' is named ",
        attributes(x)$name,
        "."
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
