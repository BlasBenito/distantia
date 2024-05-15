#' Aggregate Distantia Data Frame
#'
#' @description
#' Applies a function to aggregate the output of [distantia()] when several combinations of arguments have been used.
#'
#' The aggregation function is applied after scaling the dissimilarity scores `Psi` by group.
#'
#' The original data frame is returned without modification if there is a single combination of arguments, or if an invalid `f` is provided.
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
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

  types <- c(
    "distantia_df",
    "distantia_importance_df"
    )

  if(!(df_type %in% types)){
    stop("Argument 'df' must be the output of distantia() or distantia_importance()")
  }

  if(is.null(f) || !is.function(f)){
    message("Argument 'f' is NULL, returning 'df' without modification.")
    return(df)
  }

  # split ----
  df_list <- utils_distantia_df_split(
    df = df
  )

  # scale psi by group----
  if(df_type == "distantia_df"){
    df_list <- lapply(
      X = df_list,
      FUN = function(x){
        x$psi <- as.numeric(
          scale(x = x$psi)
        )
        x
      }
    )
  }

  if(df_type == "distantia_importance_df"){
    df_list <- lapply(
      X = df_list,
      FUN = function(x){
        x$importance <- as.numeric(
          scale(x = x$importance)
        )
        x
      }
    )
  }


  df <- do.call(
    what = "rbind",
    args = df_list
  )

  # aggregate ----
  if(df_type == "distantia_df"){

    df <- stats::aggregate(
      x = df,
      by = psi ~ x + y,
      FUN = f,
      ... = ...
    )

    #start aggregated distances at zero
    df$psi <- df$psi + abs(min(df$psi))
  }

  if(df_type == "distantia_importance_df"){

    df <- stats::aggregate(
      x = df,
      by = importance ~ x + y + variable,
      FUN = f,
      ... = ...
    )

    #center aggregated importances
    df$importance <- as.numeric(
      scale(
        x = df$importance
        )
    )

  }

  #add type
  attr(
    x = df,
    which = "type"
  ) <- df_type

  df

}
