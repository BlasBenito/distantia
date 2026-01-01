# Pollen Counts of Nine Interglacial Sites in Central Europe

Pollen counts of nine interglacial sites in central Europe.

Site coordinates for this dataset are in
[eemian_coordinates](https://blasbenito.github.io/distantia/reference/eemian_coordinates.md).

## Usage

``` r
data(eemian_pollen)
```

## Format

data frame with 24 columns and 376 rows.

## See also

Other example_data:
[`albatross`](https://blasbenito.github.io/distantia/reference/albatross.md),
[`cities_coordinates`](https://blasbenito.github.io/distantia/reference/cities_coordinates.md),
[`cities_temperature`](https://blasbenito.github.io/distantia/reference/cities_temperature.md),
[`covid_counties`](https://blasbenito.github.io/distantia/reference/covid_counties.md),
[`covid_prevalence`](https://blasbenito.github.io/distantia/reference/covid_prevalence.md),
[`eemian_coordinates`](https://blasbenito.github.io/distantia/reference/eemian_coordinates.md),
[`fagus_coordinates`](https://blasbenito.github.io/distantia/reference/fagus_coordinates.md),
[`fagus_dynamics`](https://blasbenito.github.io/distantia/reference/fagus_dynamics.md),
[`honeycomb_climate`](https://blasbenito.github.io/distantia/reference/honeycomb_climate.md),
[`honeycomb_polygons`](https://blasbenito.github.io/distantia/reference/honeycomb_polygons.md)

## Examples

``` r
data("eemian_pollen")

#to time series list
tsl <- tsl_initialize(
  x = eemian_pollen,
  name_column = "name",
  time_column = "time"
)
#> distantia::utils_prepare_time():  duplicated time indices in 'Krumbach_I':
#> - value 6.8 replaced with 6.825.

#time series plot
if(interactive()){

 tsl_plot(
  tsl = tsl_subset(
    tsl = tsl,
    names = 1:3
    ),
  columns = 2,
  guide_columns = 2
  )

}
```
