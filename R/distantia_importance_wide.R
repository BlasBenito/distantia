#' Distantia Importance Data Frame to Wide Format
#'
#' @param df (required, data frame) Output of [distantia_importance()]. Default: NULL
#' @param sep (required, character string) Separator between the name of the importance metric and the time series variable. Default: "__".
#'
#' @return wide data frame
#' @export
#' @examples
#'
#' data("eemian_pollen")
#' data("eemian_coordinates")
#'
#' #initialize tsl
#' tsl <- distantia::tsl_init(
#'   x = distantia::eemian_pollen,
#'   id_column = "site",
#'   time_column = "depth"
#' )
#'
#' #compute importance
#' df <- distantia::distantia_importance(
#'   tsl = tsl
#' )
#'
#' colnames(df)
#'
#' #to wide format, one column per variable and importance metric
#' df_wide <- distantia::distantia_importance_wide(
#'   df = df
#' )
#'
#' colnames(df_wide)
#'
#'
#' @autoglobal
distantia_importance_wide <- function(
    df = NULL,
    sep = "__"
){

  #aggregate to keep the important columns only
  df <- distantia_aggregate(
    df = df
  )

  #keep psi
  df_wide_psi <- unique(df[, c("x", "y", "psi")])

  #variable to wide
  df_wide_variable <- stats::reshape(
    data = df[, colnames(df) != "psi"],
    timevar = "variable",
    idvar = c("x", "y"),
    direction = "wide",
    sep = sep
  )

  #colnames for ordering
  importance_columns <- setdiff(
    x = colnames(df_wide_variable),
    y = colnames(df)
    ) |>
    sort()

  id_columns <- colnames(df_wide_psi)

  #merge
  df <- merge(
    x = df_wide_psi,
    y = df_wide_variable
  )

  message("BLAS: remember to implement the qualitative columns 'most_importat', 'least_important', and the likes.")

  #reorder columns
  df <- df[, c(id_columns, importance_columns)]

  df


}
