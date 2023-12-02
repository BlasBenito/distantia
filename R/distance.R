#' Distance Between Two Numeric or Binary Vectors
#'
#' @description Computes the distance between two numeric or binary vectors.
#' @param x (required, numeric vector).
#' @param y (required, numeric vector) of same length as `x`.
#' @param method (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `methods`. Default: "euclidean".
#' @return A distance value.
#' @author Blas Benito <blasbenito@gmail.com>
#' @examples
#'
#' distance(
#'   x = runif(100),
#'   y = runif(100),
#'   method = "euclidean"
#' )
#'
#' @autoglobal
#' @export
distance <- function(
    x = NULL,
    y = NULL,
    method = "euclidean"
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

  #checking for NA
  if(sum(is.na(x)) > 0){
    stop("Argument 'x' has NA values. Please remove or imputate them before the distance computation.")
  }
  if(sum(is.na(y)) > 0){
    stop("Argument 'y' has NA values. Please remove or imputate them before the distance computation.")
  }

  method <- match.arg(
    arg = method,
    choices = c(
      methods$name,
      methods$abbreviation
    ),
    several.ok = FALSE
  )

  #handling NA
  df <- data.frame(
    x = x,
    y = y
  ) |>
    stats::na.omit()

  #methods that don't accept two zeros in same position
  if(method %in% c(
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
    methods[
      methods$name %in% method |
        methods$abbreviation %in% method,
      "function_name"
    ],
    "(df$x, df$y)"
  )

  eval(parse(text = expression))

}

