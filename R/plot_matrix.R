plot_matrix <- function(
    m = NULL,
    matrix_color = NULL,
    title = NULL,
    xlab = NULL,
    ylab = NULL,
    path = NULL,
    axes = FALSE,
    path_width = 1,
    path_color = "black",
    cex = 1
){

  axis_title_cex <- 0.9 * cex
  axis_title_distance <- 2.2
  main_title_distance <- 1.2
  main_title_cex <- 1 * cex
  axis_labels_cex <- 0.8 * cex

  if(inherits(x = m, what = "matrix") == FALSE){
    stop("Argument 'm' must be a distance or cost matrix resulting from distantia::distance_matrix() or distantia::cost_matrix().")
  }

  #handling cost path
  if("cost_path" %in% attributes(path)$type){

    #rename path columns
    colnames(path)[colnames(path) == "a"] <- attributes(path)$a_name
    colnames(path)[colnames(path) == "b"] <- attributes(path)$b_name

  } else {

    if(!is.null(path)){

      warning("Argument 'path' was not generated with distantia::cost_path() and will be ignored.")
      path <- NULL

    }

  }

  if(is.null(matrix_color)){
    matrix_color = grDevices::hcl.colors(
      n = 100,
      palette = "Zissou 1"
    )
  }

  #main plotting parameters
  y <- seq_len(nrow(m))
  x <- seq_len(ncol(m))
  z <- t(m)

  #handling dimension names
  if(is.null(ylab)){
    ylab <- attributes(m)$a_name
    ylab <- ifelse(
      test = is.null(ylab),
      yes = "a",
      no = ylab
    )
  }


  if(is.null(xlab)){
    xlab <- attributes(m)$b_name
    xlab <- ifelse(
      test = is.null(xlab),
      yes = "a",
      no = xlab
    )
  }


  #handling axis labels
  y_labels <- dimnames(m)[[1]] |>
    as.numeric() |>
    pretty()

  x_labels <- dimnames(m)[[2]] |>
    as.numeric() |>
    pretty()

  #handling breaks
  breaks <- auto_breaks(
    m = m,
    n = length(matrix_color)
  )

  #plot matrix
  graphics::image(
    x = x,
    y = y,
    z = z,
    breaks = breaks,
    col = matrix_color,
    xlab = "",
    ylab = "",
    axes = FALSE,
    useRaster = FALSE,
    add = FALSE
  )

  if(axes == TRUE){

    graphics::title(
      xlab = xlab,
      line = axis_title_distance,
      cex.lab = axis_title_cex
    )

    graphics::title(
      ylab = ylab,
      line = axis_title_distance,
      cex.lab = axis_title_cex
    )

    axis(
      1,
      at = x_labels,
      cex.axis = axis_labels_cex
    )

    axis(
      2,
      at = y_labels,
      cex.axis = axis_labels_cex
    )

  }

  graphics::title(
    main = ifelse(
      test = is.null(main_title),
      yes = paste0(ylab, " vs. ", xlab),
      no = main_title
    ),
    cex.main = main_title_cex,
    line = main_title_distance
  )



  if(!is.null(path)){
    graphics::lines(
      x = path[[xlab]],
      y = path[[ylab]],
      lwd = path_width,
      col = path_color
    )
  }


}
