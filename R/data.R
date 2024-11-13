#' Distance Methods
#'
#' Data frame with the names, abbreviations, and expressions of the distance metrics implemented in the package.
#'
#'
#' @docType data
#' @keywords datasets
#' @family psi_demo
#' @name distances
#' @usage data(distances)
#' @format data frame with 5 columns and 10 rows
"distances"

#' Time Series of Covid Prevalence in California Counties
#'
#' Dataset with Covid19 prevalence time series in California counties between 2020 and 2024, from healthdata.gov.
#'
#' Site coordinates for this dataset are in [covid_coordinates].
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name covid_prevalence
#' @usage data(covid_prevalence)
#' @examples
#' #to time series list
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   id_column = "county",
#'   time_column = "date"
#' )
#'
#' #time series plot
#' if(interactive()){
#'
#'  #subset to avoid margin errors
#'  tsl_plot(
#'   tsl = tsl_subset(
#'     tsl = tsl,
#'     names = 1:4
#'     ),
#'   guide = FALSE
#'   )
#'
#' }
#' @format data frame with 3 columns and 51048 rows
"covid_prevalence"

#' County Coordinates of the Covid Prevalence Dataset
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name covid_coordinates
#' @usage data(covid_coordinates)
#' @format sf data frame with 4 columns and 36 rows
"covid_coordinates"

#' Pollen Counts of 12 Marine Isotope Stages
#'
#' A data frame with 427 rows representing pollen counts for 12 marine isotope stages and 6 pollen types
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name mis
#' @usage data(mis)
#' @examples
#' #to time series list
#' tsl <- tsl_initialize(
#'   x = mis,
#'   id_column = "mis",
#'   time_column = "sample_order"
#' )
#'
#' #time series plot
#' if(interactive()){
#'
#'  tsl_plot(
#'   tsl = tsl_subset(
#'     tsl = tsl,
#'     names = 1:3
#'     ),
#'   guide_columns = 2
#'   )
#'
#' }
#'
#' @format data frame with 8 columns and 427 rows.
"mis"


#' Time Series Data from Three Fagus sylvatica Stands
#'
#' A data frame with 648 rows representing enhanced vegetation index, rainfall and temperature in three stands of Fagus sylvatica in Spain, Germany, and Sweden.
#'
#' Site coordinates for this dataset are in [fagus_coordinates].
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name fagus_dynamics
#' @usage data(fagus_dynamics)
#' @examples
#' data("fagus_dynamics")
#'
#' #to time series list
#' fagus <- tsl_initialize(
#'   x = fagus_dynamics,
#'   id_column = "site",
#'   time_column = "date"
#' )
#'
#' #time series plot
#' if(interactive()){
#'
#'  tsl_plot(
#'   tsl = fagus
#'   )
#'
#' }
#'
#' @format data frame with 5 columns and 648 rows.
"fagus_dynamics"

#' Site Coordinates of Fagus sylvatica Stands
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name fagus_coordinates
#' @usage data(fagus_coordinates)
#' @format sf data frame with 3 rows and 4 columns
"fagus_coordinates"


#' Pollen Counts of Nine Interglacial Sites in Central Europe
#'
#' @description
#'
#' Pollen ounts of nine interglacial sites in central Europe.
#'
#' Site coordinates for this dataset are in [eemian_coordinates].
#'
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name eemian_pollen
#' @usage data(eemian_pollen)
#' @examples
#' data("eemian_pollen")
#'
#' #to time series list
#' tsl <- tsl_initialize(
#'   x = eemian_pollen,
#'   id_column = "site",
#'   time_column = "depth"
#' )
#'
#' #time series plot
#' if(interactive()){
#'
#'  tsl_plot(
#'   tsl = tsl_subset(
#'     tsl = tsl,
#'     names = 1:3
#'     ),
#'   columns = 2,
#'   guide_columns = 2
#'   )
#'
#' }
#'
#' @format data frame with 24 columns and 376 rows.
"eemian_pollen"

#' Site Coordinates of Nine Interglacial Sites in Central Europe
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @family example_data
#' @name eemian_coordinates
#' @usage data(eemian_coordinates)
#' @format sf data frame with 4 columns and 9 rows.
"eemian_coordinates"

#' Long Term Monthly Temperature in 100 Major Cities
#'
#' @description
#' Average temperatures between 1975 and 2010 of 100 major cities of the world. [Source](https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data?resource=download&select=GlobalLandTemperaturesByMajorCity.csv).
#'
#' Site coordinates for this dataset are in [cities_coordinates].
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name cities_temperature
#' @usage data(cities_temperature)
#' @examples
#' data("cities_temperature")
#'
#' #to time series list
#' cities <- tsl_initialize(
#'   x = cities_temperature,
#'   id_column = "city",
#'   time_column = "date"
#' )
#'
#' #time series plot
#' if(interactive()){
#'
#'  #only four cities are shown
#'  tsl_plot(
#'   tsl = tsl_subset(
#'     tsl = tsl,
#'     names = 1:4
#'     ),
#'   guide = FALSE
#'   )
#'
#' }
#' @format data frame with 3 columns and 52100 rows.
"cities_temperature"


#' Coordinates of 100 Major Cities
#'
#' @description
#' City coordinates for the dataset `cities_temperature`.
#'
#' @docType data
#' @keywords datasets
#' @family example_data
#' @family example_data
#' @name cities_coordinates
#' @usage data(cities_coordinates)
#' @format sf data frame with 5 columns and 100 rows.
"cities_coordinates"


#' Flight Path Time Series of Albatrosses in The Pacific
#'
#' @description
#' Data frame with id, time, latitude, longitude, ground speed, heading, and (uncalibrated) temperature of the flight paths of 5 individuals of Waved Albatross (Phoebastria irrorata) captured via GPS during the summer of 2008.
#' @references \doi{10.5441/001/1.3hp3s250}
#' @docType data
#' @keywords datasets
#' @family example_data
#' @name albatross
#' @usage data(albatross)
#' @examples
#' #load as tsl
#' #scale al variables
#' #aggregate to daily resolution
#' #align all time series to same temporal span
#' tsl <- tsl_initialize(
#'   x = albatross,
#'   id_column = "id",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale
#'   ) |>
#'   tsl_aggregate(
#'     new_time = "days"
#'   )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     guide_columns = 5
#'     )
#' }
#' @format data frame
"albatross"
