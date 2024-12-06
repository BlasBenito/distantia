#' Default Discrete Color Palettes
#'
#' @description
#' Uses the function [grDevices::palette.colors()] to generate discrete color palettes using the following rules:
#' \itemize{
#'   \item `n <= 9`: "Okabe-Ito".
#'   \item `n == 10`: "Tableau 10"
#'   \item `n > 10 && n <= 12`: "Paired"
#'   \item `n > 12 && n <= 26`: "Alphabet"
#'   \item `n > 26 && n <= 36`: "Polychrome 36"
#' }
#'
#'
#' @param n (required, integer) number of colors (up to 36) to generate. Default: NULL
#'
#' @return color vector
#' @export
#' @autoglobal
#' @examples
#'
#' utils_color_discrete_default(n = 9)
#' @family internal_plotting
utils_color_discrete_default <- function(
    n = NULL
    ){

  if(n > 36){
    warning("Discrete color palettes with more than 36 values are not supported.")
    n <- 36
  }

  if(n <= 9){
    pal <- "Okabe-Ito"
  }
  if(n == 10){
    pal <- "Tableau 10"
  }
  if(n > 10 && n <= 12){
    pal <- "Paired"
  }
  if(n > 12 && n <= 26){
    pal <- "Alphabet"
  }
  if(n > 26 && n <= 36){
    pal <- "Polychrome 36"
  }
  if(n > 36){
    return(
      utils_color_continuous_default(n = n)
    )
  }

  grDevices::palette.colors(
    n = n,
    palette = pal
  )

}
