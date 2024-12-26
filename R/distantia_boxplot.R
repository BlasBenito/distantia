#' Distantia Boxplot
#'
#' @description
#' Boxplot of a data frame returned by [distantia()] summarizing the stats of the psi scores of each time series against all others.
#'
#' @inheritParams distantia_aggregate
#' @param fill_color (optional, character vector) boxplot fill color. Default: NULL
#' @param f (optional, function) function used to aggregate the input data frame and arrange the boxes. One of `mean` or `median`. Default: `median`.
#' @param text_cex (optional, numeric) Multiplier of the text size. Default: 1
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
#' df <- distantia(
#'   tsl = tsl,
#'   lock_step = TRUE
#'   )
#'
#' distantia_boxplot(
#'   df = df,
#'   text_cex = 1.5
#'   )
#' @family distantia_support
distantia_boxplot <- function(
    df = NULL,
    fill_color = NULL,
    f = median,
    text_cex = 1
){

  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par))

  if(attributes(df)$type != "distantia_df"){
    stop(
      "distantia::distantia_boxplot(): argument 'df' must be the output of distantia::distantia()",
      call. = FALSE
    )
  }

  #aggregate df if needed
  df <- distantia_aggregate(
    df = df,
    f = f
  )

  #boxplot
  utils_boxplot_common(
    variable = c(df$x, df$y),
    value = c(df$psi, df$psi),
    fill_color = fill_color,
    f = f,
    main = "Dissimilarity Summary",
    xlab = "Psi",
    ylab = "",
    text_cex = text_cex
  )

}
