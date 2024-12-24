#' Default Continuous Color Palette
#'
#' @description
#' Uses the function [grDevices::hcl.colors()] to generate a continuous color palette.
#'
#'
#' @param n (required, integer) number of colors to generate. Default = NULL
#' @param palette (required, character string) Argument `palette` of [grDevices::hcl.colors()]. Default: "Zissou 1"
#' @param rev (optional, logical) If TRUE, the color palette is reversed. Default: FALSE
#' @return color vector
#' @export
#' @autoglobal
#' @examples
#'
#' color_continuous(n = 20)
#'
#' @family internal_plotting
color_continuous <- function(
    n = 5,
    palette = "Zissou 1",
    rev = FALSE
){

  grDevices::hcl.colors(
    n = n,
    palette = palette,
    rev = rev
  )

}
