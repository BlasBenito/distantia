#' Boxplot of Distantia Data Frame
#'
#' @description
#' For data frames resulting from [distantia()] it plots the distribution of the Psi values of each time series against all others. Time series with higher values are the most dissimilar.
#'
#' For data frames resulting from [distantia_importance()] it plots the contribution to similarity/dissimilarity of each variable across all time-series. Variables with higher values contribute the most to the dissimilarity between time series.
#'
#' @param df (required, data frame) output of [distantia()] or [distantia_importance()]. Default: NULL
#' @param color (optional, character vector) boxplot fill color. Default: NULL
#' @param f (optional, function) function used to order the boxes. Can be one of `mean`, `median`, `min`, `max`, or `quantile`. Default: `mean`.
#' @param ... (optional) additional arguments to `f`. For example, if `f` is `quantile`, `probs = 0.75` can be used. Default: ...
#'
#' @return Boxplot and list with stats used to draw it
#' @export
#' @autoglobal
#' @examples
#' tsl <- tsl_simulate(
#'   n = 5,
#'   time_range = c(
#'     "2010-01-01",
#'     "2024-12-31"
#'   ),
#'   cols = 3
#' )
#'
#' #distantia boxplot
#' df <- distantia(
#'   tsl = tsl,
#'   distance = c("euclidean", "manhattan")
#' )
#'
#' distantia_boxplot(
#'   df = df,
#'   f = quantile,
#'   probs = 0.75
#' )
#'
#' #importance boxplot
#' df_importance <- distantia_importance(
#'   tsl = tsl,
#'   distance = c("manhattan", "euclidean")
#' )
#'
#' distantia_boxplot(
#'   df = df_importance,
#'   fun = median
#'   )
distantia_boxplot <- function(
    df = NULL,
    color = NULL,
    f = mean,
    ...
){

  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))

  df_type <- attributes(df)$type

  types <- c(
    "distantia_df",
    "distantia_importance_df"
  )

  if(!(df_type %in% types)){
    stop("Argument 'df' must be the output of distantia() or distantia_importance()")
  }

  df <- distantia_aggregate(
    df = df,
    f = mean
  )

  #prepare df for boxplot
  if(df_type == "distantia_df"){

    variable <- c(df$x, df$y)
    value <- c(df$psi, df$psi)
    xlab <- "Dissimilarity (Psi)"
    ylab <- ""
    main <- "Overall Dissimilarity"

  }

  if(df_type == "distantia_importance_df"){

      variable <- df$variable
      value <- df$importance
      xlab <- "Importance (Psi %)"
      ylab <- ""
      main <- "Variable Contribution to \n Similarity (<0) and Dissimilarity (>0)"

  }


  if(is.null(color)){

    color <- grDevices::hcl.colors(
      n = length(unique(variable)),
      palette = "Zissou 1"
    )

  }

  df_plot <- data.frame(
    variable = variable,
    value = value
  )

  #order by median
  variable_means <- tapply(
    X = df_plot$value,
    INDEX = df_plot$variable,
    FUN = f,
    ... = ...
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

  par(mar=c(5, 8, 4, 2))

  #notch or not
  notch <- tryCatch({
    graphics::boxplot(
      formula = value ~ variable,
      data = df_plot,
      xlab = xlab,
      ylab = ylab,
      horizontal = TRUE,
      notch = TRUE,
      plot = TRUE
    )
  }, warning = function(w) {
    return(FALSE)
  })
  if(is.list(notch)){
    notch <- TRUE
  }

  par(las = 1)

  out <- graphics::boxplot(
    formula = value ~ variable,
    data = df_plot,
    xlab = xlab,
    ylab = ylab,
    horizontal = TRUE,
    notch = notch,
    col = color,
    main = main
  )

  if(df_type == "distantia_importance_df"){
    abline(
      v = 0,
      col = "gray50",
      lwd = 2
      )
  }

  out

}
