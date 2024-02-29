#' Column Names of Zoo Objects in Time Series List
#'
#' @param tsl (required, time series list) Individual time series or time series list created with [tsl_initialize]. Default: NULL
#' @param get (optional, character string) Three different sets of column names can be requested:
#' \itemize{
#'   \item "all" (default): list with the column names in each zoo object in `tsl`.
#'   \item "shared": character vector with the shared column names in `tsl`.
#'   \item "exclusive": list with names of exclusive columns in each zoo object in `tsl`.
#' }
#' @param test_valid (optional, logical) If FALSE, the validity test performed by [tsl_is_valid()] is ignored. Useful to improve performance when the user knows that `tsl` is valid. Default: TRUE
#'
#' @return character vector of common column names if `common = TRUE`, or list with character vector of column names otherwise.
#' @export
#'
#' @examples
tsl_get_colnames <- function(
    tsl = NULL,
    get = c("all", "shared", "exclusive"),
    test_valid = TRUE
){

  tsl <- tsl_is_valid(
    tsl = tsl,
    test_valid = test_valid
  )

  get <- match.arg(
    arg = get,
    choices = c(
      c(
        "all",
        "shared",
        "exclusive"
        )
    )
  )

  #all names
  all.names <- lapply(
    X = tsl,
    FUN = function(x){
      colnames(x)
    }
  )

  if(get == "all"){
    return(all.names)
  }

  #shared names
  shared.names <- all.names |>
    unlist() |>
    table()

  shared.names <- shared.names[shared.names == length(tsl)]

  shared.names <- names(shared.names)

  if(get == "shared"){
    return(shared.names)
  }

  #exclusive names
  exclusive.names <- lapply(
    X = tsl,
    FUN = function(x){
      x.exclusive <- setdiff(
        x = colnames(x),
        y = shared.names
      )
      if(length(x.exclusive) == 0){
        return(NA)
      } else {
        return(x.exclusive)
      }
    }
  )

  exclusive.names <- exclusive.names[!is.na(exclusive.names)]

  if(length(exclusive.names) == 0){
    message("There are no exclusive column names in 'tsl'.")
    return(invisible())
  }

  exclusive.names

}
