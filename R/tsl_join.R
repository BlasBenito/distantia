#' Join Time Series Lists
#'
#' @description
#' Joins an arbitrary of time series lists by name and time. Pairs of zoo objects are joined with [zoo::merge.zoo()]. Names that are not shared across all input TSLs are ignored, and observations with no matching time are filled with NA and then managed via [tsl_handle_NA()] depending on the value of the argument `na_action`.
#'
#' @param ... (required, time series lists) names of the time series lists to merge.
#' @inheritParams tsl_handle_NA
#'
#' @return time series list
#' @export
#' @autoglobal
#' @examples
#' #parallelization setup (not worth it for this data size)
#' future::plan(
#'   future::multisession,
#'   workers = 2 #set to parallelly::availableCores() - 1
#' )
#'
#' #progress bar
#' progressr::handlers(global = TRUE)
#'
#' #generate two time series list to join
#' tsl_a <- tsl_simulate(
#'   n = 2,
#'   cols = 2,
#'   irregular = TRUE,
#'   seed = 1
#' )
#'
#' #needs renaming
#' tsl_b <- tsl_simulate(
#'   n = 3,
#'   cols = 2,
#'   irregular = TRUE,
#'   seed = 2
#' ) |>
#'   tsl_colnames_set(
#'     names = c("c", "d")
#'   )
#'
#' #join
#' tsl <- tsl_join(
#'   tsl_a,
#'   tsl_b
#' )
#'
#' #plot result
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl
#'   )
#' }
#'
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
#' @family tsl_management
tsl_join <- function(
    ...,
    na_action = "impute"
    ){

  #gather lists
  tsls <- list(...)

  if (length(tsls) <= 1) {
    stop(
      "distantia::tsl_join(): more than TSL is required.",
      call. = FALSE
      )
  }

  #get shared list names
  shared_names <- Reduce(
    f = intersect,
    x = lapply(
      X = tsls,
      FUN = tsl_names_get
      )
    )

  if(length(shared_names) == 0){
    stop(
      "distantia::tsl_join(): input TSLs do not have shared names.",
      call. = FALSE
    )
  }

  p <- progressr::progressor(along = tsls)

  #subset common elements in all lists
  tsls <- future.apply::future_lapply(
    X = tsls,
    FUN = function(x){

      p()

      tsl_subset(
        tsl = x,
        names = shared_names
      )

    })

  #join
  p <- progressr::progressor(along = shared_names)

  tsl <- future.apply::future_lapply(
    X = shared_names,
    FUN = function(name) {

      # p()

      do.call(
        what = zoo::merge.zoo,
        args = c(
          lapply(
            X = tsls,
            FUN = `[[`,
            name
          ),
          list(
            all = TRUE,
            fill = NA
          )
        )
      )
    }
  )

  tsl <- tsl_names_set(
    tsl = tsl,
    names = shared_names
  )

  #handle NA cases
  tsl_na_count <- tsl_count_NA(
    tsl = tsl
  ) |>
    unlist() |>
    sum()

  if(tsl_na_count > 0){
    message(
      "distantia::tsl_join(): ", tsl_na_count, " NA cases generated were handled via distantia::tsl_handle_NA() with 'na_action = '",
      na_action, "''."
    )
  }

  tsl <- tsl_handle_NA(
    tsl = tsl,
    na_action = na_action
  )

  tsl

}
