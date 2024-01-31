#' Least Cost Path to Combine Sequences
#'
#' @description
#' This is an internal function of [combine()].
#'
#'
#' @param x (required, list of matrices) list of input matrices generated with [prepare_sequences()]. For this function, only the first two elements in `x` are used.
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return A least cost path
#' @export
#' @autoglobal
combination_path <- function(
    x,
    distance = "euclidean"
    ){

  x <- check_args_x(
    x = x
  )

  #computing distance matrix
  dist_matrix <- distance_matrix_cpp(
    x = x[[1]],
    y = x[[2]],
    distance = distance
  )

  #computing cost matrix
  cost_matrix <- cost_matrix_cpp(
    dist_matrix = dist_matrix
  )

  #least cost path
  path <- cost_path_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )

  #reverse path
  path <- path[
    seq(
      from = nrow(path),
      to = 1,
      by = -1
    ),
  ]

  #maximum rows of each sequence
  nrow.path <- nrow(path)

  #last fake row
  last.row <- data.frame(
    x = ifelse(
      test = path$x[nrow.path] == path$x[nrow.path - 1],
      yes = path$x[nrow.path] + 1,
      no = path$x[nrow.path]
    ),
    y = ifelse(
      test = path$y[nrow.path] == path$y[nrow.path - 1],
      yes = path$y[nrow.path] + 1,
      no = path$y[nrow.path]
    ),
    dist = path$dist[nrow.path],
    cost = path$cost[nrow.path]
  )

  #join fake row
  path <- rbind(
    path,
    last.row
  )

  #edit path to facilitate slotting
  path <- path |>
    dplyr::group_by(y) |>
    dplyr::mutate(
      y_ = dplyr::case_when(
        dplyr::n() > 1 & x < max(x, na.rm = TRUE) ~ NA,
        TRUE ~ y
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::group_by(x) |>
    dplyr::mutate(
      x_ = dplyr::case_when(
        dplyr::n() > 1 & y < max(y, na.rm = TRUE) ~ NA,
        TRUE ~ x
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      y = y_,
      x = x_
    ) |>
    as.data.frame()

  path

}
