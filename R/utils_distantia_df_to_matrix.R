#' Data Frame to Matrix
#'
#' @description
#' Internal function to convert a distantia data frame into a matrix.
#'
#' @param df (required, data frame) data frame typically resulting from [distantia()], but others are accepted as long as the columns `x`, `y`, and `value` are available. Default: NULL
#' @param x (required, character string) Name of the column with the names of the matrix columns. Default: "x"
#' @param y (required, character string) Name of the column with the names of the matrix rows. Default: "y"
#' @param value (required, character string) Name of the column with values.
#'
#' @return dist matrix
#' @export
#' @autoglobal
#' @examples
#' tsl <- tsl_simulate(
#'   n = 3,
#'   time_range = c(
#'     "2010-01-01 12:00:25",
#'     "2024-12-31 11:15:45"
#'   )
#' )
#'
#' df <- distantia(
#'   tsl = tsl
#' )
#'
#' m <- utils_distantia_df_to_matrix(
#'   df = df
#' )
#'
#' m
#' @family internal
utils_distantia_df_to_matrix <- function(
    df = NULL,
    x = "x",
    y = "y",
    value = "psi"
){

  #subset df
  df <- df_ <- df[, c(x, y, value)]

  #add mirrored pairs
  df_$x <- df$y
  df_$y <- df$x

  #merge everything
  df <- rbind(df, df_)

  #rows and col names
  xy_names <- unique(c(df[[x]], df[[y]]))

  #empty square matrix
  m <- matrix(
    data = NA,
    nrow = length(xy_names),
    ncol = length(xy_names)
  )

  #named vector to map row/column names to indices
  index_map <- stats::setNames(
    object = seq_along(xy_names),
    nm = xy_names
  )

  #vectorized indexing to fill in the matrix
  m[
    cbind(
      index_map[df[[y]]],
      index_map[df[[x]]]
    )
  ] <- df[[value]]

  #dim names
  rownames(m) <- xy_names
  colnames(m) <- xy_names

  #to dist
  m <- m |>
    stats::as.dist() |>
    as.matrix()

  m

}
