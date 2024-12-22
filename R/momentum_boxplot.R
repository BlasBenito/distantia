#' Momentum Boxplot
#'
#' @description
#' Boxplot of a data frame returned by [momentum()] summarizing the contribution to similarity (negative) and/or dissimilarity (positive) of individual variables across all time series.
#'
#' @param df (required, data frame) Output of [momentum()]. Default: NULL
#' @inheritParams distantia_boxplot
#'
#' @return boxplot
#' @export
#' @autoglobal
#' @examples
#' tsl <- tsl_initialize(
#'   x = distantia::albatross,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global
#'   )
#'
#' df <- momentum(
#'   tsl = tsl,
#'   lock_step = TRUE
#'   )
#'
#' momentum_boxplot(
#'   df = df
#'   )
#' @family momentum_support
momentum_boxplot <- function(
    df = NULL,
    fill_color = NULL,
    f = median,
    text_cex = 1
){

  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par))

  if(attributes(df)$type != "momentum_df"){
    stop(
      "distantia::momentum_boxplot(): argument 'df' must be the output of distantia::momentum()",
      call. = FALSE
    )
  }

  #aggregate df if needed
  df <- momentum_aggregate(
    df = df,
    f = f
  )

  #boxplot
  utils_boxplot_common(
    variable = df$variable,
    value = df$importance,
    fill_color = fill_color,
    f = f,
    main = "Contribution to \n Similarity (<0) / Dissimilarity (>0)",
    xlab = "Momentum (psi %)",
    ylab = "",
    text_cex = text_cex
  )

  #zero line
  graphics::abline(
    v = 0,
    col = "gray50",
    lwd = 2
  )

}
