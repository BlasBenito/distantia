#' Distance Between Two Numeric Vectors
#'
#' @description Computes the distance between two numeric vectors with a distance metric included in the data frame `distantia::distances`.
#' @param x (required, numeric vector).
#' @param y (required, numeric vector) of same length as `x`.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @return numeric value
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
#' @family distances
distance <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean"
    ){

  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  if(is.null(x)){
    stop("distantia::distance(): argument 'x' must not be NULL.", call. = FALSE)
  }

  if(is.null(y)){
    stop("distantia::distance(): argument 'y' must not be NULL.", call. = FALSE)
  }

  if(length(x) != length(y)){
    stop("distantia::distance(): arguments 'x' and 'y' must be of the same length.", call. = FALSE)
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

  #generate expression
  expression <- paste0(
    distances[
      distances$name %in% distance |
        distances$abbreviation %in% distance,
      "function_name"
    ],
    "(df$x, df$y)"
  )

  y <- eval(parse(text = expression))

  attr(x = y, which = "distance") <- distance

  y

}

