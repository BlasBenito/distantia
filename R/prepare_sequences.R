#' Prepare x for Dissimilarity Analysis
#'
#' @description
#' This function performs the following steps:
#' - Converts a data frame to a list by 'id_column'.
#' - Checks the validity of input x.
#' - Orders x by time if a time column is PROVIDED
#' - Handles missing values according to the specified action.
#' - Handles zeros by replacing them with a pseudo-zero value, if provided.
#' - Transforms the data if a transformation function is provided.
#'
#'
#' @param x (required, list or data frame) A named list with ordered sequences, or a long data frame with a grouping column. Default: NULL.
#' @param id_column (optional, column name) Column name used for splitting a 'x' data frame into a list.
#' @param time_column (optional if `paired_samples = FALSE`, and required otherwise, column name) Name of the column representing time, if any. Default: NULL.
#' @param transformation  (optional, function) A function to transform the data within each sequence. A few options are:
#' \itemize{
#'   \item [f_proportion()]: to transform counts into proportions.
#'   \item [f_percentage()]: to transform counts into percentages.
#'   \item [f_hellinger()]: to apply a Hellinger transformation.
#'   \item [f_scale()]: to center and scale the data.
#'   }
#' @param paired_samples (optional, logical) If TRUE, all input sequences are subset to their common times according to the values in the `time_column`.
#' @param pseudo_zero (optional, numeric) Value used to replace zeros in the data. Default: NULL.
#' @param na_action (optional, character string) Action to handle missing values. default: NULL.
#' \itemize{
#'   \item "omit": applies [na.omit()] to each sequence.
#'   \item "to_zero": replaces NA values with zero or `pseudo_zero`, if provided.
#'   \item "impute": not implemented yet.
#' }
#' @return A named list of data frames, matrices, or vectors.
#' @examples
#' data(sequencesMIS)
#' x <- prepare_sequences(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#' @autoglobal
#' @export
prepare_sequences <- function(
    x = NULL,
    id_column = NULL,
    time_column = NULL,
    transformation = NULL,
    paired_samples = FALSE,
    pseudo_zero = NULL,
    na_action = "omit"
){

  if(is.null(x)){
    stop("Argument 'x' must not be NULL")
  }

  #check NA action argument
  na_action <- match.arg(
    arg = na_action,
    choices = c(
      "omit",
      "to_zero",
      "impute"#not implemented yet
    )
  )

  #DATA FRAME TO LIST
  #############################################
  if(inherits(x = x, what = "data.frame")){

    if(is.null(id_column)){
      stop("Argument 'id_column' cannot be NULL when 'x' is a data frame.")
    }

    if(!(id_column %in% colnames(x))){
      stop("Argument 'id_column' must be a column name of 'x'.")
    }

    #separate groups to list
    x <- split(
      x = x[, colnames(x) != id_column],
      f = x[[id_column]]
    )

  }

  #CHECK CLASSES IN X
  ################################################
  x.class <- lapply(
    X = x,
    FUN = class
  ) |>
    unlist() |>
    as.data.frame()

  colnames(x.class) <- "class"

  if(length(unique(x.class[, 1])) > 1){

    print(x.class)
    stop("All objects in 'x' must be of the same class (data.frame, matrix, or vector).")

  }

  #CONVERTING VECTORS TO DATA FRAMES
  #######################################
  x.vector <- lapply(
    X = x,
    FUN = is.vector
  ) |>
    unlist()

  if(sum(x.vector) == length(x)){

    x <- lapply(
      X = x,
      FUN = function(x){
        data.frame(
          x = x
        )
      }
    )

  }

  #CONVERTING MATRICES TO DATA FRAMES
  #######################################
  x.matrix <- lapply(
    X = x,
    FUN = is.matrix
  ) |>
    unlist()

  #all elements are matrices
  if(all(x.matrix) == TRUE){

    #number of unique column names
    x.matrix.colnames <- lapply(
      X = x,
      FUN = colnames
    ) |>
      unlist() |>
      unique()

    #number of columns per matrix
    x.matrix.ncol <- lapply(
      X = x,
      FUN = ncol
    ) |>
      unlist() |>
      unique() |>
      length()

    #error if matrices have different number of columns
    #and no column names
    if(is.null(x.matrix.colnames) && x.matrix.ncol > 1){
      stop("Elements in 'x' are matrices without column names and different numbers of columns. Please provide matrices with column names or with the same number of columns.")

    }

    #fix matrices colnames


    x <- lapply(
      X = x,
      FUN = function(x){
        if(is.null(colnames(x))){
          colnames(x) <- paste0("x", seq_len(ncol(x)))
        }
        x <- as.data.frame(x)

        return(x)
      }
    )

  }




  #add fake time column
  if(is.null(time_column)){
    time_column <- "row_id"
    x <- lapply(
      X = x,
      FUN = function(x){
        n <- ifelse(
          test = is.data.frame(x) | is.matrix(x),
          yes = nrow(x),
          no = length(x)
        )
        x[[time_column]] <- 1:n
        return(x)
      }
    )
  }

  #x is not a list
  if(inherits(x = x, what = "list") == FALSE){
    stop("Argument 'x' must be a list.")
  }

  #x is too short
  if(length(x) < 2){
    stop("Argument 'x' must be a list with a least two elements.")
  }

  if(any(is.null(names(x)))){
    stop("All elements in the list 'x' must be named.")
  }

  #check classes in x
  x.classes <- lapply(
    X = x,
    FUN = class
  ) |>
    unlist()

  x.classes <- x.classes[!(x.classes %in% c("data.frame", "matrix"))]

  if(length(x.classes) > 0){
    warning("The elements of the list 'x' must be of the class 'data.frame' or 'matrix'.")
  }

  #order by time
  ###################################
  x.with.time <- lapply(
    X = x,
    FUN = function(x) time_column %in% colnames(x)
  ) |>
    unlist() |>
    sum()

  if(x.with.time == length(x)){

    #arrange by time
    x <- lapply(
      X = x,
      FUN = function(x){
        x[order(x[[time_column]]), ]
      }
    )

    #paired samples
    #keep common times only
    ####################################
    if(paired_samples == TRUE){

      times <- lapply(
        X = x,
        FUN = function(x) unique(x[[time_column]])
      ) |>
        unlist() |>
        table()

      times_common <- as.numeric(names(times)[times == length(x)])

      x <- lapply(
        X = x,
        FUN = function(x) x[x[[time_column]] %in% times_common, ]
      )

    }

  }

  #keep numeric columns only
  x <- lapply(
    X = x,
    FUN = function(x){
      x <- x[, sapply(x, is.numeric)]
    }
  )

  #handle NA
  #####################################
  if(na_action == "omit"){
    x <- lapply(
      X = x,
      FUN = function(x) na.omit(x)
    )
  }

  if(na_action == "to_zero"){

    if(is.null(pseudo_zero)){
      zero <- 0
    } else {
      zero <- pseudo_zero
    }

    x <- lapply(
      X = x,
      FUN = function(x) x[is.na(x)] <- zero
    )

  }

  if(na_action == "impute"){
    stop("Imputation of NAs is not implemented yet.")
  }

  #handle zeros
  ##################################
  if(!is.null(pseudo_zero)){

    x <- lapply(
      X = x,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x[x == 0] <- pseudo_zero
        x[[time_column]] <- x.time
        return(x)
      }
    )

  }

  #transform
  #####################################
  if(inherits(x = transformation, what = "function")){

    #apply transformation
    x <- lapply(
      X = x,
      FUN = function(x){
        x.time <- x[[time_column]]
        x[[time_column]] <- NULL
        x <- transformation(x = x)
        x[[time_column]] <- x.time
        return(x)
      }
    )

  }

  #remove fake time column
  x <- lapply(
    X = x,
    FUN = function(x){
      x[, colnames(x) != "row_id"]
    }
  )

  #add attribute to ignore time column
  if(!is.null(time_column)){
    x <- lapply(
      X = x,
      FUN = function(x){
        attr(x, "ignore_columns") <- time_column
        return(x)
      }
    )
  }

  #convert to matrix
  x <- lapply(
    X = x,
    FUN = function(x) as.matrix(x)
  )

  #add attribute to indicate the data frames are validated
  x <- lapply(
    X = x,
    FUN = function(x){
      attr(x, "validated") <- TRUE
      return(x)
    }
  )

  x

}
