#' Prepare List of Data Frames for Dissimilarity Analysis
#'
#'
#' @param x (required, list of data frames) A named list with data frames. Default: NULL.
#' @param time_column (optional if `paired_samples = FALSE`, and required otherwise, column name) Name of the column representing time, if any. Default: NULL.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. default: NULL.
#' \itemize{
#'   \item NULL: returns the input without changes.
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "to_zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": not implemented yet.
#' }
#' @param paired_samples (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`.
#' @return A named list of data frames, matrices, or vectors.
#' @examples
#' data(sequencesMIS)
#' x <- prepare_sequences(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
prepare_zoo_list <- function(
    x = NULL,
    time_column = NULL,
    pseudo_zero = NULL,
    na_action = NULL,
    paired_samples = FALSE
){

  if(
    prepare_list_class(
      x = x,
      expected_class = "data.frame"
    ) == FALSE
  ){

    stop("Argument 'x' must be a list of data frames.")

  }

  #at least 2 elements
  if(length(x) == 1){
    stop("Argument 'x' must be a list with a least two elements.")
  }

  #elements must be named
  if(any(is.null(names(x)))){
    stop("All elements in the list 'x' must be named.")
  }

  # + convert to matrix
  ###################
  x <- lapply(
    X = x,
    FUN = function(i){

      i.name <- attributes(i)$name
      i.index <- attributes(i)$index

      #get numeric columns only
      i <- i[, sapply(i, is.numeric), drop = FALSE]

      #convert to zoo
      i <- zoo::zoo(
        x = i,
        order.by = i.index
        )

      #handle na
      i <- prepare_na(
        x = i,
        pseudo_zero = pseudo_zero,
        na_action = na_action
      )

      attr(x = i, which = "name") <- i.name

      return(i)

    }
  )

  #add attribute name
  for(i in seq_len(length(x))){
    attr(x[[i]], "name") <- names(x)[[i]]
  }

  x

}
