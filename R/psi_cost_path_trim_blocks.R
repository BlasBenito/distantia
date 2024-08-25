#' Trims Blocks from a Least Cost Path
#'
#' @description Removes blocks (straight segments of the path that appear in highly dissimilar regions of the sequences) from least-cost paths. Blocks inflate psi values when two sequences are similar but have very different numbers of rows.
#'
#' @param path (required, data frame) dataframe produced by [psi_cost_path()]. Default: NULL
#' @return data frame
#'
#' @examples
#' #TODO: complete example
#'@export
#'@autoglobal
#' @family psi_demo
psi_cost_path_trim_blocks <- function(path = NULL){

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
