plot_sequences <- function(
    x = NULL,
    center = FALSE,
    scale = FALSE,
    color = NULL,
    width = 1,
    text_cex = 1,
    box = FALSE,
    guide = TRUE,
    guide_cex = 0.8,
    columns = 1
){

  axis_title_distance <- 2.2

  # Preserve user's config
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))

  #check x
  x <- check_args_x(x = x)

  #get column names
  x_colnames <- lapply(
    X = x,
    FUN = function(z){
      attributes(z)$dimnames[[2]]
    }
  ) |>
    unlist() |>
    unique()

  #generate colors
  color <- auto_line_color(
    x = x,
    color = color
  )

  #define new par
  rows <- ceiling((length(x) + 1)/columns)

  n <- rows * columns

  par(
    mfrow = c(rows, columns),
    mar = c(1, 4, 0.5, 0.5),
    oma = c(2, 0, 1, 1)
  )

  for(i in seq_len(length(x) + 1)){

    #plot first sequence
    if(i <= length(x)){

      plot_sequence(
        x = x[[i]],
        center = center,
        scale = scale,
        color = color,
        width = width,
        title = "",
        xlab = NULL,
        ylab = "",
        text_cex = text_cex,
        box = box,
        guide = subplot_guide,
        guide_position = "right",
        guide_cex = guide_cex,
        subpanel = TRUE
      )

      graphics::title(
        ylab = attributes(x[[i]])$sequence_name,
        line = axis_title_distance,
        cex.lab = text_cex
      )

    } else {

      plot_line_guide(
        x = x,
        position = "center",
        color = color,
        width = width,
        text_cex = guide_cex,
        box = FALSE,
        ncol = 2,
        subpanel = TRUE
      )

    }

  }

  invisible()

}
