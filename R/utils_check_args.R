#' Check Input Arguments of `momentum()`
#'
#' @inheritParams momentum
#' @return list
#' @export
#' @autoglobal
#' @family internal
utils_check_args_momentum <- function(
    tsl = NULL,
    distance = NULL,
    diagonal = NULL,
    bandwidth = NULL,
    lock_step = NULL,
    robust = NULL
){

  # tsl ----
  utils_check_args_tsl(
    tsl = tsl,
    min_length = 2
  )

  ## count and handle NA ----
  na_count <- tsl_count_NA(
    tsl = tsl
  ) |>
    unlist()

  if(sum(na_count) > 0){
    message(
      "distantia::utils_check_args_momentum(): ",
      sum(na_count),
      " NA cases were imputed with distantia::tsl_handle_NA() in these time series: '",
      paste(names(na_count[na_count > 0]), collapse = "', '"),
      "'."
    )
  }

  tsl <- tsl_handle_NA(
    tsl = tsl
  )

  ## subset cols -----
  tsl <- tsl_subset(
    tsl = tsl,
    numeric_cols = TRUE,
    shared_cols = TRUE
  )

  ## diagnose tsl ----
  tsl_diagnose(
    tsl = tsl,
    full = FALSE
  )

  #distance ----
  if(!is.null(distance)){

    distance <- utils_check_distance_args(
      distance = distance
    )

  }


  logical_message <- "must be logical. Accepted values are; TRUE, FALSE, c(TRUE, FALSE)."


  #diagonal ----
  if(!is.null(diagonal)){

    if(any(is.logical(diagonal) == FALSE)){
      stop("distantia::utils_check_args_momentum(): argument 'diagonal'", logical_message, ".", call. = FALSE)
    }

  }

  #bandwidth
  if(!is.null(bandwidth)){

    bandwidth[bandwidth > 1] <- 1
    bandwidth[bandwidth < 0] <- 0
    bandwidth <- unique(bandwidth)

  }

  #lock_step ----
  if(!is.null(lock_step)){

    if(any(is.logical(lock_step) == FALSE)){
      stop("distantia::utils_check_args_momentum(): Argument 'lock_step'", logical_message)
    }

  }


  #robust ----
  if(!is.null(robust)){

    if(any(is.logical(robust) == FALSE)){
      stop("distantia::utils_check_args_momentum(): argument 'robust'", logical_message)
    }
    if(length(robust) > 1){
      robust <- robust[1]
      message("distantia::utils_check_args_momentum(): argument 'robust' may either be TRUE or FALSE. Using the first option available in the input vector: '", robust, "'.")
    }

  }

  list(
    tsl = tsl,
    distance = distance,
    diagonal = diagonal,
    bandwidth = bandwidth,
    lock_step = lock_step,
    robust = robust
  )

}

#' Check Input Arguments of `distantia()`
#'
#' @inheritParams distantia
#' @return list
#' @export
#' @autoglobal
#' @family internal
utils_check_args_distantia <- function(
    tsl = NULL,
    distance = NULL,
    diagonal = NULL,
    bandwidth = NULL,
    lock_step = NULL,
    repetitions = NULL,
    permutation = NULL,
    block_size = NULL,
    seed = NULL
){

  # tsl ----
  utils_check_args_tsl(
    tsl = tsl,
    min_length = 2
  )

  ## count and handle NA ----
  na_count <- tsl_count_NA(
    tsl = tsl
  ) |>
    unlist()

  if(sum(na_count) > 0){
    message(
      "distantia::utils_check_args_distantia(): ",
      sum(na_count),
      " NA cases were imputed with distantia::tsl_handle_NA() in these time series: '",
      paste(names(na_count[na_count > 0]), collapse = "', '"),
      "'."
    )
  }

  tsl <- tsl_handle_NA(
    tsl = tsl
  )

  ## subset cols -----
  tsl <- tsl_subset(
    tsl = tsl,
    numeric_cols = TRUE,
    shared_cols = TRUE
  )

  ## diagnose tsl ----
  tsl_diagnose(
    tsl = tsl,
    full = FALSE
  )

  #distance ----
  if(!is.null(distance)){

    distance <- utils_check_distance_args(
      distance = distance
    )

  }


  logical_message <- "must be logical. Accepted values are; TRUE, FALSE, c(TRUE, FALSE)."


  #diagonal ----
  if(!is.null(diagonal)){

    if(any(is.logical(diagonal) == FALSE)){
      stop("distantia::utils_check_args_distantia(): argument 'diagonal'", logical_message, ".", call. = FALSE)
    }

  }

  #bandwidth
  if(!is.null(bandwidth)){

    bandwidth[bandwidth > 1] <- 1
    bandwidth[bandwidth < 0] <- 0
    bandwidth <- unique(bandwidth)

  }

  #lock_step ----
  if(!is.null(lock_step)){

    if(any(is.logical(lock_step) == FALSE)){
      stop("distantia::utils_check_args_distantia(): Argument 'lock_step'", logical_message)
    }

  }

  #repetitions ----
  if(!is.null(repetitions)){

    repetitions <- as.integer(repetitions)
    if(any(is.integer(repetitions) == FALSE)){
      stop("distantia::utils_check_args_distantia(): argument 'repetitions' must be a integer or a numeric vector.", call. = FALSE)
    }


    ##permutation ----
    if(repetitions > 0){

      if(is.null(permutation)){
        permutation <- "restricted_by_row"
      }

      permutation <- match.arg(
        arg = permutation,
        choices = c(
          "restricted_by_row",
          "restricted",
          "free_by_row",
          "free"
        ),
        several.ok = TRUE
      )

      #block_size ----
      block_size <- utils_block_size(
        tsl = tsl,
        block_size = block_size
      )

      #seed ----
      seed <- as.integer(seed)
      if(any(is.integer(seed) == FALSE)){
        stop("distantia::utils_check_args_distantia(): argument 'block_size' must be a integer or a numeric vector.", call. = FALSE)
      }

    } else {

      permutation <- NULL
      block_size <- NULL
      seed <- NULL

    }

  }

  list(
    tsl = tsl,
    distance = distance,
    diagonal = diagonal,
    bandwidth = bandwidth,
    lock_step = lock_step,
    repetitions = repetitions,
    permutation = permutation,
    block_size = block_size,
    seed = seed
  )

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
      "distantia::utils_check_args_path() argument ",
      arg_name,
      " must not be NULL.",
      call. = FALSE
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
      "distantia::utils_check_args_path(): argument ",
      arg_name,
      " must be a data frame resulting from distantia::psi_cost_path().", call. = FALSE
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
      "distantia::utils_check_args_matrix(): argument ",
      arg_name,
      " must not be NULL.",
      call. = FALSE
    )
  }

  if(is.list(m)){

    if(length(m) > 1){
      warning(
        "distantia::utils_check_args_matrix(): Argument ",
        arg_name,
        " is a list with several matrices, but only the first one will be used. Please use the notation m = m[[index]] to select a different one.", call. = FALSE)
    }

    m <- m[[1]]

  }

  if(
    inherits(x = m, what = "matrix") == FALSE){
    stop(
      "distantia::utils_check_args_matrix(): Argument ",
      arg_name,
      " must be of the class 'matrix'.", call. = FALSE)
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
#' @family internal
utils_check_args_tsl <- function(
    tsl = NULL,
    min_length = 2
){

  if(is.null(tsl)){
    stop("distantia::utils_check_args_tsl(): argument 'tsl' must not be NULL.", call. = FALSE)
  }

  #check list class
  if(!is.list(tsl)){
    stop("distantia::utils_check_args_tsl(): argument 'tsl' must be a list.", call. = FALSE)
  }

  #check class of components
  tsl.class <- lapply(
    X = tsl,
    FUN = class
  ) |>
    unlist() |>
    unique()

  if(tsl.class != "zoo"){
    stop("distantia::utils_check_args_tsl(): argument 'tsl' must be a list of zoo objects.", call. = FALSE)
  }

  #check min length
  min_length <- abs(as.integer(min_length))
  if(length(tsl) < min_length){
    stop("distantia::utils_check_args_tsl(): argument 'tsl' must be a time series list with at least ", min_length, " zoo objects.", call. = FALSE)
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
    stop("distantia::utils_check_args_zoo(): argument ", arg_name, " must be a time series of class 'zoo'.", call. = FALSE)
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
    stop("distantia::utils_check_distance_args(): Please use distance names or abbreviations available in the data frame 'distances'.", call. = FALSE)
  }

  distances_df$name

}
