#' Default Continuous Color Palette
#'
#' @description
#' Uses the function [grDevices::hcl.colors()] to generate a continuous color palette.
#'
#'
#' @param n (required, integer) number of colors to generate. Default = NULL
#' @param palette (required, character string) Argument `palette` of [grDevices::hcl.colors()]. Default: "Zissou 1"
#'
#' @return color vector
#' @export
#' @autoglobal
#' @examples
#'
#' utils_color_continuous_default(n = 20)
#'
#' @family internal_plotting
utils_color_continuous_default <- function(
    n = 10,
    palette = "Zissou 1"
){

  grDevices::hcl.colors(
    n = n,
    palette = palette
  )

}
