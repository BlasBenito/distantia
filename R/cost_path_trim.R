#' Trims Blocks from a Least Cost Path
#'
#' @description Removes blocks (straight segments of the path that appear in highly dissimilar regions of the sequences) from least-cost paths. Blocks inflate psi values when two sequences are similar but have very different numbers of rows.
#'
#' @param path (required, data frame) dataframe produced by [cost_path()]. Default: NULL
#' @return A data frame with a least-cost path with no blocks.
#'
#' @examples
#'
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' dm <- distance_matrix(
#'   a = a,
#'   b = b
#'   )
#'
#' cm <- cost_matrix(
#'   dist_matrix = dm
#'   )
#'
#' path <- cost_path(
#'   dist_matrix = dm,
#'   cost_matrix = cm
#' )
#'
#' nrow(path)
#'
#' if(interactive()){
#'   plotMatrix(cm, path)
#' }
#'
#' path <- cost_path_trim(path = path)
#'
#' nrow(path)
#'
#' if(interactive()){
#'   plotMatrix(cm, path)
#' }
#'
#'@export
#'@autoglobal
cost_path_trim <- function(path = NULL){

  if(is.null(path)){
    stop("Argument 'path' must not be NULL.")
  }

  if(!is.data.frame(path)){
    stop("Argument 'path' must be a data frame.")
  }

  if(all(c("a", "b", "dist", "cost") %in% colnames(path)) == FALSE){
    stop("Argument 'path' must have the columns 'a', 'b', 'dist', and 'cost'.")
  }

  #group by A and create the group size
  path$group_size_a <- stats::ave(
    x = path$a,
    path$a,
    FUN = function(x) length(x)
    )

  #keep groups with n < 3
  #from groups with n >= 3, keep the extremes
  path$keep_a <- with(
    data = path,
    expr = ifelse(
      test = group_size_a %in% c(1, 2),
      yes = TRUE,
      no = ifelse(
        test = group_size_a > 2 &
          cost == stats::ave(x = cost, path$a, FUN = max) |
          cost == stats::ave(x = cost, path$a, FUN = min),
        yes = TRUE,
        no = FALSE
        )
      )
    )

  #keep cases with keep == TRUE
  path <- path[path$keep_a, ]

  # Step 2: Group by b and create 'group_size' and 'keep' columns based on conditions
  path$group_size_b <- stats::ave(
    x = path$b,
    path$b,
    FUN = function(x) length(x)
    )

  path$keep_b <- with(
    data = path,
    expr = ifelse(
      test = group_size_b %in% c(1, 2),
      yes = TRUE,
      no = ifelse(
        test = group_size_b > 2 &
          cost == stats::ave(x = cost, path$b, FUN = max) |
          cost == stats::ave(x = cost, path$b, FUN = min),
        yes = TRUE,
        no = FALSE
        )
      )
    )

  #keep selected rows in b
  path <- path[path$keep_b, ]

  #remove extra columns
  path <- path[, !(names(path) %in% c("group_size_a", "keep_a", "group_size_b", "keep_b"))]

  path

}
