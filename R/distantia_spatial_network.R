#' Convert Dissimilarity Analysis Data Frames to Spatial Dissimilarity Networks
#'
#' @description
#' Given an sf data frame with the coordinates of a time series list transforms a data frame resulting from [distantia()] to an sf data frame with lines connecting the time series locations. This can be used to visualize a geographic network of similarity/dissimilarity between locations. See example for further details.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#' @param sf (required, sf data frame) Points or polygons representing the location of the time series in argument 'df'. It must have a column with all time series names in `df$x` and `df$y`. Default: NULL
#' @param one_to_many (optional, logical) If TRUE, the resulting data frame is reorganized to help map one-to-many relationships using the original geometry in `sf` rather than network edges. Default: FALSE
#'
#' @return sf data frame (LINESTRING geometry)
#' @export
#'
#' @examples
#' tsl <- distantia::tsl_initialize(
#'   x = distantia::covid_prevalence,
#'   name_column = "name",
#'   time_column = "time"
#' )
#'
#' df_psi <- distantia::distantia_ls(
#'   tsl = tsl
#' )
#'
#' #network many to many
#' sf_network <- distantia::distantia_spatial_network(
#'   df = df_psi,
#'   sf = distantia::covid_counties
#' )
#'
#' #subset target counties
#' counties <- c("Los_Angeles", "San_Francisco", "Fresno", "San_Joaquin")
#'
#' sf_network_subset <- sf_network[
#'   which(sf_network$x %in% counties & sf_network$y %in% counties), ]
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
#' #     sf_network_subset,
#' #     layer.name = "Psi",
#' #     label = "edge_name",
#' #     zcol = "psi",
#' #     lwd = 3
#' #   ) |>
#' #   suppressWarnings()
#'
#' #one to many
#' sf_network <- distantia_spatial_network(
#'   df = df_psi,
#'   sf = distantia::covid_counties,
#'   one_to_many = TRUE
#' )
#'
#' #subset one county
#' sf_network_subset <- sf_network[sf_network$x == "Los_Angeles", ]
#'
#' #one to many map
#' #dissimilarity of all counties with Los Angeles
#' # mapview::mapview(
#' #   sf_network_subset,
#' #   layer.name = "Psi with LA",
#' #   label = "y",
#' #   zcol = "psi",
#' #   alpha.regions = 1
#' # ) |>
#' #   suppressWarnings()
#' @autoglobal
#' @family distantia_support
distantia_spatial_network <- function(
    df = NULL,
    sf = NULL,
    one_to_many = FALSE
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
    stop("distantia::distantia_spatial_network(): argument 'df' must be the output of distantia::distantia(), distantia::distantia_dtw_shift(), or distantia::momentum().", call. = FALSE)
  }

  df_names <- unique(c(df$x, df$y))

  if(df_type == "momentum_df")
    df <- momentum_aggregate(
      df = df
    ) else {
      df <- distantia_aggregate(
        df = df
      )
    }

  if(df_type == "momentum_df"){
    df <- momentum_to_wide(
      df = df
    )
  }

  # sf ----
  if(is.null(sf)){
    stop("distantia::distantia_spatial_network(): argument 'sf' must be an sf data frame.", call. = FALSE)
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

  #apply one_to_many
  if(one_to_many == TRUE){

    #prepare y vs x mirror
    df_mirror <- df
    df_mirror$x <- df$y
    df_mirror$y <- df$x

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
      df_self[[col.i]] <- ifelse(
        test = col.i %in% c("psi", "p_value"),
        yes = 0,
        no = NA
      )
    }

    #join all rows
    df <- rbind(
      df,
      df_mirror,
      df_self
    )

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

  rownames(df_sf) <- NULL

  df_sf

}
