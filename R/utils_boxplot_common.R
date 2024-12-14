#' Common Boxplot Component of `distantia_boxplot()` and `momentum_boxplot()`
#'
#' @param variable (required, character vector) vector with variable or time series names. Default: NULL
#' @param value (required, numeric vector) vector of numeric values to compute the boxplot for. Must have the same length as `variable`. Default: NULL
#' @inheritParams distantia_boxplot
#' @param main (optional, string) boxplot title. Default: NULL
#' @param xlab (optional, string) x axis label. Default: NULL
#' @param ylab (optional, string) y axis label. Default: NULL
#'
#' @return boxplot
#' @export
#' @autoglobal
#' @examples
#' utils_boxplot_common(
#'   variable = rep(x = c("a", "b"), times = 50),
#'   value = stats::runif(100)
#' )
#' @family internal
utils_boxplot_common <- function(
    variable = NULL,
    value = NULL,
    fill_color = NULL,
    f = median,
    main = NULL,
    xlab = NULL,
    ylab = NULL,
    text_cex = 1
    ){

  if(is.null(variable) || is.null(value)){
    stop("distantia::utils_boxplot_common(): arguments 'variable' and 'value' cannot be NULL.", call. = FALSE)
  }

  if(length(variable) != length(value)){
    stop("distantia::utils_boxplot_common(): arguments 'variable' and 'value' must have the same length.", call. = FALSE)
  }

  if(!is.numeric(value)){
    stop("distantia::utils_boxplot_common(): arguments 'value' must be numeric.", call. = FALSE)
  }

  if(!is.character(variable)){
    variable <- as.character(variable)
  }

  if(is.null(fill_color)){

    fill_color <- utils_color_continuous_default(
      n = length(unique(variable))
    )

  }

  df_plot <- data.frame(
    variable = variable,
    value = value
  )

  #order by function
  variable_means <- tapply(
    X = df_plot$value,
    INDEX = df_plot$variable,
    FUN = f
  )

  variable_order <- sort(
    variable_means,
    decreasing = FALSE
  ) |>
    names()

  df_plot$variable <- factor(
    x = df_plot$variable,
    levels = variable_order
  )

  #notch or not
  notch <- {
    if(min(table(df_plot$variable)) > 30){
      TRUE
    } else {
      FALSE
    }
  }

  #adjusts margin to longer variable name
  left_margin <- (max(nchar(unique(variable))) * text_cex) / 3

  graphics::par(
    mar = c(5, max(left_margin, 5), 4, 2),
    las = 1,
    cex.main = 0.7 * text_cex,
    cex.lab = 0.7 * text_cex,
    cex.axis = 0.6 * text_cex
  )

  graphics::boxplot(
    formula = value ~ variable,
    data = df_plot,
    xlab = xlab,
    ylab = ylab,
    horizontal = TRUE,
    notch = notch,
    col = fill_color,
    main = main
  )



}
