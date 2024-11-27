#' Splits Multivariate Time Series Lists to Univariate TSLs
#'
#' @description
#' This function takes a time series list with multivariate zoo objects to generate a new one with univariate zoo objects. A time series list with the the zoo objects "A" and "B", each with the columns "a", "b", and "c", becomes a time series list with the zoo objects "A__a", "A__b", "A__c", "B__a", "B__b", and "B__c". The only column of each new zoo object is named "x".
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param sep (required, character string) separator between the time series name and the column name.
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#'
#' tsl <- tsl_simulate(
#'   n = 2,
#'   time_range = c(
#'     "2010-01-01",
#'     "2024-12-31"
#'   ),
#'   cols = 3
#' )
#'
#' names(tsl)
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl)
#' }
#'
#' tsl <- tsl_split(tsl = tsl)
#'
#' names(tsl)
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl)
#' }
#'
#' lapply(tsl, colnames)
#'
#' @family tsl_management
tsl_split <- function(
    tsl = NULL,
    sep = "__"
){

  #return tsl if univariate already
  tsl_columns <- tsl_ncol(tsl) |>
    unlist() |>
    unique()

  if(all(tsl_columns == 1)){
    return(tsl)
  }

  iterations_df <- expand.grid(
    tsl_name = names(tsl),
    time_series_name = lapply(
      X = tsl,
      FUN = colnames
    ) |>
      unlist(),
    stringsAsFactors = FALSE
  )

  iterations_df <- iterations_df[order(iterations_df$tsl_name), ]

  iterations_df$new_name <- paste(
    iterations_df$tsl_name,
    iterations_df$time_series_name,
    sep = sep
  )

  tsl_new <- list()

  for(i in seq_len(nrow(iterations_df))){

    zoo_i <- tsl[[iterations_df$tsl_name[i]]][, iterations_df$time_series_name[i], drop = FALSE]

    colnames(zoo_i) <- "x"

    tsl_new[[iterations_df$new_name[i]]] <- zoo_i

  }

  tsl_new <- tsl_names_set(tsl = tsl_new)

  tsl_new

}
