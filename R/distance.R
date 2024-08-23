#' Distance Between Numeric Vectors
#'
#' @description Computes the distance between two numeric or binary vectors.
#' @param x (required, numeric vector).
#' @param y (required, numeric vector) of same length as `x`.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @return A distance value.
#' @examples
#'
#' distance(
#'   x = runif(100),
#'   y = runif(100),
#'   distance = "euclidean"
#' )
#'
#' @autoglobal
#' @export
#' @family dissimilarity_analysis
distance <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean"
    ){

  if(is.null(x)){
    stop("Argument 'x' must not be NULL.")
  }

  if(is.null(y)){
    stop("Argument 'y' must not be NULL.")
  }

  if(length(x) != length(y)){
    stop("Arguments 'x' and 'y' must be of the same length.")
  }

  #handling NA
  df <- data.frame(
    x = x,
    y = y
  ) |>
    stats::na.omit()

  #methods that don't accept two zeros in same position
  if(distance %in% c(
    "chi",
    "cos",
    "cosine"
  )
  ){

    pseudozero <- mean(x = c(df$x, df$y)) * 0.0001
    df[df == 0] <- pseudozero

  }

  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  #generate expression
  expression <- paste0(
    distances[
      distances$name %in% distance |
        distances$abbreviation %in% distance,
      "function_name"
    ],
    "(df$x, df$y)"
  )

  eval(parse(text = expression))

}

