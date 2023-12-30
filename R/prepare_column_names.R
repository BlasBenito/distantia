#' Checks Column Names in a List of Data Frames
#' @param x (required, list of data frames) Default: NULL
#'
#' @return Used for it's side effects: message with names of exclusive column names
#' @export
#' @autoglobal
prepare_column_names <- function(
    x = NULL
){

  #get all column names
  x.colnames <- lapply(
    X = x,
    FUN = colnames
  ) |>
    unlist() |>
    table() |>
    as.data.frame(
      stringsAsFactors = FALSE
    )

  #get common column names
  common.colnames <- x.colnames[x.colnames$Freq == length(x), "Var1"]

  #get exclusive column names
  exclusive.colnames <- x.colnames[x.colnames$Freq == 1, "Var1"]

  if(length(exclusive.colnames) > 0){

    #returning columns missing from each element
    x.colnames.exclusive <- lapply(
      X = x,
      FUN = function(x){
        y <- colnames(x)[colnames(x) %in% exclusive.colnames]
        if(length(y) == 0){
          return(NA)
        } else {
          y
        }
      }
    ) |>
      stack() |>
      na.omit()

    names(x.colnames.exclusive) <- c("Column", "Element")

    warning("There are exclusive columns names in the data that will not be used in a dissimilarity analysis: ")
    print(x.colnames.exclusive)

  }

  x

}
