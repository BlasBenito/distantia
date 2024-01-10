slotting <- function(
    a = NULL,
    b = NULL,
    distance = "euclidean"
){

  a <- sequenceA |>
  na.omit() |>
    as.matrix()
  b <- sequenceB |>
    na.omit() |>
    as.matrix()

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

  #reverse path
  path <- path[order(path$cost),]

  #add NA at the end
  path.NA <- path[1, ]
  path.NA[1, ] <- rep(Inf, 4)
  path <- rbind(
    path, path.NA
  )

  #to data frame
  a <- as.data.frame(ab[[1]])
  b <- as.data.frame(ab[[2]])

  a$sequence <- "a"
  b$sequence <- "b"
  a$row <- 1:nrow(a)
  b$row <- 1:nrow(b)

  #slotting
  ab.df <- data.frame()
  a.last.used <- 0
  b.last.used <- 0

  #iterating over path
  for(i in seq_len(nrow(path) - 1)){

    #add row from a
    if(path$a[i] != path$a[i + 1]){

      a.last.used <- path$a[i]

      ab.df <- rbind(
        ab.df,
        a[a.last.used, ]
      )

    }

    #add row from b
    if(path$b[i] != path$b[i + 1]){

      b.last.used <- path$b[i]

      ab.df <- rbind(
        ab.df,
        b[b.last.used, ]
      )

    }

  }



}
