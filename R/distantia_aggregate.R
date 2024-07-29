#' Aggregates a Distantia Data Frame
#'
#' @description
#'
#' The functions [distantia()] and [distantia_importance()] allow dissimilarity assessments based on different combinations of arguments at once. For example, when the argument `distance` is set to `c("euclidean", "manhattan")`, the output data frame will show two dissimilarity scores for each pair of compared time series, one based on euclidean distances, and another based on manhattan distances.
#'
#' When `df` is the result of [distantia()], the input data is grouped by pairs of time series, and the function `f` is applied to the column "psi" by group
#'
#' When `df` is the result of [distantia_importance()], the input data is grouped by pairs of time series and variables, and the function `f` is applied to the columns "importance", "psi_only_with" and "psi_without" by group. However, if the values TRUE and FALSE appear in the column "robust" (which is not allowed by default in [distantia_importance()]), then the aggregation is cancelled with an error, as the results of both methods should not be aggregated together.
#'
#' If psi scores smaller than zero occur in the aggregated output, then the the smaller psi value is added to the column `psi` to start dissimilarity scores at zero.
#'
#' If there are no different combinations of arguments in the input data frame, no aggregation happens, but all parameter columns are removed.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_importance()]. Default: NULL
#' @param f (optional, function) Function to summarize psi scores (for example, `mean`) when there are several combinations of parameters in `df`. Ignored when there is a single combination of arguments in the input. Default: `mean`
#' @param ... (optional, arguments of `f`) Further arguments to pass to the function `f`.
#'
#' @return data frame.
#' @export
#' @autoglobal
#' @examples
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' data("fagus_dynamics")
#'
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   id_column = "site",
#'   time_column = "date"
#' ) |>
#'   tsl_transform(
#'     f = f_scale
#'   )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     guide_columns = 3
#'     )
#' }
#'
#' #distantia with multiple parameter combinations
#' #-------------------------------------
#' df_multiple <- distantia(
#'   tsl = tsl,
#'   distance = c("euclidean", "manhattan"),
#'   lock_step = c(TRUE, FALSE)
#' )
#'
#' df_multiple[, c(
#'   "x",
#'   "y",
#'   "distance",
#'   "lock_step",
#'   "psi"
#' )]
#'
#' #aggregation using means
#' df <- distantia_aggregate(
#'   df = df_multiple,
#'   f = mean
#' )
#'
#' df
#'
#' #importance with multiple parameter combinations
#' #-------------------------------------
#' df_multiple <- distantia_importance(
#'   tsl = tsl,
#'   distance = c("euclidean", "manhattan"),
#'   lock_step = c(FALSE, TRUE)
#' )
#'
#' df_multiple[, c(
#'   "x",
#'   "y",
#'   "variable",
#'   "distance",
#'   "lock_step",
#'   "importance"
#' )]
#'
#' #aggregation using means
#' df <- distantia_aggregate(
#'   df = df_multiple,
#'   f = mean
#' )
#'
#' df
#'
#' df[, c(
#'   "x",
#'   "y",
#'   "variable",
#'   "importance"
#' )]
#'
#' #distantia with a single parameter combination
#' #------------------------------
#' df_multiple <- distantia(
#'   tsl = tsl,
#'   distance = "euclidean",
#'   lock_step = TRUE
#' )
#'
#' df_multiple
#'
#' #no aggregation happens, but all parameter columns are removed
#' df <- distantia_aggregate(
#'   df = df_multiple,
#'   f = mean
#' )
#'
#' df
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
