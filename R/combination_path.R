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

  #computing distance matrix
  dist_matrix <- distance_matrix_cpp(
    a = x[[1]],
    b = x[[2]],
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
  nrow.a <- max(path$a)
  nrow.b <- max(path$b)
  nrow.path <- nrow(path)

  #last fake row
  last.row <- data.frame(
    a = ifelse(
      test = path$a[nrow.path] == path$a[nrow.path - 1],
      yes = path$a[nrow.path] + 1,
      no = path$a[nrow.path]
    ),
    b = ifelse(
      test = path$b[nrow.path] == path$b[nrow.path - 1],
      yes = path$b[nrow.path] + 1,
      no = path$b[nrow.path]
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
    dplyr::group_by(a) |>
    dplyr::mutate(
      a_ = dplyr::case_when(
        dplyr::n() > 1 & b < max(b, na.rm = TRUE) ~ NA,
        TRUE ~ a
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::group_by(b) |>
    dplyr::mutate(
      b_ = dplyr::case_when(
        dplyr::n() > 1 & a < max(a, na.rm = TRUE) ~ NA,
        TRUE ~ b
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      a = a_,
      b = b_
    ) |>
    as.data.frame()

  path

}
