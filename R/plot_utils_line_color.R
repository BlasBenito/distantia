#' Handles Line Colors for Sequence Plots
#'
#' @description
#' This is an internal function, but can be used to better understand how line colors are handled within other plotting functions.
#'
#'
#' @param x (required, sequence) a single sequence or set of sequences generated via [ts_prepare()]. Default: NULL
#' @param color (optional, character vector) vector of colors for the sequence columns. Selected palette depends on the number of columns to plot. Default: NULL
#'
#' @return Named vector of colors
#' @noRd
#' @keywords internal
#' @export
plot_utils_line_color <- function(
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

    #select palette
    n <- length(x_colnames)
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

    color <- grDevices::palette.colors(
      n = length(x_colnames),
      palette = pal
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
