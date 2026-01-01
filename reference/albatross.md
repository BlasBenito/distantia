# Flight Path Time Series of Albatrosses in The Pacific

Daily mean flight path data of 4 individuals of Waved Albatross
(Phoebastria irrorata) captured via GPS during the summer of 2008. Sf
data frame with columns name, time, latitude, longitude, ground speed,
heading, and (uncalibrated) temperature.

The full dataset at hourly resolution can be downloaded from
<https://github.com/BlasBenito/distantia/blob/main/data_full/albatross.rda>
(use the "Download raw file" button).

## Usage

``` r
data(albatross)
```

## Format

data frame

## References

[doi:10.5441/001/1.3hp3s250](https://doi.org/10.5441/001/1.3hp3s250)

## See also

Other example_data:
[`cities_coordinates`](https://blasbenito.github.io/distantia/reference/cities_coordinates.md),
[`cities_temperature`](https://blasbenito.github.io/distantia/reference/cities_temperature.md),
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
#load as tsl
#scale al variables
#aggregate to daily resolution
#align all time series to same temporal span
tsl <- tsl_initialize(
  x = albatross,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_local
  ) |>
  tsl_aggregate(
    new_time = "days"
  )

if(interactive()){
  tsl_plot(
    tsl = tsl,
    guide_columns = 5
    )
}
```
