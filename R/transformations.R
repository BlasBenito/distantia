#' Transformation to Proportions
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_proportion <- function(x, ...){

  y <- sweep(
    x = x,
    MARGIN = 1,
    STATS = rowSums(x),
    FUN = "/"
    )

  y
}

#' Transformation to Percentage
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_percentage <- function(x, ...){
  f_proportion(x)*100
}

#' Hellinger Transformation
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_hellinger <- function(x, ...){

  y <- sqrt(
    sweep(
      x = x,
      MARGIN = 1,
      STATS = rowSums(x),
      FUN = "/"
      )
    )

  y

}

#' Scaling and centering
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_scale <- function(x, ...){

  scale(
    x = x,
    center = TRUE,
    scale = TRUE
  )

}
