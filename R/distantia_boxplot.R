distantia_boxplot <- function(
    df = NULL
){

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
    xlab <- "Psi"
    ylab <- "Name"

  }

  if(df_type == "distantia_importance_df"){

      variable <- df$variable
      value <- df$importance
      xlab <- "Importance"
      ylab <- "Variable"

  }

  graphics::boxplot(
    formula = value ~ variable,
    data = data.frame(
      variable = variable,
      value = value
    ),
    xlab = xlab,
    ylab = ylab,
    horizontal = TRUE
  )


}
