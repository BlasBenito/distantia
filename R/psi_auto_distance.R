#' Sum of Auto Distances Between Adjacent Cases in a Sequence
#'
#' @param x (required, data frame or matrix) a sequence.
#' @param path (optional, data frame) result of [psi_cost_path_trim_blocks()], only required if blocks in the least cost path were ignored.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return Sum of auto distances
#' @export
#' @autoglobal
#' @examples #TODO
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

  #subset sequence using path
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
        ", but sequence 'x' is named ",
        attributes(x)$name,
        "."
        )
    }

    #subset sequence
    x.path <- subset_matrix_by_rows_cpp(
      m = x,
      rows = path[[attributes(x)$name]]
    )

  }

  #auto sum
  x.auto_distance <- auto_distance_cpp(
    m = x,
    distance = distance
  )

  x.auto_distance

}
