#' Momentum Data Frame to Wide Format
#'
#' @description
#' Transforms a data frame returned by [momentum()] to wide format with the following columns:
#' \itemize{
#'   \item `most_similar`: name of the variable with the highest contribution to similarity (most negative value in the `importance` column) for each pair of time series.
#'   \item `most_dissimilar`: name of the variable with the highest contribution to dissimilarity (most positive value in the `importance` column) for each pair of time series.
#'   \item `importance__variable_name`: contribution to similarity (negative values) or dissimilarity (positive values) of the given variable.
#'   \item `psi_only_with__variable_name`: dissimilarity of the two time series when only using the given variable.
#'   \item `psi_without__variable_name`: dissimilarity of the two time series when removing the given variable.
#' }
#'
#'
#' @param df (required, data frame) Output of [momentum()]. Default: NULL
#' @param sep (required, character string) Separator between the name of the importance metric and the time series variable. Default: "__".
#'
#' @return data frame
#' @export
#' @examples
#'
#' tsl <- tsl_initialize(
#'   x = distantia::albatross,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global
#'   )
#'
#' #importance data frame
#' df <- momentum(
#'   tsl = tsl
#' )
#'
#' df
#'
#' #to wide format
#' df_wide <- momentum_to_wide(
#'   df = df
#' )
#'
#' df_wide
#'
#' @autoglobal
#' @family internal_dissimilarity_analysis
momentum_to_wide <- function(
    df = NULL,
    sep = "__"
){

  df_type <- attributes(df)$type

  if(!(
    df_type %in% c(
      "momentum_df"
    )
  )
  ){
    stop("distantia::momentum_to_wide(): argument 'df' must be the output of distantia::momentum().", call. = FALSE)
  }

  #aggregate to keep the important columns only
  df <- momentum_aggregate(
    df = df
  )

  #create columns most_similar and most_dissimilar
  select_variable <- function(importance, variable, f = which.max) {
    variable[f(importance)]
  }

  most_dissimilar <- stats::aggregate(
    importance ~ x + y,
    data = df,
    FUN = function(importance) {
      select_variable(
        importance,
        variable = df$variable[df$x == df$x[1] & df$y == df$y[1]],
        f = which.max
      )
    }
  )

  names(most_dissimilar)[3] <- "most_dissimilar"

  most_similar <- stats::aggregate(
    importance ~ x + y,
    data = df,
    FUN = function(importance) {
      select_variable(
        importance,
        variable = df$variable[df$x == df$x[1] & df$y == df$y[1]],
        f = which.min
      )
    }
  )

  names(most_similar)[3] <- "most_similar"

  #merge new columns
  new_columns <- merge(
    most_similar,
    most_dissimilar
  )

  # merge with df
  df <- merge(
    df,
    new_columns,
    by = c("x", "y"),
    all.x = TRUE
  )

  #fixed part of the data frame
  df_wide_psi <- unique(
    df[, c(
      "x",
      "y",
      "psi",
      "most_similar",
      "most_dissimilar"
    )]
  )

  #variable to wide
  df_wide_variable <- stats::reshape(
    data = df[, c(
      "x",
      "y",
      "variable",
      "importance",
      "psi_only_with",
      "psi_without"
      )],
    timevar = "variable",
    idvar = c("x", "y"),
    direction = "wide",
    sep = sep
  )

  #colnames for ordering
  id_columns <- colnames(df_wide_psi)

  importance_columns <- setdiff(
    x = colnames(df_wide_variable),
    y = id_columns
  ) |>
    sort()


  #merge
  df <- merge(
    x = df_wide_psi,
    y = df_wide_variable
  )

  #reorder columns
  df <- df[, c(id_columns, importance_columns)]

  df

}
