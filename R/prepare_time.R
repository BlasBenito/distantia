


#' Handles Time Column in List of Data Frames
#'
#' @param x (required, named list of data frames). List with named data frames. Default: NULL.
#' @param time_column (optional if `paired_samples = FALSE`, and required otherwise, column name) Name of numeric column representing time. Default: NULL.
#' @param paired_samples (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`. Default: FALSE.
#'
#' @return List of data frames
#' @export
#' @autoglobal
prepare_time <- function(
    x = NULL,
    time_column = NULL,
    paired_samples = NULL
){

  #if no time column, add "row_id"
  if(is.null(time_column)){

    #error if both time_column and paired samples are NULL
    if(paired_samples == TRUE){
      stop("Argument 'time_column' cannot be NULL when 'paired_samples' is TRUE'.")
    }

    time_column <- "row_id"

    x <- lapply(
      X = x,
      FUN = function(x){
        x[[time_column]] <- seq_len(nrow(x))
        return(x)
      }
    )

  } else {

    #check that the time column is numeric
    x.time.numeric <- lapply(
      X = x,
      FUN = function(x) is.numeric(x[[time_column]])
    ) |>
      unlist()

    #names of elements with no time
    x.time.numeric <- names(x.time.numeric[!x.time.numeric])

    #ERROR if time missing from any element
    if(length(x.time.numeric) > 0){

      stop("The time column '", time_column, "' is not numeric in these elements of 'x': ", paste(x.time.numeric, collapse = ", "))

    }


    #check that time column is in all elements
    x.no.time <- lapply(
      X = x,
      FUN = function(x){
        time_column %in% colnames(x)
      }
    ) |>
      unlist()

    #names of elements with no time
    x.no.time <- names(x.no.time[!x.no.time])

    #ERROR if time missing from any element
    if(length(x.no.time) > 0){

      stop("These elements of 'x' do not have the time column '", time_column, "': ", paste(x.no.time, collapse = ", "))

    }

    #arrange all elements by time
    x <- lapply(
      X = x,
      FUN = function(x){
        x[order(x[[time_column]]), ]
      }
    )

    #apply paired samples
    if(paired_samples == TRUE){

      times <- lapply(
        X = x,
        FUN = function(x) x[[time_column]]
      ) |>
        unlist() |>
        table() |>
        as.data.frame(stringsAsFactors = FALSE)

      time_common <- times[times$Freq == length(x), "Var1"]

      times_common <- as.numeric(names(times)[times == length(x)])

      x <- lapply(
        X = x,
        FUN = function(x) x[x[[time_column]] %in% times_common, ]
      )

    }

  }

  #set time attribute
  #remove the time column
  x <- lapply(
    X = x,
    FUN = function(x){
      attr(x = x, which = "time") <- x[[time_column]]
      x[[time_column]] <- NULL
      return(x)
    }
  )

  x

}
