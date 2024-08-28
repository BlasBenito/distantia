#' Data Frame of Time Series Pairs
#'
#' @description
#' Internal function used in [distantia()] and [distantia_importance()] to generate a data frame with combinations of time series and function arguments.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param args_list (required, list) arguments to combine with the pairs of time series. Default: NULL
#'
#' @return data frame
#' @export
#' @autoglobal
#' @family internal_dissimilarity_analysis
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

  #remove combinations diagonal = FALSE weighted = TRUE
  if(all(c("diagonal", "weighted") %in% names(df_args))){

    df_args$weighted <- ifelse(
      test = df_args$diagonal == FALSE,
      yes = FALSE,
      no = df_args$weighted
    )

  }

  df <- merge(
    x = df_tsl,
    y = df_args
  )

  df <- unique(df)

  df


}
