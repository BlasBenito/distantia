# Long Term Monthly Temperature in 20 Major Cities

Average temperatures between 1975 and 2010 of 20 major cities of the
world.
[Source](https://www.kaggle.com/datasets/berkeleyearth/climate-change-earth-surface-temperature-data?resource=download&select=GlobalLandTemperaturesByMajorCity.csv).

Site coordinates for this dataset are in
[cities_coordinates](https://blasbenito.github.io/distantia/reference/cities_coordinates.md).

The full dataset with 100 cities can be downloaded from
<https://github.com/BlasBenito/distantia/blob/main/data_full/cities_temperature.rda>
(use the "Download raw file" button).

## Usage

``` r
data(cities_temperature)
```

## Format

data frame with 3 columns and 52100 rows.

## See also

Other example_data:
[`albatross`](https://blasbenito.github.io/distantia/reference/albatross.md),
[`cities_coordinates`](https://blasbenito.github.io/distantia/reference/cities_coordinates.md),
[`covid_counties`](https://blasbenito.github.io/distantia/reference/covid_counties.md),
[`covid_prevalence`](https://blasbenito.github.io/distantia/reference/covid_prevalence.md),
[`eemian_coordinates`](https://blasbenito.github.io/distantia/reference/eemian_coordinates.md),
[`eemian_pollen`](https://blasbenito.github.io/distantia/reference/eemian_pollen.md),
[`fagus_coordinates`](https://blasbenito.github.io/distantia/reference/fagus_coordinates.md),
[`fagus_dynamics`](https://blasbenito.github.io/distantia/reference/fagus_dynamics.md),
[`honeycomb_climate`](https://blasbenito.github.io/distantia/reference/honeycomb_climate.md),
[`honeycomb_polygons`](https://blasbenito.github.io/distantia/reference/honeycomb_polygons.md)

## Examples

``` r
data("cities_temperature")

#to time series list
cities <- tsl_initialize(
  x = cities_temperature,
  name_column = "name",
  time_column = "time"
)

#time series plot
if(interactive()){

 #only four cities are shown
 tsl_plot(
  tsl = tsl_subset(
    tsl = tsl,
    names = 1:4
    ),
  guide = FALSE
  )

}
```
