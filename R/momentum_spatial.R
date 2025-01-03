#' Spatial Representation of `momentum()` Data Frames
#'
#' @description
#' Given an sf data frame with geometry types POLYGON, MULTIPOLYGON, or POINT representing time series locations, this function transforms the output of [momentum()], [momentum_ls()], [momentum_dtw()] to an sf data frame.
#'
#' If `network = TRUE`, the sf data frame is of type LINESTRING, with edges connecting time series locations. This output is helpful to build many-to-many dissimilarity maps (see examples).
#'
#' If `network = FALSE`, the sf data frame contains the geometry in the input `sf` argument. This output helps build one-to-many dissimilarity maps.
#'
#' @inheritParams momentum_to_wide
#' @inheritParams distantia_spatial
#' @examples
#' tsl <- distantia::tsl_initialize(
#'   x = distantia::eemian_pollen,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#' #reduce size to speed-up example runtime
#' distantia::tsl_subset(
#'   names = 1:3
#'   )
#'
#' df_momentum <- distantia::momentum(
#'   tsl = tsl
#' )
#'
#' #network many to many
#' sf_momentum <- distantia::momentum_spatial(
#'   df = df_momentum,
#'   sf = distantia::eemian_coordinates,
#'   network = TRUE
#' )
#'
#' #network map
#' # mapview::mapview(
#' #   sf_momentum,
#' #   layer.name = "Importance - Abies",
#' #   label = "edge_name",
#' #   zcol = "importance__Abies",
#' #   lwd = 3
#' # ) |>
#' #   suppressWarnings()
#'
#' @return sf data frame (LINESTRING geometry)
#' @export
#' @autoglobal
#' @family momentum_support
momentum_spatial <- distantia_spatial
