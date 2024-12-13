#' Data Frame with Pairs of Time Series in Time Series Lists
#'
#' @description
#' Internal function used in [distantia()] and [momentum()] to generate a data frame with combinations of time series and function arguments.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param args_list (required, list) arguments to combine with the pairs of time series. Default: NULL
#'
#' @return data frame
#' @export
#' @autoglobal
#' @family internal
utils_tsl_pairs <- function(
    tsl = NULL,
    args_list = NULL
){

  df_tsl <- data.frame(
    t(
      utils::combn(
        names(tsl),
        m = 2
      )
    )
  )

  names(df_tsl) <- c(
    "x",
    "y"
  )

  if(is.null(args_list)){
    return(df_tsl)
  }

  df_args <- expand.grid(
    args_list,
    stringsAsFactors = FALSE
  )

  df <- merge(
    x = df_tsl,
    y = df_args
  )

  df <- unique(df)

  df


}
