#' Handles Line Colors for Sequence Plots
#'
#' @description
#' This is an internal function, but can be used to better understand how line colors are handled within other plotting functions.
#'
#'
#' @param x (required, sequence) a zoo time series or a time series list. Default: NULL
#' @param color (optional, character vector) vector of colors for the time series columns. Selected palette depends on the number of columns to plot. Default: NULL
#'
#' @return Named vector of colors
#' @keywords internal
#' @export
utils_line_color <- function(
    x = NULL,
    color = NULL
){

  #check x
  x <- utils_check_zoo_args(x = x)

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

    color <- utils_color_discrete_default(
      n = length(x_colnames)
    )

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

  names(color) <- x_colnames

  color

}
