#' Convert Dissimilarity Analysis Data Frames to Spatial Dissimilarity Networks
#'
#' @description
#' Given an sf data frame with the coordinates of a time series list transforms a data frame resulting from [distantia()] to an sf data frame with lines connecting the time series locations. This can be used to visualize a geographic network of similarity/dissimilarity between locations. See example for further details.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#' @param sf (required, sf POINT data frame) Sf data frame with the coordinates of the time series in argument 'df'. It must have a column with all time series names in `df$x` and `df$y`. See `[eemian_cooordinaes]` example. Default: NULL
#'
#' @return sf data frame (LINESTRING geometry)
#' @export
#'
#' @examples
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' data("fagus_dynamics")
#' data("fagus_coordinates")
#'
#' #load as tsl
#' #center and scale with same parameters
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global
#'   )
#'
#' #example using distantia()
#' #--------------------------------------------------
#' distantia_df <- distantia(
#'   tsl = tsl
#' )
#'
#' #transform to sf
#' distantia_sf <- distantia::distantia_spatial_network(
#'   df = distantia_df,
#'   sf = fagus_coordinates
#' )
#'
#' #mapping with tmap
#' # library(tmap)
#' # tmap::tmap_mode("view")
#' #
#' # tmap::tm_shape(distantia_sf) +
#' #   tmap::tm_lines(
#' #     col = "psi",
#' #     lwd = 3
#' #   ) +
#' #   tmap::tm_shape(fagus_coordinates) +
#' #   tmap::tm_dots(size = 0.1, col = "gray50")
#'
#'
#' #example using momentum()
#' #--------------------------------------------------
#' importance_df <- momentum(
#'   tsl = tsl
#' )
#'
#' #transform to sf
#' importance_sf <- distantia::distantia_spatial_network(
#'   df = importance_df,
#'   sf = fagus_coordinates
#' )
#'
#' names(importance_sf)
#'
#' # #map contribution to dissimilarity of evi
#' # #negative: contributes to similarity
#' # #positive: contributes to dissimilarity
#' # tmap::tm_shape(importance_sf) +
#' #   tmap::tm_lines(
#' #     col = "importance__evi",
#' #     lwd = 3,
#' #     midpoint = NA
#' #   ) +
#' #   tmap::tm_shape(fagus_coordinates) +
#' #   tmap::tm_dots(size = 0.1, col = "gray50")
#' #
#' # #map variables making sites more similar
#' # tmap::tm_shape(importance_sf) +
#' #   tmap::tm_lines(
#' #     col = "most_similar",
#' #     lwd = 3
#' #   ) +
#' #   tmap::tm_shape(fagus_coordinates) +
#' #   tmap::tm_dots(size = 0.1, col = "gray50")
#' #
#' # #map variables making sites less similar
#' # tmap::tm_shape(importance_sf) +
#' #   tmap::tm_lines(
#' #     col = "most_dissimilar",
#' #     lwd = 3
#' #   ) +
#' #   tmap::tm_shape(fagus_coordinates) +
#' #   tmap::tm_dots(size = 0.1, col = "gray50")
#' @autoglobal
#' @family dissimilarity_analysis
distantia_spatial_network <- function(
    df = NULL,
    sf = NULL
){

  if(
    requireNamespace(
      package = "sf",
      quietly = TRUE
    ) == FALSE){
    stop("distantia::distantia_spatial_network(): please install the package 'sf' before running this function.", call. = FALSE)
  }

  #check df
  if(is.null(df)){
    stop("distantia::distantia_spatial_network(): argument 'df' must be a data frame resulting from distantia::distantia() or distantia::distantia_aggregate().", call. = FALSE)
  }

  df_type <- attributes(df)$type

  types <- c(
    "distantia_df",
    "momentum_df",
    "time_shift_df"
  )

  if(!(df_type %in% types)){
    stop("distantia::distantia_spatial_network(): argument 'df' must be the output of distantia::distantia(), distantia::distantia_time_shift(), or distantia::momentum().", call. = FALSE)
  }

  df_names <- unique(c(df$x, df$y))

  df <- distantia_aggregate(
    df = df
  )

  if(df_type == "momentum_df"){
    df <- momentum_to_wide(
      df = df
    )
  }

  # sf ----
  if(is.null(sf)){
    stop("distantia::distantia_spatial_network(): argument 'sf' must be an sf data frame.", call. = FALSE)
  }

  ## find geometry ----
  if(inherits(x = sf, what = "sf") == FALSE){
    stop("distantia::distantia_spatial_network(): argument 'sf' must be an 'sf' data frame with a 'geometry' column of type 'POINT'.", call. = FALSE)
  }

  #check geometry type
  sf_geometry_type <- sf |>
    sf::st_geometry_type() |>
    unique() |>
    as.character()

  #if polygons, compute centroids
  if(any(c("POLYGON", "MULTIPOLYGON") %in% sf_geometry_type)){

    sf <- sf::st_set_geometry(
      sf,
      sf::st_centroid(
        x = sf::st_geometry(obj = sf),
        of_largest_polygon = TRUE
        )
      )

  }

  ## find names column ----
  sf_names <- apply(
    X = sf,
    MARGIN = 2,
    FUN = function(x){
      if(all(df_names %in% x)){
        return(TRUE)
      } else {
        return(FALSE)
      }
    }
  )

  sf_names <- names(sf_names[sf_names == TRUE])

  if(!(sf_names %in% colnames(sf))){
    stop("distantia::distantia_spatial_network(): Argument 'sf' must have a column with the time series names in 'df' (check values in df$x and df$y).")
  }

  ## add id column ----
  sf$id <- seq_len(nrow(sf))

  ## map id column in df ----
  df <- merge(
    x = df,
    y = sf::st_drop_geometry(sf[, c("id", sf_names)]),
    by.x = "x",
    by.y = sf_names
  )

  colnames(df)[colnames(df) == "name"] <- "id_x"

  df <- merge(
    x = df,
    y = sf::st_drop_geometry(sf[, c("id", sf_names)]),
    by.x = "y",
    by.y = sf_names
  )

  colnames(df)[colnames(df) == "name"] <- "id_y"


  # generate network ----

  ## function to create lines
  points_to_line <- function(id_x, id_y, sf) {

    sf[c(id_x, id_y), ] |>
      sf::st_coordinates() |>
      sf::st_linestring() |>
      sf::st_sfc()

  }

  ## generate lines list ----
  sf_lines_list <- mapply(
    FUN = points_to_line,
    df$id.x,
    df$id.y,
    MoreArgs = list(sf = sf)
  )

  ## to sf ----
  df_sf <- df |>
    sf::st_sf(
    geometry = sf::st_sfc(sf_lines_list),
    crs = sf::st_crs(sf)
  )

  ## arrange by psi ----
  df_sf <- df_sf[order(df_sf$psi), ]

  ## remove id columns
  df_sf$id.x <- NULL
  df_sf$id.y <- NULL

  ## create name column
  old_colnames <- colnames(df_sf)

  df_sf$edge_name <- paste(df_sf$x, "-", df_sf$y)

  #put name in first column
  df_sf <- df_sf[, c("edge_name", old_colnames)]

  #length
  df_sf$length <- sf::st_length(
    x = df_sf
  ) |>
    as.numeric()

  df_sf

}
