#' Spatial Network of Dissimilarities
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#' @param xy (required, sf POINT data frame) Default: NULL
#'
#' @return sf data frame
#' @export
#'
#' @examples
#' @autoglobal
distantia_spatial_network <- function(
    df = NULL,
    xy = NULL
){

  #check df
  if(is.null(df)){
    stop("Argument 'df' must be a dataframe resulting from distantia::distantia() or distantia::distantia_aggregate().")
  }

  df_type <- attributes(df)$type

  types <- c(
    "distantia_df"
  )

  if(!(df_type %in% types)){
    stop("Argument 'df' must be the output of distantia::distantia().")
  }

  df_names <- unique(c(df$x, df$y))

  #check if it needs aggregation
  df_aggregated <- distantia_aggregate(
    df = df
  )

  loss_cols <- setdiff(
    x = colnames(df),
    y = colnames(df_aggregated)
  )

  if(
    nrow(df_aggregated) < nrow(df) &&
    ncol(df_aggregated) < ncol(df)
    ){
    warning(
      "Argument 'df' was simplified via distantia::distantia_aggregate(), resulting the loss of the following columns: \n\n'",
      paste(loss_cols, collapse = "'\n'"),
    "'\n\nTo fix this issue, run distantia::distantia() or distantia::distantia_importance() with a single combination of arguments."
    )
  }

  # xy ----
  if(is.null(xy)){
    stop("Argument 'xy' must be a data frame with time series names and coordinates.")
  }

  ## find geometry ----
  if(inherits(x = xy, what = "sf") == FALSE){

    stop("Argument 'xy' must be an 'sf' data frame with a 'geometry' column of type 'POINT'.")

  }

  if(inherits(x = sf::st_geometry(xy), what = "sfc_POINT") == FALSE){

    stop("The 'geometry' column in 'xy' must be of type 'POINT'.")

  }

  ## find names column ----
  xy_names <- apply(
    X = xy,
    MARGIN = 2,
    FUN = function(x){
      if(all(df_names %in% x)){
        return(TRUE)
      } else {
        return(FALSE)
      }
    }
  )

  xy_names <- names(xy_names[xy_names == TRUE])

  if(!(xy_names %in% colnames(xy))){
    stop("Argument 'xy' must have a column with the time series names in 'df' (check values in df$x and df$y).")
  }

  ## add id column ----
  xy$id <- seq_len(nrow(xy))

  ## map id column in df ----
  df <- merge(
    x = df,
    y = sf::st_drop_geometry(xy[, c("id", xy_names)]),
    by.x = "x",
    by.y = xy_names
  )
  colnames(df)[colnames(df) == "id"] <- "id_x"

  df <- merge(
    x = df,
    y = sf::st_drop_geometry(xy[, c("id", xy_names)]),
    by.x = "y",
    by.y = xy_names
  )
  colnames(df)[colnames(df) == "id"] <- "id_y"


  # generate geonetwork ----

  ## function to create lines
  points_to_line <- function(id_x, id_y, xy) {

    xy[c(id_x, id_y), ] |>
      sf::st_coordinates() |>
      sf::st_linestring() |>
      sf::st_sfc()

  }

  ## generate lines list ----
  xy_lines_list <- mapply(
    FUN = points_to_line,
    df$id_x,
    df$id_y,
    MoreArgs = list(xy = xy)
  )

  ## to sf ----
  df_sf <- df |>
    sf::st_sf(
    geometry = sf::st_sfc(xy_lines_list),
    crs = sf::st_crs(xy)
  )

  ## arrange by psi ----
  df_sf <- df_sf[order(df_sf$psi), ]

  ## remove id columns
  df_sf$id_x <- NULL
  df_sf$id_y <- NULL

  df_sf

}
