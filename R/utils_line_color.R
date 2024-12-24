#' Handles Line Colors for Sequence Plots
#'
#' @description
#' This is an internal function, but can be used to better understand how line colors are handled within other plotting functions.
#'
#'
#' @param x (required, sequence) zoo object or time series list. Default: NULL
#' @param line_color (optional, character vector) vector of colors for the time series columns. Selected palette depends on the number of columns to plot. Default: NULL
#'
#' @return color vector
#' @export
#' @family internal_plotting
utils_line_color <- function(
    x = NULL,
    line_color = NULL
){

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
  if(is.null(line_color)){

    line_color <- color_discrete(
      n = length(x_colnames)
    )

  }


  #if more colors than required are provided
  if(length(line_color) > length(x_colnames)){

    #if no names, subset by length
    if(is.null(names(line_color))){

      line_color <- line_color[
        seq(
          from = 1,
          to = length(line_color),
          length.out = length(x_colnames))
      ]

      #if names, subset by name
    } else {

      line_color <- line_color[names(line_color) %in% x_colnames]

    }

  }

  #if fewer colors than required are provided
  if(length(line_color) < length(x_colnames)){

    stop(
      "distantia::utils_line_color(): There are fewer colors (",
      length(line_color),
      ") than unique columns (",
      length(x_colnames),
      "). Argument 'line_color' must be a vector with ",
      length(x_colnames),
      " colors.",
      call. = FALSE
    )

  }

  names(line_color) <- x_colnames

  line_color

}
