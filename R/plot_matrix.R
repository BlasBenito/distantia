plot_matrix <- function(
    m,
    col = NULL
){

  old.par <- par(no.readonly = TRUE)

  #handling colors
  if(is.null(col)){
    palette <- grDevices::colorRampPalette(
      colors = c("white", "darkgreen")
      )
    col <- palette(100)
  }

  #handling dimension names
  a_name <- attributes(m)$a_name
  a_name <- ifelse(
    test = is.null(a_name),
    yes = "a",
    no = a_name
  )

  b_name <- attributes(m)$b_name
  b_name <- ifelse(
    test = is.null(b_name),
    yes = "a",
    no = b_name
  )

  #handling axis labels
  y_labels <- dimnames(m)[[1]] |>
    as.numeric() |>
    pretty()

  x_labels <- dimnames(m)[[2]] |>
    as.numeric() |>
    pretty()

  #https://raw.githubusercontent.com/dnychka/fieldsRPackage/main/fields/R/imagePlot.R
  #https://raw.githubusercontent.com/dnychka/fieldsRPackage/main/fields/R/barPlot.R
  fields::imagePlot(
    y = 1:nrow(m),
    x = 1:ncol(m),
    z = t(m),
    ylab = a_name,
    xlab = b_name,
    main = paste0(a_name, " vs. ", b_name),
    col = col
  )

  graphics::image(
    y = 1:nrow(m),
    x = 1:ncol(m),
    z = t(m),
    col = col,
    xlab = b_name,
    ylab = a_name,
    axes = FALSE,
    main = paste0(a_name, " vs. ", b_name),
    useRaster = FALSE
    )

  # Add custom axis labels
  axis(1, at = x_labels)
  axis(2, at = y_labels)

}
