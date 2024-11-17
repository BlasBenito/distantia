#' Count NA Cases in Time Series Lists
#'
#' @description
#' Converts Inf, -Inf, and NaN to NA (via [tsl_Inf_to_NA()] and [tsl_NaN_to_NA()]), and counts the total number of NA cases in each time series.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param quiet (optional, logical) If TRUE, all messages are suppressed. Default: FALSE
#'
#' @return list
#' @export
#' @autoglobal
#' @examples
#' #tsl with no NA cases
#' tsl <- tsl_simulate()
#'
#' tsl_count_NA(tsl = tsl)
#'
#' #tsl with NA cases
#' tsl <- tsl_simulate(
#'   na_fraction = 0.3
#' )
#'
#' tsl_count_NA(tsl = tsl)
#'
#' #tsl with variety of empty cases
#' tsl <- tsl_simulate()
#' tsl[[1]][1, 1] <- Inf
#' tsl[[1]][2, 1] <- -Inf
#' tsl[[1]][3, 1] <- NaN
#' tsl[[1]][4, 1] <- NaN
#'
#' tsl_count_NA(tsl = tsl)
#' @family tsl_management
tsl_count_NA <- function(
    tsl = NULL,
    quiet = FALSE
){

  #replaces Inf with Na
  tsl <- tsl_Inf_to_NA(
    tsl = tsl
  )

  #replaces NaN with NA
  tsl <- tsl_NaN_to_NA(
    tsl = tsl
  )

  na_count_list <- lapply(
    X = tsl,
    FUN = function(tsl) sum(is.na(tsl))
  )

  na_sum <- sum(unlist(na_count_list))

  if(na_sum > 0){

    if(quiet == FALSE){

      na_count_table <-  utils::stack(na_count_list)

      na_count_table <- na_count_table[, c("ind", "values")]

      names(na_count_table) <- c("name", "NA_cases")

      message(
        "distantia::tsl_count_NA(): NA cases in 'tsl': \n",
        paste(utils::capture.output(print(na_count_table)), collapse = "\n"),
        "\nPlease impute, replace, or remove them with tsl_handle_NA().",
        call. = FALSE
      )

    }

  }

  na_count_list

}
