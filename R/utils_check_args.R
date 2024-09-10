#' Check Input Arguments to `distantia()`
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param diagonal (optional, logical vector). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted (optional, logical vector) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param ignore_blocks (optional, logical vector). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param lock_step (optional, logical vector) If TRUE, time series are compared row wise and no least-cost path is computed. Default: FALSE.
#' @param repetitions (optional, integer vector) number of permutations to compute the p-value (interpreted as the probability of finding a smaller dissimilarity on permuted versions of the sequences) of the psi distance. If 0, p-values are not computed. Otherwise, the minimum is 2. Default: 0
#' @param permutation (optional, character vector) permutation method. Valid values are listed below from higher to lower randomness:
#' \itemize{
#'   \item "free": unrestricted shuffling of rows and columns. Ignores block_size.
#'   \item "free_by_row": unrestricted shuffling of complete rows. Ignores block size.
#'   \item "restricted": restricted shuffling of rows and columns within blocks.
#'   \item "restricted_by_row": restricted shuffling of rows within blocks.
#' }
#' @param block_size (optional, integer vector) vector with block sizes in rows for the restricted permutation test. A block of size 3 indicates that a row can only be permuted within a block of 3 adjacent rows. If several values are provided, one is selected at random separately for each time series on each repetition. Only relevant when permutation methods are "restricted" or "restricted_by_row". Default: 3.
#' @param seed (optional, integer) initial random seed to use for replicability when computing p-values. Default: 1
#' @param robust (required, logical). If TRUE, importance scores are computed using the least cost path used to compute the psi dissimilarity between the two full time series. Setting it to FALSE allows to replicate importance scores of the previous versions of this package. Default: TRUE
#'
#' @return list
#' @export
#' @autoglobal
#' @family internal
utils_check_args_distantia <- function(
    tsl = NULL,
    distance = "euclidean",
    diagonal = TRUE,
    weighted = TRUE,
    ignore_blocks = FALSE,
    lock_step = FALSE,
    repetitions = 0,
    permutation = "restricted_by_row",
    block_size = 3,
    seed = 1,
    robust = TRUE
    ){

  #check validity
  tsl <- tsl_diagnose(
    tsl = tsl,
    full = FALSE
  )

  distance <- utils_check_distance_args(
    distance = distance
  )

  logical_message <- "must be logical. Accepted values are; TRUE, FALSE, c(TRUE, FALSE)."

  if(any(is.logical(diagonal) == FALSE)){
    stop("Argument 'diagonal'", logical_message)
  }

  if(length(diagonal) == 1){
    if(diagonal == FALSE){
      weighted <- FALSE
    } else {
      ignore_blocks <- FALSE
    }
  }

  if(any(is.logical(weighted) == FALSE)){
    stop("Argument 'weighted'", logical_message)
  }

  if(any(is.logical(ignore_blocks) == FALSE)){
    stop("Argument 'ignore_blocks'", logical_message)
  }

  if(any(is.logical(lock_step) == FALSE)){
    stop("Argument 'lock_step'", logical_message)
  }

  if(exists("robust")){
    if(any(is.logical(robust) == FALSE)){
      stop("Argument 'robust'", logical_message)
    }
    if(length(robust) > 1){
      robust <- robust[1]
      message("Argument 'robust' may either be TRUE or FALSE. Using the first option available in the input vector: '", robust, "'.")
    }
  }

  repetitions <- as.integer(repetitions)
  if(any(is.integer(repetitions) == FALSE)){
    stop("Argument 'repetitions' must be a integer or a numeric vector.")
  }

  if(repetitions > 0){

    permutation <- match.arg(
      arg = permutation,
      choices = c(
        "free",
        "free_by_row",
        "restricted",
        "restricted_by_row"
      ),
      several.ok = TRUE
    )

    block_size <- as.integer(block_size)
    if(any(is.integer(block_size) == FALSE)){
      stop("Argument 'block_size' must be a integer or a numeric vector.")
    }

    seed <- as.integer(seed)
    if(any(is.integer(seed) == FALSE)){
      stop("Argument 'block_size' must be a integer or a numeric vector.")
    }

  } else {

    permutation <- NULL
    block_size <- NULL
    seed <- NULL

  }

  out <- list(
    tsl = tsl,
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    lock_step = lock_step,
    repetitions = repetitions,
    permutation = permutation,
    block_size = block_size,
    seed = seed,
    robust = robust
  )

  out

}

#' Checks Least Cost Path
#'
#' @param path (required, data frame) least cost path generated with [psi_cost_path()]. This data frame must have the attribute `type == "cost_path`, and must have been computed from the same time series used to compute the matrix `m`. Default: NULL.
#' @param arg_name (optional, character string) name of the argument being checked. Default: NULL
#'
#' @return data frame
#' @export
#' @autoglobal
#' @family internal
utils_check_args_path <- function(
    path = NULL,
    arg_name = "path"
){

  if(is.null(path)){
    stop(
      "Argument ",
      arg_name,
      " must not be NULL."
    )
  }

  if(
    inherits(x = path, what = "data.frame") == FALSE |
    any(
      is.null(
        attributes(path)[c(
          "y_name",
          "x_name",
          "type",
          "distance"
        )]
      )
    )
  ){
    stop(
      "Argument ",
      arg_name,
      " must be a data frame resulting from distantia::psi_cost_path()."
    )
  }

  path

}

#' Checks Input Matrix
#'
#' @param m (required, matrix) distance or cost matrix resulting from [psi_distance_matrix()] or [psi_cost_matrix()]. Default: NULL
#' @param arg_name (optional, character string) name of the argument being checked. Default: NULL
#'
#' @return matrix
#' @export
#' @autoglobal
#' @family internal
utils_check_args_matrix <- function(
    m = NULL,
    arg_name = "m"
){

  if(is.null(m)){
    stop(
      "Argument ",
      arg_name,
      " must not be NULL."
    )
  }

  if(is.list(m)){

    if(length(m) > 1){
      warning(
        "Argument ",
        arg_name,
        " is a list with several matrices, but only the first one will be used. Please use the notation m = m[[index]] to select a different one.")
    }

    m <- m[[1]]

  }

  if(
    inherits(x = m, what = "matrix") == FALSE){
    stop(
      "Argument ",
      arg_name,
      " must be of the class 'matrix'")
  }

 m

}



#' Structural Check for Time Series Lists
#'
#' @description
#' Internal function to check that a time series list is a list of zoo objects and has a minimum number of objects. For a more comprehensive test, use [tsl_diagnose()].
#'
#'
#' @param tsl (required, list) list of zoo objects. Default: NULL
#' @param min_length (required, positive integer) minimum number of zoo objects in `tsl`. Default: 2
#'
#' @return error messages (if any)
#' @export
#' @autoglobal
utils_check_args_tsl <- function(
    tsl = NULL,
    min_length = 2
){

  if(is.null(tsl)){
    stop("Argument 'tsl' must not be NULL.")
  }

  #check list class
  if(!is.list(tsl)){
    stop("Argument 'tsl' must be a list.")
  }

  #check class of components
  tsl.class <- lapply(
    X = tsl,
    FUN = class
  ) |>
    unlist() |>
    unique()

  if(tsl.class != "zoo"){
    stop("Argument 'tsl' must be a list of zoo objects.")
  }

  #check min length
  min_length <- abs(as.integer(min_length))
  if(length(tsl) < min_length){
    stop("Argument 'tsl' must be a list with at least ", min_length, " zoo objects.")
  }

}

#' Checks Argument x
#'
#' @param x (required, zoo object) zoo time series. Default: NULL
#' @param arg_name (optional, character string) name of the argument being checked. Default: NULL
#'
#' @return zoo object
#' @export
#' @autoglobal
#' @family internal
utils_check_args_zoo <- function(
    x = NULL,
    arg_name = "x"
    ){

    if(zoo::is.zoo(x) == FALSE){
      stop("Argument ", arg_name, " must be a time series of class 'zoo'.")
    }

  x


}

#' Check Distance Argument
#'
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return character vector
#' @export
#' @autoglobal
#' @examples
#'
#' utils_check_distance_args(
#'   distance = c(
#'     "euclidean",
#'     "euc"
#'    )
#'   )
#' @family internal
utils_check_distance_args <- function(
    distance = NULL
    ){

  #checking distance values
  distance <- match.arg(
    arg = distance,
    choices = c(
      distances$name,
      distances$abbreviation
    ),
    several.ok = TRUE
  )

  #select rows of distances df
  distances_df <- distances[
    distances$name %in% distance |
      distances$abbreviation %in% distance,
  ]

  if(nrow(distances_df) == 0){
    stop("Please use distance names or abbreviations available in data(distances).")
  }

  distances_df$name

}
