
library(distantia)
library(microbenchmark)

a <- sequenceA |>
  na.omit() |>
  as.matrix()

b <- sequenceB |>
  na.omit() |>
  as.matrix()

dist_matrix <- distance_matrix(a, b, method = "euclidean")

cost_matrix <- cost_matrix(dist_matrix = dist_matrix)

microbenchmark(
  cost_path_original(dist_matrix, cost_matrix),
  cost_path(dist_matrix, cost_matrix),
  cost_path_cpp(dist_matrix, cost_matrix)
)

#' Least Cost Path
#'
#' @param dist_matrix (required, numeric matrix) Distance matrix.
#' @param cost_matrix (required, numeric matrix) Cost matrix generated from the distance matrix.
#' @param diagonal (optional, logical) If TRUE, diagonals are used during the least-cost path search
#' @return A data frame with least-cost path coordiantes.
#' @export
#' @examples
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' d <- distance_matrix(a, b, method = "euclidean")
#'
#' m <- cost_matrix(dist_matrix = d)
#'
#' path <- cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#'   )
#'
#' @autoglobal
cost_path_original <- function(
    dist_matrix = NULL,
    cost_matrix = NULL,
    diagonal = FALSE
){

  if(any(dim(dist_matrix) != dim(cost_matrix))){
    stop("Arguments 'dist_matrix' and 'cost_matrix' must have the same dimensions.")
  }

  dimensions <- dim(dist_matrix)

  na_vector <- rep(NA, sum(dimensions))

  path <- data.frame(
    A = c(dimensions[1], na_vector),
    B = c(dimensions[2], na_vector),
    dist = c(dist_matrix[dimensions[1], dimensions[2]], na_vector),
    cost = c(cost_matrix[dimensions[1], dimensions[2]], na_vector)
  )

  #defining coordinates of the focal cell
  y <- path$A
  x <- path$B
  i <- 1

  #no diagonal
  if(diagonal == FALSE){

    #going through the matrix
    repeat{

      #cell neighbors
      n <- data.frame(
        y = c(y-1, y),
        x = c(x, x-1)
      )

      #removing neighbors with coordinates lower than 1 (out of bounds)
      n[n < 1] <- NA
      n <- stats::na.omit(n)
      if(nrow(n) == 0){break}

      #computing dist and cost of neighbors
      n.dist <- dist_matrix[n$y, n$x]
      n.cost <- cost_matrix[n$y, n$x]

      if(nrow(n) > 1){
        n$dist <- diag(n.dist)
        n$cost <- diag(n.cost)
      } else {
        n$dist <- n.dist
        n$cost <- n.cost
      }

      #getting the neighbor with a minimum cost_matrix
      n <- n[which.min(n$cost), ]

      #putting them together
      i <- i + 1
      path[i, ] <- n

      #new focal cell
      y <- n$y
      x <- n$x

    }#end of repeat

  }#end of diagonal == FALSE


  #no diagonal
  if(diagonal == TRUE){

    #going through the matrix
    repeat{

      #cell neighbors
      n <- data.frame(
        y = c(y-1, y-1, y),
        x = c(x, x-1, x-1)
      )

      #removing neighbors with coordinates lower than 1 (out of bounds)
      n[n < 1] <- NA
      n <- stats::na.omit(n)
      if(nrow(n) == 0){break}

      #computing dist and cost of neighbors
      n.dist <- dist_matrix[n$y, n$x]
      n.cost <- cost_matrix[n$y, n$x]

      if(nrow(n) > 1){
        n$dist <- diag(n.dist)
        n$cost <- diag(n.cost)
      } else {
        n$dist <- n.dist
        n$cost <- n.cost
      }

      #getting the neighbor with a minimum cost_matrix
      n <- n[which.min(n$cost), ]

      #putting them together
      i <- i + 1
      path[i, ] <- n

      #new focal cell
      y <- n$y
      x <- n$x

    }#end of repeat

  }#end of diagonal == FALSE


  path <- stats::na.omit(path)


}
