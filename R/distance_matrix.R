#' Data Frame to Distance Matrix
#'
#' @param df (required, data frame) Data frame with numeric columns to transform into a distance matrix. Default: NULL
#' @inheritParams tsl_initialize
#' @inheritParams distantia
#' @return square matrix
#' @export
#' @autoglobal
#' @examples
#' #compute distance matrix
#' m <- distance_matrix(
#'   df = cities_coordinates,
#'   name_column = "name",
#'   distance = "euclidean"
#' )
#'
#' #get data used to compute the matrix
#' attributes(m)$df
#'
#' #check matrix
#' m
#'
#' @family distances
distance_matrix <- function(
    df = NULL,
    name_column = NULL,
    distance = "euclidean"
){

  # df <- fagus_coordinates
  # name_column <- "name"

  if(is.null(df)){
    stop(
      "distantia::d_matrix(): argument 'df' must not be NULL.",
      call. = FALSE
    )
  }

  #check distance arg
  distance <- utils_check_distance_args(
    distance = distance
  )

  #drop geometry
  df <- distantia::utils_drop_geometry(
    df = df
  )

  #subset names
  if(
    !is.null(name_column) &&
    name_column %in% colnames(df)
  ){

    name <- as.character(df[[name_column]])
    df[[name_column]] <- NULL

  } else {
    name <- NULL
  }


  #subset numeric columns
  df <- df[,
           sapply(
             X = df,
             FUN = is.numeric
             ),
           drop = FALSE
           ]

  if(ncol(df) == 0){
    stop(
      "distantia::d_matrix(): argument 'df' must have at least one numeric column.",
      call. = FALSE
    )
  }

  #coerce to matrix
  df_matrix <- as.matrix(df)

  #compute distance matrix
  m <- distance_matrix_cpp(
    x = df_matrix,
    y = df_matrix,
    distance = distance
  )

  #add col and row names
  if(!is.null(name)){
    dimnames(m) <- list(
      as.character(name),
      as.character(name)
    )
  }

  #attributes
  attr(x = m, which = "type") <- "distance"
  attr(x = m, which = "distance") <- distance
  attr(x = m, which = "df") <- df


  m

}
