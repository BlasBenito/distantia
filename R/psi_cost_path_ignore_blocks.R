#' Trims Blocks from a Least Cost Path
#'
#' @description
#'
#' In orthogonal least cost paths (when diagonals are ignored), long straight segments (a.k.a "blocks") may appear in highly dissimilar sections of the time series. Blocks inflate psi dissimilarity scores, making pairs of time series seem more dissimilar than they actually are. This demonstration function identifies and removes blocks, resulting in fairer dissimilarity analyses.
#'
#' @param path (required, data frame) least cost path produced by [psi_cost_path()]. Default: NULL
#' @return data frame
#'
#' @examples
#' #distance metric
#' d <- "euclidean"
#'
#' #use diagonals in least cost computations
#' diagonal <- TRUE
#'
#' #simulate two irregular time series
#' x <- zoo_simulate(
#'   name = "x",
#'   rows = 100,
#'   seasons = 2,
#'   seed = 1
#' )
#'
#' y <- zoo_simulate(
#'   name = "y",
#'   rows = 80,
#'   seasons = 2,
#'   seed = 2
#' )
#'
#' if(interactive()){
#'   zoo_plot(x = x)
#'   zoo_plot(x = y)
#' }
#'
#' #distance matrix
#' dist_matrix <- psi_distance_matrix(
#'   x = x,
#'   y = y,
#'   distance = d
#' )
#'
#' #orthogonal least cost matrix
#' cost_matrix <- psi_cost_matrix(
#'   dist_matrix = dist_matrix,
#'   diagonal = FALSE
#' )
#'
#' #orthogonal least cost path
#' cost_path <- psi_cost_path(
#'   dist_matrix = dist_matrix,
#'   cost_matrix = cost_matrix,
#'   diagonal = FALSE
#' )
#'
#' #cost path details
#' nrow(cost_path)
#'
#' psi_cost_path_sum(
#'   path = cost_path
#' )
#'
#' #notice blocks as long straight lines
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = cost_matrix,
#'     path = cost_path
#'   )
#' }
#'
#' #removing blocks
#' cost_path_no_blocks <- psi_cost_path_ignore_blocks(
#'   path = cost_path
#' )
#'
#' #much smaller size
#' nrow(cost_path_no_blocks)
#'
#' #much smaller distance sum
#' psi_cost_path_sum(
#'   path = cost_path_no_blocks
#' )
#'
#' #but the path shape is preserved
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = cost_matrix,
#'     path = cost_path_no_blocks
#'   )
#' }
#'
#' #x and y to tsl
#' tsl <- list(
#'   x = x,
#'   y = y
#' )
#'
#' #psi score with blocks
#' distantia(
#'   tsl = tsl,
#'   diagonal = FALSE,
#'   ignore_blocks = FALSE
#' )$psi
#'
#' #psi score without blocks
#' distantia(
#'   tsl = tsl,
#'   diagonal = FALSE,
#'   ignore_blocks = TRUE
#' )$psi
#'@export
#'@autoglobal
#' @family psi_demo
psi_cost_path_ignore_blocks <- function(
    path = NULL
    ){

  path <- utils_check_path_args(
    path = path
  )

  #keep path attributes
  path.attributes <- attributes(path)[
    c("y_name", "x_name", "type", "distance")
    ]

  #group by y and create the group size
  path$group_size_y <- stats::ave(
    x = path$y,
    path$y,
    FUN = function(x) length(x)
    )

  #keep groups with n < 3
  #from groups with n >= 3, keep the extremes
  path$keep_y <- with(
    data = path,
    expr = ifelse(
      test = group_size_y %in% c(1, 2),
      yes = TRUE,
      no = ifelse(
        test = group_size_y > 2 &
          cost == stats::ave(x = cost, path$y, FUN = max) |
          cost == stats::ave(x = cost, path$y, FUN = min),
        yes = TRUE,
        no = FALSE
        )
      )
    )

  #keep cases with keep == TRUE
  path <- path[path$keep_y, ]

  # Step 2: Group by b and create 'group_size' and 'keep' columns based on conditions
  path$group_size_x <- stats::ave(
    x = path$x,
    path$x,
    FUN = function(x) length(x)
    )

  path$keep_x <- with(
    data = path,
    expr = ifelse(
      test = group_size_x %in% c(1, 2),
      yes = TRUE,
      no = ifelse(
        test = group_size_x > 2 &
          cost == stats::ave(x = cost, path$x, FUN = max) |
          cost == stats::ave(x = cost, path$x, FUN = min),
        yes = TRUE,
        no = FALSE
        )
      )
    )

  #keep selected rows in b
  path <- path[path$keep_x, ]

  #remove extra columns
  path <- path[, !(names(path) %in% c("group_size_y", "keep_y", "group_size_x", "keep_x"))]

  #return attributes
  attr(x = path, which = "y_name") <- path.attributes$y_name
  attr(x = path, which = "x_name") <- path.attributes$x_name
  attr(x = path, which = "type") <- path.attributes$cost_path
  attr(x = path, which = "distance") <- path.attributes$distance

  path

}
