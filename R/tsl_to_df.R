#' Transform Time Series List to Data Frame
#'
#' @param tsl (required, list) Time series list. Default: NULL
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#'
#' tsl <- tsl_simulate(
#'   n = 3,
#'   rows = 10,
#'   time_range = c(
#'     "2010-01-01",
#'     "2020-01-01"
#'   )
#' )
#'
#' df <- tsl_to_df(
#'   tsl = tsl
#' )
#'
#' names(df)
#' nrow(df)
#' head(df)
#' @family tsl_management
tsl_to_df <- function(
    tsl = NULL
){

  tsl <- tsl_diagnose(
    tsl = tsl,
    full = FALSE
  )

  df_list <- lapply(
    X = tsl,
    FUN = function(x){

      data.frame(
        name = attributes(x)$name,
        time = zoo::index(x),
        as.data.frame(x)
      )

    }

  )

  df <- do.call(
    what = "rbind",
    args = df_list
  )

  rownames(df) <- NULL

  df

}
