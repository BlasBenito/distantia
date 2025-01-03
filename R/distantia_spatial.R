#' Spatial Representation of `distantia()` Data Frames
#'
#' @description
#' Given an sf data frame with geometry types POLYGON, MULTIPOLYGON, or POINT representing time series locations, this function transforms the output of [distantia()], [distantia_ls()], [distantia_dtw()] or [distantia_time_shift()] to an sf data frame.
#'
#' If `network = TRUE`, the sf data frame is of type LINESTRING, with edges connecting time series locations. This output is helpful to build many-to-many dissimilarity maps (see examples).
#'
#' If `network = FALSE`, the sf data frame contains the geometry in the input `sf` argument. This output helps build one-to-many dissimilarity maps.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_time_shift()]. Default: NULL
#' @param sf (required, sf data frame) Points or polygons representing the location of the time series in argument 'df'. It must have a column with all time series names in `df$x` and `df$y`. Default: NULL
#' @param network (optional, logical) If TRUE, the resulting sf data frame is of time LINESTRING and represent network edges. Default: TRUE
#'
#' @return sf data frame (LINESTRING geometry)
#' @export
#'
#' @examples
#' tsl <- distantia::tsl_initialize(
#'   x = distantia::covid_prevalence,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#' distantia::tsl_subset(
#'   names = c(
#'     "Los_Angeles",
#'     "San_Francisco",
#'     "Fresno",
#'     "San_Joaquin"
#'     )
#'  )
#'
#' df_psi <- distantia::distantia_ls(
#'   tsl = tsl
#' )
#'
#' #network many to many
#' sf_psi <- distantia::distantia_spatial(
#'   df = df_psi,
#'   sf = distantia::covid_counties,
#'   network = TRUE
#' )
#'
#' #network map
#' # mapview::mapview(
#' #   distantia::covid_counties,
#' #   col.regions = NA,
#' #   alpha.regions = 0,
#' #   color = "black",
#' #   label = "name",
#' #   legend = FALSE,
#' #   map.type = "OpenStreetMap"
#' # ) +
#' #   mapview::mapview(
#' #     sf_psi_subset,
#' #     layer.name = "Psi",
#' #     label = "edge_name",
#' #     zcol = "psi",
#' #     lwd = 3
#' #   ) |>
#' #   suppressWarnings()
#'
#' @autoglobal
#' @family distantia_support
distantia_spatial <- function(
    df = NULL,
    sf = NULL,
    network = TRUE
){

  if(
    requireNamespace(
      package = "sf",
      quietly = TRUE
    ) == FALSE){
    stop("distantia::distantia/momentum_spatial(): this function requires installing the package 'sf'.", call. = FALSE)
  }

  #check df
  if(is.null(df)){
    stop("distantia::distantia/momentum_spatial(): argument 'df' must be a data frame resulting from distantia::distantia() or distantia::momentum().", call. = FALSE)
  }

  df_type_distantia <- c(
    "distantia_df",
    "time_shift_df"
  )

  df_type_momentum <- "momentum_df"

  df_types <- c(
    df_type_distantia,
    df_type_momentum
  )

  df_type <- attributes(df)$type

  if(
    is.null(df_type) ||
    !(df_type %in% df_types)
    ){
    stop("distantia::distantia/momentum_spatial(): argument 'df' must be the output of distantia::distantia(), distantia::distantia_time_shift(), or distantia::momentum().", call. = FALSE)
  }

  if(df_type %in% df_type_distantia){

    f_name <- "distantia::distantia_spatial(): "

    if(df_type == "distantia_df"){

      df <- distantia_aggregate(
        df = df
      )

    }
  }

  if(df_type == df_type_momentum){

    f_name <- "distantia::momentum_spatial(): "

    df <- df |>
      momentum_aggregate() |>
      momentum_to_wide()

  }

  # sf ----
  if(is.null(sf)){
    stop(f_name, "argument 'sf' must be an sf data frame.", call. = FALSE)
  }

  ## find geometry ----
  if(inherits(x = sf, what = "sf") == FALSE){
    stop(f_name, "argument 'sf' must be an 'sf' data frame.", call. = FALSE)
  }

  ## find names column ----
  df_names <- unique(c(df$x, df$y))

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

  if(sf_names %in% colnames(df)){
    df[[sf_names]] <- NULL
  }

  ## remove common columns in sf
  sf_valid_columns <- setdiff(
    x = colnames(sf),
    y = colnames(df)
  )

  sf <- sf[, sf_valid_columns]

  #prepare y vs x mirror
  df_mirror <- df
  df_mirror$x <- df$y
  df_mirror$y <- df$x

  #prepare and return non-network output
  if(network == FALSE){

    #prepare rows of self x vs y
    df_self <- data.frame(
      x = unique(df$x),
      y = unique(df$x)
    )

    df_self_cols <- setdiff(
      x = colnames(df),
      y = c("x", "y")
    )

    for(col.i in df_self_cols){
      if(is.numeric(df[[col.i]])){
        df_self[[col.i]] <- 0
      } else {
        df_self[[col.i]] <- NA
      }
    }

    #join all rows
    df <- rbind(
      df,
      df_mirror,
      df_self
    )

    #remove duplicates
    df$xy <- paste(df$x, df$y)
    df <- df[!duplicated(df$xy), ]
    df$xy <- NULL

    #create join column
    df[[sf_names]] <- df$y

    #merge sf
    df_sf <- merge(
      x = sf,
      y = df,
      by = sf_names
    )

    #remove merge column
    df_sf[[sf_names]] <- NULL

    #order by names
    df_sf <- df_sf[order(df_sf$x, df_sf$y), ]

    rownames(df_sf) <- NULL

    return(df_sf)

  }

  #building network

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

  rownames(df_sf) <- NULL

  df_sf

}
