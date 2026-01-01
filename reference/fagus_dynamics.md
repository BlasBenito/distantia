# Time Series Data from Three Fagus sylvatica Stands

A data frame with 648 rows representing enhanced vegetation index,
rainfall and temperature in three stands of Fagus sylvatica in Spain,
Germany, and Sweden.

## Usage

``` r
data(fagus_dynamics)
```

## Format

data frame with 5 columns and 648 rows.

## Details

Site coordinates for this dataset are in
[fagus_coordinates](https://blasbenito.github.io/distantia/reference/fagus_coordinates.md).

## See also

Other example_data:
[`albatross`](https://blasbenito.github.io/distantia/reference/albatross.md),
[`cities_coordinates`](https://blasbenito.github.io/distantia/reference/cities_coordinates.md),
[`cities_temperature`](https://blasbenito.github.io/distantia/reference/cities_temperature.md),
[`covid_counties`](https://blasbenito.github.io/distantia/reference/covid_counties.md),
[`covid_prevalence`](https://blasbenito.github.io/distantia/reference/covid_prevalence.md),
[`eemian_coordinates`](https://blasbenito.github.io/distantia/reference/eemian_coordinates.md),
[`eemian_pollen`](https://blasbenito.github.io/distantia/reference/eemian_pollen.md),
[`fagus_coordinates`](https://blasbenito.github.io/distantia/reference/fagus_coordinates.md),
[`honeycomb_climate`](https://blasbenito.github.io/distantia/reference/honeycomb_climate.md),
[`honeycomb_polygons`](https://blasbenito.github.io/distantia/reference/honeycomb_polygons.md)

## Examples

``` r
data("fagus_dynamics")

#to time series list
fagus <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

#time series plot
if(interactive()){

 tsl_plot(
  tsl = fagus
  )

}
```
