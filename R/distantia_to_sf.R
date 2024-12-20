#' Convert Dissimilarity Analysis Data Frames to Spatial Dissimilarity Networks
#'
#' @description
#' Given an sf data frame with the coordinates of a time series list transforms a data frame resulting from [distantia()] to an sf data frame with lines connecting the time series locations. This can be used to visualize a geographic network of similarity/dissimilarity between locations. See example for further details.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#' @param xy (required, sf POINT data frame) Sf data frame with the coordinates of the time series in argument 'df'. It must have a column with all time series names in `df$x` and `df$y`. See `[eemian_cooordinaes]` example. Default: NULL
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
#' distantia_sf <- distantia::distantia_to_sf(
#'   df = distantia_df,
#'   xy = fagus_coordinates
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
#' importance_sf <- distantia::distantia_to_sf(
#'   df = importance_df,
#'   xy = fagus_coordinates
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
distantia_to_sf <- function(
    df = NULL,
    xy = NULL
){

  if(
    requireNamespace(
      package = "sf",
      quietly = TRUE
    ) == FALSE){
    stop("distantia::distantia_to_sf(): please install the package 'sf' before running this function.", call. = FALSE)
  }

  #check df
  if(is.null(df)){
    stop("distantia::distantia_to_sf(): argument 'df' must be a data frame resulting from distantia::distantia() or distantia::distantia_aggregate().", call. = FALSE)
  }

  df_type <- attributes(df)$type

  types <- c(
    "distantia_df",
    "momentum_df"
  )

  if(!(df_type %in% types)){
    stop("distantia::distantia_to_sf(): argument 'df' must be the output of distantia::distantia().", call. = FALSE)
  }

  df_names <- unique(c(df$x, df$y))

  #check if it needs aggregation
  df <- distantia_aggregate(
    df = df
  )

  if(df_type == "momentum_df"){
    df <- momentum_to_wide(
      df = df
    )
  }

  # xy ----
  if(is.null(xy)){
    stop("distantia::distantia_to_sf(): argument 'xy' must be a data frame with time series names and coordinates.", call. = FALSE)
  }

  ## find geometry ----
  if(inherits(x = xy, what = "sf") == FALSE){

    stop("distantia::distantia_to_sf(): argument 'xy' must be an 'sf' data frame with a 'geometry' column of type 'POINT'.", call. = FALSE)

  }

  if(inherits(x = sf::st_geometry(xy), what = "sfc_POINT") == FALSE){

    stop("distantia::distantia_to_sf(): The 'geometry' column in 'xy' must be of type 'POINT'.", call. = FALSE)

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
    stop("distantia::distantia_to_sf(): Argument 'xy' must have a column with the time series names in 'df' (check values in df$x and df$y).")
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

  colnames(df)[colnames(df) == "name"] <- "id_x"

  df <- merge(
    x = df,
    y = sf::st_drop_geometry(xy[, c("id", xy_names)]),
    by.x = "y",
    by.y = xy_names
  )

  colnames(df)[colnames(df) == "name"] <- "id_y"


  # generate network ----

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
    df$id.x,
    df$id.y,
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

  ## create name column
  old_colnames <- colnames(df_sf)

  df_sf$edge_name <- paste(df_sf$x, "-", df_sf$y)

  #put name in first column
  df_sf <- df_sf[, c("edge_name", old_colnames)]

  df_sf

}
