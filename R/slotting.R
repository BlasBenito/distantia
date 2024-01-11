slotting <- function(
    a = NULL,
    b = NULL,
    distance = "euclidean"
){

  a <- sequenceA |>
  na.omit()
  b <- sequenceB |>
    na.omit()

  ab <- prepare_ab(
    a = a,
    b = b,
    distance = distance
  )

  distance <- check_args_distance(
    distance = distance
  )[1]

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

  #cost path
  path <- cost_path_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )

  #to data frame
  a <- as.data.frame(ab[[1]])
  b <- as.data.frame(ab[[2]])

  #create name
  a$sequence <- "a"
  b$sequence <- "b"

  #create row_id
  a$a <- seq(
    from = 1,
    to = nrow(a)
  )

  b$b <- seq(
    from = 1,
    to = nrow(b)
  )

  #reverse path
  path <- path[order(path$cost),]

  #merge a with path
  a.path <- merge(
    x = a,
    y = path
  )

  colnames(a.path)[1] <- "row_id"
  colnames(a.path)[colnames(a.path) == "b"] <- "other_row_id"

  #merge b with path
  b.path <- merge(
    x = b,
    y = path
  )

  colnames(b.path)[1] <- "row_id"
  colnames(b.path)[colnames(b.path) == "a"] <- "other_row_id"

  #join a and b
  ab <- rbind(a.path, b.path)

  #merge sequences (experimental)
  ab <- ab |>
    dplyr::group_by(
      row_id, sequence
    ) |>
    dplyr::filter(
      dist == min(dist)
    ) |>
    dplyr::mutate(
      sum = row_id + other_row_id
    ) |>
    dplyr::arrange(sum) |>
    dplyr::group_by(sum) |>
    dplyr::arrange(other_row_id)

  plot(a$betula, type = "l")
  plot(b$betula, type = "l")
  plot(ab$betula, type = "l")

  #subset data columns
  ab <- ab[, intersect(colnames(sequenceA), colnames(sequenceB))]

  ab.autosum <- auto_distance_cpp(
    m = as.matrix(ab),
    distance = "euclidean"
    )

  #using a loop to compare with ab
  ###################################
  ###################################
  ###################################
  a <- sequenceA |>
    na.omit() |>
    as.matrix()
  b <- sequenceB |>
    na.omit() |>
    as.matrix()

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

  #cost path
  path <- cost_path_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )

  #reverse path
  path <- path[order(path$cost),]

  path <- path |>
    dplyr::group_by(a) |>
    dplyr::mutate(
      a = dplyr::case_when(
        dist == min(dist) ~ a,
        TRUE ~ NA
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::group_by(b) |>
    dplyr::mutate(
      b = dplyr::case_when(
        dist == min(dist) ~ b,
        TRUE ~ NA
      )
    ) |>
    dplyr::ungroup() |>
    as.data.frame()

  ab[[1]] <- as.data.frame(ab[[1]])
  ab[[2]] <- as.data.frame(ab[[2]])
  ab[[1]]$sequence_name <- "a"
  ab[[2]]$sequence_name <- "b"
  ab[[1]]$sequence_row <- 1:nrow(ab[[1]])
  ab[[2]]$sequence_row <- 1:nrow(ab[[2]])

  #output data frame
  ab.combined <- a[0, ]

  #iterating over path
  for(i in seq_len(nrow(path))){

    a.na <- is.na(path$a[i])
    b.na <- is.na(path$b[i])

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
      )
    }

    ab.combined <- rbind(
      ab.combined,
      new.row
    )

  } #end of combination loop

  ab.combined

}
