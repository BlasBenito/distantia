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

  #create new data frame
  df <- data.frame()

  a <- merge(
    x = a,
    y = path
  )

  colnames(a)[1] <- "row_id"
  colnames(a)[colnames(a) == "b"] <- "other_row_id"

  b <- merge(
    x = b,
    y = path
  )

  colnames(b)[1] <- "row_id"
  colnames(b)[colnames(b) == "a"] <- "other_row_id"

  ab <- rbind(a, b)

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
    dplyr::arrange(sum)

  #combine sequences starting with a first

  #autosum of ab

  #combine sequences tarting with b first

  #autosum of ba

  #select sequence with smaller auto sum

}
