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
#' @inheritParams color_continuous
#'
#' @return color vector
#' @export
#' @autoglobal
#' @examples
#'
#' color_discrete(n = 9)
#' @family internal_plotting
color_discrete <- function(
    n = NULL,
    rev = FALSE
    ){

  if(n == 1){
    return("#C8443F")
  }
  if(n <= 9 && n > 1){
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
      color_continuous(
        n = n,
        rev = rev
        )
    )
  }

  out <- grDevices::palette.colors(
    n = n,
    palette = pal
  )

  if(rev){
    out <- rev(out)
  }

  out

}
