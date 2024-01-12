#' Combination of Sequences via Least Cost Paths
#'
#' @param a (required, data frame, matrix, or numeric vector) a time series.
#' @param b (required, data frame, matrix, or numeric vector) a time series.
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return Data frame with composite sequence and columns identifying the origin of each new row.
#' @export
#' @autoglobal
slotting <- function(
    a = NULL,
    b = NULL,
    distance = "euclidean"
){

  distance <- check_args_distance(
    distance = distance
  )[1]

  ab <- prepare_ab(
    a = a,
    b = b,
    distance = distance
  )

  #computing distance matrix
  dist_matrix <- distance_matrix_cpp(
    a = ab[[1]],
    b = ab[[2]],
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

  ab[[1]] <- as.data.frame(ab[[1]])
  ab[[2]] <- as.data.frame(ab[[2]])
  ab[[1]]$name <- names(ab)[1]
  ab[[2]]$name <- names(ab)[2]
  ab[[1]]$row <- 1:nrow(ab[[1]])
  ab[[2]]$row <- 1:nrow(ab[[2]])

  #output data frame
  ab.combined <- ab[[1]][0, ]

  #iterating over path
  for(i in seq_len(nrow(path))){

    a.na <- is.na(path$a[i])
    b.na <- is.na(path$b[i])

    #never happens?
    if(a.na && b.na){
      next
    }

    if(a.na){
      new.row <- ab[[2]][path$b[i], ]
    }

    if(b.na){
      new.row <- ab[[1]][path$a[i], ]
    }

    if(!a.na && !b.na){
      candidate.rows <- c(path$a[i], path$b[i])
      j <- which.max(candidate.rows)
      k <- which.min(candidate.rows)
      new.row <- rbind(
        ab[[j]][path[i, j], ],
        ab[[k]][path[i, k], ]
      ) |>
        na.omit()
    }

    ab.combined <- rbind(
      ab.combined,
      new.row
    )

  } #end of combination loop

  ab.combined

}
