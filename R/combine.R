#' Combination of Sequences via Least Cost Path
#'
#' @description Combines two sequences by arranging their cases as defined in their orthogonal least cost path. When more than two sequences are provided in `x`, all sequences are first ordered according to their psi scores. Then, the first two sequences (the more similar ones) are combined first, and the remaining ones are added to the composite sequence one by one.
#'
#' @param x (required, list of matrices) list of input matrices generated with [tsl_prepare()].
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return Data frame with composite sequence and columns identifying the origin of each new row.
#' @export
#' @autoglobal
combine <- function(
    x = NULL,
    distance = "euclidean"
){

  # check input arguments ----
  x <- check_args_x(
    x = x
  )

  distance <- check_args_distance(
    distance = distance[1]
  )

  # sort sequences by similarity ----
  x <- arrange_by_similarity(
    x = x,
    distance = distance
  )

  #get names
  x.names <- names(x)

  # combine sequences sequentially ----

  # create output sequence
  x <- x[[x.names[1]]]

  #remove it from x.names
  x.names <- x.names[-1]

  # combine sequences ----
  while(length(x.names) > 0){

    #prepare sequences to merge them
    xy <- prepare_xy(
      x = x,
      y = x[[x.names[1]]],
      distance = distance
    )

    #generate least cost path to combine sequences
    path <- combination_path(
      x = xy,
      distance = distance
    )

    #add provenance columns
    xy[[1]] <- as.data.frame(xy[[1]])
    xy[[2]] <- as.data.frame(xy[[2]])
    xy[[1]]$name <- names(xy)[1]
    xy[[2]]$name <- names(xy)[2]
    xy[[1]]$row <- 1:nrow(xy[[1]])
    xy[[2]]$row <- 1:nrow(xy[[2]])

    #remove y from x.names
    x.names <- x.names[-1]

    #output data frame
    xy.combined <- xy[[1]][0, ]

    #iterating over path
    for(i in seq_len(nrow(path))){

      x.na <- is.na(path$x[i])
      y.na <- is.na(path$y[i])

      #never happens?
      if(x.na && y.na){
        next
      }

      if(x.na){
        new.row <- xy[[2]][path$y[i], ]
      }

      if(y.na){
        new.row <- xy[[1]][path$x[i], ]
      }

      if(!x.na && !y.na){
        candidate.rows <- c(path$x[i], path$y[i])
        j <- which.max(candidate.rows)
        k <- which.min(candidate.rows)
        new.row <- rbind(
          xy[[j]][path[i, j], ],
          xy[[k]][path[i, k], ]
        ) |>
          na.omit()
      }

      xy.combined <- rbind(
        xy.combined,
        new.row
      )

    } #end of combination loop

    rownames(xy.combined) <- NULL

    x <- xy.provenance <- xy.combined

  }

  xy.combined

}

#' Arrange Sequences by Similarity
#'
#' @description
#' Arranges sequences in a list by similarity. This is an internal function for the [combine()] function.
#'
#' @param x (required, list of matrices) list of input matrices generated with [tsl_prepare()].
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param diagonal (optional, logical vector). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted (optional, logical vector) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param ignore_blocks (optional, logical vector). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param paired_samples (optional, logical vector) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
#'
#' @return Vector with names of `x` ordered from higher to lower similarity with the previous sequences. The first two sequences are the most similar ones.
#' @export
#' @noRd
#' @keywords internal
#' @autoglobal
arrange_by_similarity <- function(
    x = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    paired_samples = FALSE
){

  x.distantia <- distantia(
    x = x,
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    paired_samples = paired_samples
  )

  x.distantia <- x.distantia[order(x.distantia$psi), ]

  x.order <- vector()

  for(i in seq_len(nrow(x.distantia))){

    x.order <- c(
      x.order,
      ifelse(
        test = x.distantia$name_a[i] %in% x.order,
        yes = NA,
        no = x.distantia$name_a[i]
      ),
      ifelse(
        test = x.distantia$name_b[i] %in% x.order,
        yes = NA,
        no = x.distantia$name_b[i]
      )
    )

  }

  x.order <- as.character(na.omit(x.order))

  x <- x[x.order]

  x

}


#' Least Cost Path to Combine Sequences
#'
#' @description
#' This is an internal function of [combine()].
#'
#'
#' @param x (required, list of matrices) list of input matrices generated with [tsl_prepare()]. For this function, only the first two elements in `x` are used.
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return A least cost path
#' @export
#' @noRd
#' @keywords internal
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
