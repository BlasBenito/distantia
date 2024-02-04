#' Handles Line Colors for Sequence Plots
#'
#' @description
#' This is an internal function, but can be used to better understand how line colors are handled within other plotting functions.
#'
#'
#' @param x (required, sequence) a single sequence or set of sequences generated via [prepare_sequences()]. Default: NULL
#' @param color (optional, character vector) vector of colors for the sequence columns. If NULL, uses the palette "Zissou 1" provided by the function [grDevices::hcl.colors()]. Default: NULL
#'
#' @return Named vector of colors
#' @export
auto_line_color <- function(
    x = NULL,
    color = NULL
){

  #check x
  x <- check_args_x(x = x)

  # get colnames for any length of x
  if(!is.matrix(x)){

    x_colnames <- lapply(
      X = x,
      FUN = colnames
    ) |>
      unlist() |>
      unique() |>
      sort()

  } else {

    #names of columns to plot
    x_colnames <- colnames(x)

  }

  #generate default colors
  if(is.null(color)){

    color <- grDevices::hcl.colors(
      n = length(x_colnames),
      palette = "Zissou 1"
    )

    names(color) <- x_colnames

  }


  #if more colors than required are provided
  if(length(color) > length(x_colnames)){

    #if no names, subset by length
    if(is.null(names(color))){

      color <- color[
        seq(
          from = 1,
          to = length(color),
          length.out = length(x_colnames))
      ]

      names(color) <- x_colnames

      #if names, subset by name
    } else {

      color <- color[names(color) %in% x_colnames]

    }

  }

  #if fewer colors than required are provided
  if(length(color) < length(x_colnames)){

    stop(
      "There are fewer colors (",
      length(color),
      ") than unique columns (",
      length(x_colnames),
      "). Argument 'color' must be a vector with ",
      length(x_colnames),
      " colors."
    )

  }

 color

}
