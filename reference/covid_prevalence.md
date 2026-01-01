# Time Series of Covid Prevalence in California Counties

Dataset with Covid19 maximum weekly prevalence in California counties
between 2020 and 2024, from healthdata.gov.

## Usage

``` r
data(covid_prevalence)
```

## Format

data frame with 3 columns and 51048 rows

## Details

County polygons and additional data for this dataset are in
[covid_counties](https://blasbenito.github.io/distantia/reference/covid_counties.md).

The full dataset at daily resolution can be downloaded from
<https://github.com/BlasBenito/distantia/blob/main/data_full/covid_prevalence.rda>
(use the "Download raw file" button).

## See also

Other example_data:
[`albatross`](https://blasbenito.github.io/distantia/reference/albatross.md),
[`cities_coordinates`](https://blasbenito.github.io/distantia/reference/cities_coordinates.md),
[`cities_temperature`](https://blasbenito.github.io/distantia/reference/cities_temperature.md),
[`covid_counties`](https://blasbenito.github.io/distantia/reference/covid_counties.md),
[`eemian_coordinates`](https://blasbenito.github.io/distantia/reference/eemian_coordinates.md),
[`eemian_pollen`](https://blasbenito.github.io/distantia/reference/eemian_pollen.md),
[`fagus_coordinates`](https://blasbenito.github.io/distantia/reference/fagus_coordinates.md),
[`fagus_dynamics`](https://blasbenito.github.io/distantia/reference/fagus_dynamics.md),
[`honeycomb_climate`](https://blasbenito.github.io/distantia/reference/honeycomb_climate.md),
[`honeycomb_polygons`](https://blasbenito.github.io/distantia/reference/honeycomb_polygons.md)

## Examples

``` r
#to time series list
tsl <- tsl_initialize(
  x = covid_prevalence,
  name_column = "name",
  time_column = "time"
)

#time series plot
if(interactive()){

 #subset to avoid margin errors
 tsl_plot(
  tsl = tsl_subset(
    tsl = tsl,
    names = 1:4
    ),
  guide = FALSE
  )

}
```
