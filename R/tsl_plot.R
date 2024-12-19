#' Plot Time Series List
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param columns (optional, integer) Number of columns of the multipanel plot. Default: 1
#' @param xlim (optional, numeric vector) Numeric vector with the limits of the x axis. Applies to all sequences. Default: NULL
#' @param ylim (optional, numeric vector or character string) Numeric vector of length two with the limits of the vertical axis or a keyword. Accepted keywords are:
#' \itemize{
#'   \item "absolute" (default): all time series are plotted using the overall data range. When this option is used, horizontal lines indicating the overall mean, minimum, and maximum are shown as reference.
#'   \item "relative": each time series is plotted using its own range. Equivalent result can be achieved using `ylim = NULL`.
#' }
#' @param line_color (optional, character vector) vector of colors for the distance or cost matrix. If NULL, uses an appropriate palette generated with [grDevices::palette.colors()]. Default: NULL
#' @param line_width (optional, numeric vector) Width of the time series plot. Default: 1
#' @param text_cex (optional, numeric) Multiplicator of the text size. Default: 1
#' @param guide (optional, logical) If TRUE, plots a legend. Default: TRUE
#' @param guide_columns (optional, integer) Columns of the line guide. Default: 1.
#' @param guide_cex (optional, numeric) Size of the guide's text and separation between the guide's rows. Default: 0.7.
#'
#' @return plot
#' @export
#' @autoglobal
#' @examples
#' #simulate zoo time series
#' tsl <- tsl_simulate(
#'   cols = 3
#'   )
#'
#' if(interactive()){
#'
#'   #default plot
#'   tsl_plot(
#'     tsl = tsl
#'     )
#'
#'   #relative vertical limits
#'   tsl_plot(
#'     tsl = tsl,
#'     ylim = "relative"
#'   )
#'
#'   #changing layout
#'   tsl_plot(
#'     tsl = tsl,
#'     columns = 2,
#'     guide_columns = 2
#'   )
#'
#'   #no legend
#'   tsl_plot(
#'     tsl = tsl,
#'     guide = FALSE
#'   )
#'
#'   #changing color
#'   tsl_plot(
#'     tsl = tsl,
#'     line_color = c("red", "green", "blue"))
#'
#' }
#' @family tsl_visualization
tsl_plot <- function(
    tsl = NULL,
    columns = 1,
    xlim = NULL,
    ylim = "absolute",
    line_color = NULL,
    line_width = 1,
    text_cex = 1,
    guide = TRUE,
    guide_columns = 1,
    guide_cex = 0.8
){

  utils_check_args_tsl(
    tsl = tsl,
    min_length = 1
  )

  #set NaN and Inf to NA
  #avoids issues when computing axes limits
  tsl <- tsl_Inf_to_NA(
    tsl = tsl
  )

  tsl <- tsl_NaN_to_NA(
    tsl = tsl
  )

  axis_title_distance <- 2.5

  # preserve user's config
  old.par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old.par))

  #manage ylim
  if(all(ylim == "absolute") == TRUE){

    tsl_vars <- tsl |>
      tsl_colnames_get() |>
      unlist() |>
      unique()

    df <- tsl_to_df(tsl = tsl)
    m <- as.matrix(df[, tsl_vars])

    ylim_min <- min(x = m, na.rm = TRUE)
    ylim_max <- max(x = m, na.rm = TRUE)
    ylim_mean <- mean(x = m, na.rm = TRUE)

    ylim <- c(ylim_min, ylim_max)

    rm(df, m)

  }

  if(all(ylim == "relative") == TRUE){
    ylim <- NULL
  }

  #generate colors
  line_color <- utils_line_color(
    x = tsl,
    line_color = line_color
  )

  #define new par
  if(guide == TRUE){
    n_panels <- length(tsl) + 1
  } else {
    n_panels <- length(tsl)
  }

  rows <- ceiling(n_panels/columns)

  graphics::par(
    mfrow = c(rows, columns),
    oma = c(2, 1, 1, 1),
    mar = c(1, 3.5, 1, 0.5)
  )

  #plot panels
  for(i in seq_len(n_panels)){

    if(i <= length(tsl)){

      zoo_plot(
        x = tsl[[i]],
        line_color = line_color,
        line_width = line_width,
        xlim = xlim,
        ylim = ylim,
        title = "",
        xlab = NULL,
        ylab = "",
        text_cex = text_cex,
        guide = FALSE,
        guide_cex = guide_cex,
        subpanel = FALSE
      )

      if(exists("ylim_min")){
        graphics::abline(
          h = ylim_min,
          col = "gray50",
          lty = 3
          )
      }

      if(exists("ylim_max")){
        graphics::abline(
          h = ylim_max,
          col = "gray50",
          lty = 3
          )
      }

      if(exists("ylim_mean")){
        graphics::abline(
          h = ylim_mean,
          col = "gray50",
          lty = 3
          )
      }

      graphics::title(
        ylab = attributes(tsl[[i]])$name,
        line = axis_title_distance,
        cex.lab = text_cex
      )

    } else {

      if(guide == TRUE){

        utils_line_guide(
          x = tsl,
          position = "center",
          line_color = line_color,
          line_width = line_width,
          text_cex = guide_cex,
          guide_columns = guide_columns,
          subpanel = TRUE
        )

      }

    }

  }

  invisible()

}
