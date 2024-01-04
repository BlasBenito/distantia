#' Handles Distance Argument
#'
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return Character vector with distance names
#' @export
#' @autoglobal
#' @examples
#'
#' distance_arg(
#'   distance = c(
#'     "euclidean",
#'     "euc"
#'    )
#'   )
#'
argument_distance <- function(
    distance
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
