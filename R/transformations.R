#' Transformation to Proportions
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_proportion <- function(x){
  sweep(
    x = x,
    MARGIN = 1,
    STATS = rowSums(x),
    FUN = "/"
    )
}

#' Transformation to Percentage
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_percentage <- function(x){
  f_proportion(x)*100
}

#' Hellinger Transformation
#'
#' @param x Data frame or matrix.
#'
#' @return Data frame or matrix
#' @export
#' @autoglobal
f_hellinger <- function(x){
  #TODO fails when full rows of zeros happen

  x <- prepare_na(
    x = x,
    pseudo_zero = 0.0001,
    na_action = "to_zero"
  )

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
f_scale <- function(x){
  as.data.frame(
    scale(
      x = x,
      center = TRUE,
      scale = TRUE
    )
  )
}
