#' Aggregate Distantia Data Frame
#'
#' @description
#' Applies a function to aggregate the output of [distantia()] when several combinations of arguments have been used.
#'
#' The aggregation function is applied after scaling the dissimilarity scores `Psi` by group.
#'
#' The original data frame is returned without modification if there is a single combination of arguments, or if an invalid `f` is provided.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_importance()]. Default: NULL
#' @param f (optional, function) Function to summarize psi scores (for example, `mean`) when there are several combinations of parameters in `df`. Ignored when there is a single combination of [distantia()] arguments in the input. Default: `mean`
#' @param ... (optional, arguments of `f`) Further arguments to pass to the function `f`.
#'
#' @return Data frame with attribute "type" equal to "distantia_df.
#' @export
#' @autoglobal
#' @examples
distantia_aggregate <- function(
    df = NULL,
    f = mean,
    ...
){

  df_type <- attributes(df)$type

  if(!(
    df_type %in% c(
      "distantia_df",
      "distantia_importance_df"
    )
  )
  ){
    stop("Argument 'df' must be the output of distantia() or distantia_importance()")
  }

  if(!is.function(f)){
    stop("Argument 'f' must be a function such as mean, median, mean, max, and the likes")
  }

  # split ----
  df_list <- utils_distantia_df_split(
    df = df
  )

  # aggregate ----
  if(df_type == "distantia_df"){

    df <- stats::aggregate(
      x = df,
      by = psi ~ x + y,
      FUN = f,
      ... = ...
    )

  }

  if(df_type == "distantia_importance_df"){

    if("robust" %in% colnames(df)){

      if(length(unique(df$robust)) == 2){

        warning("Column 'robust' has the values TRUE and FALSE. The aggregation of importance scores computed with both options is not supported. Cases where 'df$robust == FALSE' will be ignored.")

        df <- df[df$robust == TRUE, ]

      }

    }

    df_aggregated <- stats::aggregate(
      x = df,
      by = psi ~ x + y + variable,
      FUN = f,
      ... = ...
    )

    df_aggregated$importance <- stats::aggregate(
      x = df,
      by = importance ~ x + y + variable,
      FUN = f,
      ... = ...
    )$importance

    df_aggregated$psi_drop <- stats::aggregate(
      x = df,
      by = psi_drop ~ x + y + variable,
      FUN = f,
      ... = ...
    )$psi_drop

    df_aggregated$psi_without <- stats::aggregate(
      x = df,
      by = psi_without ~ x + y + variable,
      FUN = f,
      ... = ...
    )$psi_without

    df_aggregated$psi_only_with <- stats::aggregate(
      x = df,
      by = psi_only_with ~ x + y + variable,
      FUN = f,
      ... = ...
    )$psi_only_with

    df <- df_aggregated

  }

  #start aggregated distances at zero
  if(min(df$psi) < 0){
    df$psi <- df$psi + abs(min(df$psi))
  }

  #add type
  attr(
    x = df,
    which = "type"
  ) <- df_type

  df

}
