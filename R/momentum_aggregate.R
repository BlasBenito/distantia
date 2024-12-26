#' Aggregate `momentum()` Data Frames Across Parameter Combinations
#'
#' @description
#'
#' The function [momentum()] allows variable importance assessments based on several combinations of arguments at once. For example, when the argument `distance` is set to `c("euclidean", "manhattan")`, the output data frame will show two importance scores for each pair of compared time series and variable, one based on euclidean distances, and another based on manhattan distances.
#'
#' This function computes importance stats across combinations of parameters.
#'
#' If there are no different combinations of arguments in the input data frame, no aggregation happens, but all parameter columns are removed.
#'
#' @param df (required, data frame) Output of [momentum()], [momentum_ls()], or [momentum_dtw()]. Default: NULL
#' @param f (optional, function) Function to summarize psi scores (for example, `mean`) when there are several combinations of parameters in `df`. Ignored when there is a single combination of arguments in the input. Default: `mean`
#' @param ... (optional, arguments of `f`) Further arguments to pass to the function `f`.
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global
#'   )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     guide_columns = 3
#'     )
#' }
#'
#' #momentum with multiple parameter combinations
#' #-------------------------------------
#' df <- momentum(
#'   tsl = tsl,
#'   distance = c("euclidean", "manhattan"),
#'   lock_step = TRUE
#' )
#'
#' df[, c(
#'   "x",
#'   "y",
#'   "distance",
#'   "importance"
#' )]
#'
#' #aggregation using means
#' df <- momentum_aggregate(
#'   df = df,
#'   f = mean
#' )
#'
#' df
#' @family momentum_support
momentum_aggregate <- function(
    df = NULL,
    f = mean,
    ...
){

  df_type <- attributes(df)$type

  if(df_type != "momentum_df"){
    stop("distantia::momentum_aggregate(): argument 'df' must be the output of 'momentum()'.", call. = FALSE)
  }

  if(!is.function(f)){
    stop("distantia::momentum_aggregate(): argument 'f' must be a function such as mean, median, mean, max, and the likes.", call. = FALSE)
  }

  # split ----
  df_list <- utils_distantia_df_split(
    df = df
  )

  if(length(df_list) == 1){
    df$distance <- NULL
    df$diagonal <- NULL
    df$bandwidth <- NULL
    df$lock_step <- NULL
    df$robust <- NULL
    return(df)
  }

  if("robust" %in% colnames(df)){

    if(length(unique(df$robust)) == 2){

      warning("distantia::momentum_aggregate(): Column 'robust' has the values TRUE and FALSE. The aggregation of importance scores computed with both options is not supported. Cases where 'df$robust == FALSE' will be ignored.", call. = FALSE)

      df <- df[df$robust == TRUE, ]

      df$robust <- NULL

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

  if("psi_without" %in% colnames(df)){

    df_aggregated$psi_without <- stats::aggregate(
      x = df,
      by = psi_without ~ x + y + variable,
      FUN = f,
      ... = ...
    )$psi_without

  }

  if("psi_only_with" %in% colnames(df)){

    df_aggregated$psi_only_with <- stats::aggregate(
      x = df,
      by = psi_only_with ~ x + y + variable,
      FUN = f,
      ... = ...
    )$psi_only_with

  }

  df <- df_aggregated

  #add type
  attr(
    x = df,
    which = "type"
  ) <- df_type

  df

}
